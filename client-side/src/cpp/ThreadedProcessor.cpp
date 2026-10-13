#include "ThreadedProcessor.h"

#include <QtCore/QDebug>
#include <QtCore/QtGlobal>

#include <algorithm>
#include <numeric>

class PrimeWorker final : public QObject
{
    Q_OBJECT

public:
    PrimeWorker(int index,
                const std::atomic_bool *cancelRequested,
                std::atomic_int *nextCandidate,
                int candidateLimit)
        : m_index{index}
        , m_cancelRequested{cancelRequested}
        , m_nextCandidate{nextCandidate}
        , m_candidateLimit{candidateLimit}
    {
    }

public slots:
    void calculate()
    {
        int processed{0};
        int primesFound{0};
        bool cancelled{false};

        // Work is handed out in blocks from a shared atomic counter, so
        // faster (or less busy) threads simply claim more blocks. Larger
        // numbers take longer to test, which makes fixed ranges unbalanced.
        while (!cancelled) {
            const int begin{m_nextCandidate->fetch_add(BlockSize, std::memory_order_relaxed)};
            if (begin > m_candidateLimit) {
                break;
            }
            const int end{std::min(begin + BlockSize - 1, m_candidateLimit)};

            for (int candidate{begin}; candidate <= end; ++candidate) {
                // Cancellation is cooperative: an atomic flag can be read safely
                // across threads without trying to interrupt arbitrary C++ code.
                if ((candidate - begin) % CancellationCheckInterval == 0
                    && m_cancelRequested->load(std::memory_order_relaxed)) {
                    cancelled = true;
                    break;
                }

                if (isPrime(candidate)) {
                    ++primesFound;
                }
                ++processed;
            }

            // Queued signals carry the progress back, so the GUI event loop
            // keeps drawing while this thread works.
            emit progressUpdated(m_index, processed, primesFound);
        }

        emit workFinished(m_index, processed, primesFound, cancelled);
    }

signals:
    void progressUpdated(int workerIndex, int processed, int primesFound);
    void workFinished(int workerIndex, int processed, int primesFound, bool cancelled);

private:
    static bool isPrime(int value)
    {
        // Trial division makes the workload easy to follow; checking up to
        // value / divisor avoids overflowing divisor * divisor.
        for (int divisor{2}; divisor <= value / divisor; ++divisor) {
            if (value % divisor == 0) {
                return false;
            }
        }
        return true;
    }

    static constexpr int BlockSize{50'000};
    static constexpr int CancellationCheckInterval{1'024};

    int m_index;
    const std::atomic_bool *m_cancelRequested;
    std::atomic_int *m_nextCandidate;
    int m_candidateLimit;
};

ThreadedProcessor::ThreadedProcessor(QObject *parent)
    : QObject{parent}
{
    m_elapsedTicker.setInterval(100);
    connect(&m_elapsedTicker, &QTimer::timeout, this, [this] {
        setElapsedMs(static_cast<int>(m_elapsedTimer.elapsed()));
    });
}

ThreadedProcessor::~ThreadedProcessor()
{
    m_cancelRequested.store(true, std::memory_order_relaxed);
    for (QThread *thread : std::as_const(m_threads)) {
        thread->quit();
    }
    for (QThread *thread : std::as_const(m_threads)) {
        thread->wait();
    }
}

int ThreadedProcessor::maximumCandidateLimit() const
{
    return MaximumCandidateLimit;
}

int ThreadedProcessor::maximumThreadCount() const
{
    return MaximumThreadCount;
}

int ThreadedProcessor::idealThreadCount() const
{
    return std::clamp(QThread::idealThreadCount(), 1, MaximumThreadCount);
}

bool ThreadedProcessor::threadingSupported() const
{
#if defined(Q_OS_WASM) && !defined(__EMSCRIPTEN_PTHREADS__)
    return false;
#else
    return true;
#endif
}

int ThreadedProcessor::threadCount() const
{
    return static_cast<int>(m_workerProcessed.size());
}

int ThreadedProcessor::candidateCount() const
{
    return std::max(m_candidateLimit - 1, 0);
}

QList<int> ThreadedProcessor::workerProcessed() const
{
    return m_workerProcessed;
}

QList<int> ThreadedProcessor::workerPrimes() const
{
    return m_workerPrimes;
}

int ThreadedProcessor::progress() const
{
    return m_progress;
}

int ThreadedProcessor::primesFound() const
{
    return m_primesFound;
}

int ThreadedProcessor::elapsedMs() const
{
    return m_elapsedMs;
}

ThreadedProcessor::State ThreadedProcessor::state() const
{
    return m_state;
}

bool ThreadedProcessor::isBusy() const
{
    // Threads can outlive their final queued result by a few event-loop turns.
    return m_runningThreads > 0
        || m_state == State::Running
        || m_state == State::Cancelling;
}

void ThreadedProcessor::start(int candidateLimit, int threadCount)
{
    if (isBusy()) {
        return;
    }

    if (!threadingSupported()) {
        qWarning() << "ThreadedProcessor requires a native or multithreaded WebAssembly build.";
        return;
    }

    if (candidateLimit < 2 || candidateLimit > MaximumCandidateLimit) {
        qWarning() << "ThreadedProcessor candidate limit must be between 2 and"
                   << MaximumCandidateLimit;
        return;
    }

    if (threadCount < 1 || threadCount > MaximumThreadCount) {
        qWarning() << "ThreadedProcessor thread count must be between 1 and"
                   << MaximumThreadCount;
        return;
    }

    m_cancelRequested.store(false, std::memory_order_relaxed);
    m_nextCandidate.store(2, std::memory_order_relaxed);
    m_finishedWorkers = 0;
    m_anyWorkerCancelled = false;
    m_candidateLimit = candidateLimit;
    m_workerProcessed = QList<int>(threadCount, 0);
    m_workerPrimes = QList<int>(threadCount, 0);
    emit workersChanged();
    setProgress(0);
    setPrimesFound(0);
    setElapsedMs(0);
    setState(State::Running);

    m_elapsedTimer.start();
    m_elapsedTicker.start();

    for (int index{0}; index < threadCount; ++index) {
        auto *thread{new QThread{this}};
        thread->setObjectName(QStringLiteral("PrimeCalculationThread%1").arg(index + 1));

        auto *worker{new PrimeWorker{index, &m_cancelRequested, &m_nextCandidate, candidateLimit}};
        // QObject affinity routes the worker slot to the new thread. Its progress
        // and completion signals are explicitly queued back to this GUI-thread
        // controller, keeping all QML-visible state on the GUI thread.
        worker->moveToThread(thread);

        // Queued, so calculate() runs inside the worker thread's event loop
        // rather than directly in the thread's started() emission.
        connect(thread, &QThread::started, worker, &PrimeWorker::calculate, Qt::QueuedConnection);
        connect(worker, &PrimeWorker::progressUpdated,
                this, &ThreadedProcessor::handleProgress, Qt::QueuedConnection);
        connect(worker, &PrimeWorker::workFinished,
                this, &ThreadedProcessor::handleWorkerFinished, Qt::QueuedConnection);
        // quit() is thread-safe; connecting directly stops the thread's event
        // loop as soon as the result is out, even if the controller is being
        // destroyed and waiting.
        connect(worker, &PrimeWorker::workFinished, thread, &QThread::quit, Qt::DirectConnection);
        // Tying deletion to the thread's end also covers a thread stopped
        // before the worker slot got to run.
        connect(thread, &QThread::finished, worker, &QObject::deleteLater);
        connect(thread, &QThread::finished, this, &ThreadedProcessor::handleThreadFinished);

        m_threads.append(thread);
        ++m_runningThreads;
        thread->start();
    }
}

void ThreadedProcessor::cancel()
{
    if (m_state != State::Running) {
        return;
    }

    m_cancelRequested.store(true, std::memory_order_relaxed);
    setState(State::Cancelling);
}

void ThreadedProcessor::reset()
{
    if (isBusy()) {
        return;
    }

    m_candidateLimit = 0;
    m_workerProcessed.clear();
    m_workerPrimes.clear();
    emit workersChanged();
    setProgress(0);
    setPrimesFound(0);
    setElapsedMs(0);
    setState(State::Idle);
}

void ThreadedProcessor::handleProgress(int workerIndex, int processed, int primesFound)
{
    if (workerIndex < 0 || workerIndex >= m_workerProcessed.size()) {
        return;
    }

    m_workerProcessed[workerIndex] = processed;
    m_workerPrimes[workerIndex] = primesFound;
    updateTotals();
}

void ThreadedProcessor::handleWorkerFinished(int workerIndex, int processed, int primesFound,
                                             bool cancelled)
{
    handleProgress(workerIndex, processed, primesFound);

    m_anyWorkerCancelled = m_anyWorkerCancelled || cancelled;
    if (++m_finishedWorkers < threadCount()) {
        return;
    }

    m_elapsedTicker.stop();
    setElapsedMs(static_cast<int>(m_elapsedTimer.elapsed()));
    setState(m_anyWorkerCancelled ? State::Cancelled : State::Completed);
}

void ThreadedProcessor::handleThreadFinished()
{
    if (--m_runningThreads == 0) {
        for (QThread *thread : std::as_const(m_threads)) {
            thread->deleteLater();
        }
        m_threads.clear();
    }
    emit stateChanged();
}

void ThreadedProcessor::updateTotals()
{
    const auto processed{std::accumulate(m_workerProcessed.cbegin(), m_workerProcessed.cend(),
                                         qint64{0})};
    const auto primes{std::accumulate(m_workerPrimes.cbegin(), m_workerPrimes.cend(), 0)};

    emit workersChanged();
    setProgress(static_cast<int>(processed * 100 / candidateCount()));
    setPrimesFound(primes);
}

void ThreadedProcessor::setProgress(int progress)
{
    if (m_progress == progress) {
        return;
    }

    m_progress = progress;
    emit progressChanged();
}

void ThreadedProcessor::setPrimesFound(int primesFound)
{
    if (m_primesFound == primesFound) {
        return;
    }

    m_primesFound = primesFound;
    emit primesFoundChanged();
}

void ThreadedProcessor::setElapsedMs(int elapsedMs)
{
    if (m_elapsedMs == elapsedMs) {
        return;
    }

    m_elapsedMs = elapsedMs;
    emit elapsedMsChanged();
}

void ThreadedProcessor::setState(State state)
{
    if (m_state == state) {
        return;
    }

    m_state = state;
    emit stateChanged();
}

#include "ThreadedProcessor.moc"

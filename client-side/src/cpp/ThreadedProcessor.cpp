#include "ThreadedProcessor.h"

#include <QtCore/QDebug>
#include <QtCore/QtGlobal>

class PrimeWorker final : public QObject
{
    Q_OBJECT

public:
    PrimeWorker(std::atomic_bool *cancelRequested, int candidateLimit)
        : m_cancelRequested{cancelRequested}
        , m_candidateLimit{candidateLimit}
    {
    }

public slots:
    void calculate()
    {
        int primesFound{0};
        int candidate{2};

        // This deliberately CPU-bound search runs entirely on the worker
        // thread. Queued progress signals let the GUI event loop keep drawing.
        for (; candidate <= m_candidateLimit; ++candidate) {
            // Cancellation is cooperative: an atomic flag can be read safely
            // across threads without trying to interrupt arbitrary C++ code.
            if ((candidate & 0x3ff) == 0
                && m_cancelRequested->load(std::memory_order_relaxed)) {
                break;
            }

            if (isPrime(candidate)) {
                ++primesFound;
            }

            if (candidate % 50'000 == 0 || candidate == m_candidateLimit) {
                const auto progress{static_cast<int>(
                    static_cast<qint64>(candidate) * 100 / m_candidateLimit)};
                emit progressUpdated(progress, primesFound);
            }
        }

        const auto cancelled{candidate <= m_candidateLimit};
        if (cancelled) {
            const auto processedCandidates{candidate - 1};
            const auto progress{static_cast<int>(
                static_cast<qint64>(processedCandidates) * 100 / m_candidateLimit)};
            emit progressUpdated(progress, primesFound);
        }
        emit workFinished(primesFound, cancelled);
    }

signals:
    void progressUpdated(int progress, int primesFound);
    void workFinished(int primesFound, bool cancelled);

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

    std::atomic_bool *m_cancelRequested;
    int m_candidateLimit;
};

ThreadedProcessor::ThreadedProcessor(QObject *parent)
    : QObject{parent}
{
    m_workerThread.setObjectName(QStringLiteral("PrimeCalculationThread"));
    connect(&m_workerThread, &QThread::finished, this, [this] {
        // Busy also reflects QThread's lifetime, which can outlast the worker's
        // final queued result by a few event-loop turns.
        emit stateChanged();
    });
}

ThreadedProcessor::~ThreadedProcessor()
{
    if (m_workerThread.isRunning()) {
        m_cancelRequested.store(true, std::memory_order_relaxed);
        m_workerThread.quit();
        m_workerThread.wait();
    }
}

int ThreadedProcessor::maximumCandidateLimit() const
{
    return MaximumCandidateLimit;
}

bool ThreadedProcessor::threadingSupported() const
{
#if defined(Q_OS_WASM) && !defined(__EMSCRIPTEN_PTHREADS__)
    return false;
#else
    return true;
#endif
}

int ThreadedProcessor::progress() const
{
    return m_progress;
}

int ThreadedProcessor::primesFound() const
{
    return m_primesFound;
}

ThreadedProcessor::State ThreadedProcessor::state() const
{
    return m_state;
}

bool ThreadedProcessor::isBusy() const
{
    return m_workerThread.isRunning()
        || m_state == State::Running
        || m_state == State::Cancelling;
}

void ThreadedProcessor::start(int candidateLimit)
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

    m_cancelRequested.store(false, std::memory_order_relaxed);
    setProgress(0);
    setPrimesFound(0);
    setState(State::Running);

    auto *worker{new PrimeWorker{&m_cancelRequested, candidateLimit}};
    // QObject affinity routes the worker slot to the new thread. Its progress
    // and completion signals are explicitly queued back to this GUI-thread
    // controller, keeping all QML-visible state on the GUI thread.
    worker->moveToThread(&m_workerThread);

    connect(&m_workerThread, &QThread::started, worker, &PrimeWorker::calculate);
    connect(worker, &PrimeWorker::progressUpdated,
            this, &ThreadedProcessor::handleProgress, Qt::QueuedConnection);
    connect(worker, &PrimeWorker::workFinished,
            this, &ThreadedProcessor::handleWorkFinished, Qt::QueuedConnection);
    connect(worker, &PrimeWorker::workFinished, worker, &QObject::deleteLater);
    // quit() is thread-safe; connecting directly lets the worker stop its own
    // event loop even if the controller is being destroyed and waiting.
    connect(worker, &PrimeWorker::workFinished,
            &m_workerThread, &QThread::quit, Qt::DirectConnection);

    m_workerThread.start();
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

    setProgress(0);
    setPrimesFound(0);
    setState(State::Idle);
}

void ThreadedProcessor::handleProgress(int progress, int primesFound)
{
    setProgress(progress);
    setPrimesFound(primesFound);
}

void ThreadedProcessor::handleWorkFinished(int primesFound, bool cancelled)
{
    setPrimesFound(primesFound);
    setState(cancelled ? State::Cancelled : State::Completed);
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

void ThreadedProcessor::setState(State state)
{
    if (m_state == state) {
        return;
    }

    m_state = state;
    emit stateChanged();
}

#include "ThreadedProcessor.moc"

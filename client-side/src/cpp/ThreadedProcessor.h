#ifndef THREADED_PROCESSOR_H
#define THREADED_PROCESSOR_H

#include <QtCore/QElapsedTimer>
#include <QtCore/QList>
#include <QtCore/QObject>
#include <QtCore/QThread>
#include <QtCore/QTimer>

#include <atomic>

#include <QtQml/QtQml>

class ThreadedProcessor : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int maximumCandidateLimit READ maximumCandidateLimit CONSTANT)
    Q_PROPERTY(int maximumThreadCount READ maximumThreadCount CONSTANT)
    Q_PROPERTY(int idealThreadCount READ idealThreadCount CONSTANT)
    Q_PROPERTY(bool threadingSupported READ threadingSupported CONSTANT)
    Q_PROPERTY(int threadCount READ threadCount NOTIFY workersChanged)
    Q_PROPERTY(int candidateCount READ candidateCount NOTIFY workersChanged)
    Q_PROPERTY(QList<int> workerProcessed READ workerProcessed NOTIFY workersChanged)
    Q_PROPERTY(QList<int> workerPrimes READ workerPrimes NOTIFY workersChanged)
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(int primesFound READ primesFound NOTIFY primesFoundChanged)
    Q_PROPERTY(int elapsedMs READ elapsedMs NOTIFY elapsedMsChanged)
    Q_PROPERTY(State state READ state NOTIFY stateChanged)
    Q_PROPERTY(bool busy READ isBusy NOTIFY stateChanged)

public:
    explicit ThreadedProcessor(QObject *parent = nullptr);
    ~ThreadedProcessor() override;

    enum State {
        Idle,
        Running,
        Cancelling,
        Completed,
        Cancelled
    };
    Q_ENUM(State)

    int maximumCandidateLimit() const;
    int maximumThreadCount() const;
    int idealThreadCount() const;
    bool threadingSupported() const;
    int threadCount() const;
    int candidateCount() const;
    QList<int> workerProcessed() const;
    QList<int> workerPrimes() const;
    int progress() const;
    int primesFound() const;
    int elapsedMs() const;
    State state() const;
    bool isBusy() const;

    Q_INVOKABLE void start(int candidateLimit, int threadCount);
    Q_INVOKABLE void cancel();
    Q_INVOKABLE void reset();

signals:
    void workersChanged();
    void progressChanged();
    void primesFoundChanged();
    void elapsedMsChanged();
    void stateChanged();

private:
    void handleProgress(int workerIndex, int processed, int primesFound);
    void handleWorkerFinished(int workerIndex, int processed, int primesFound, bool cancelled);
    void handleThreadFinished();
    void updateTotals();
    void setProgress(int progress);
    void setPrimesFound(int primesFound);
    void setElapsedMs(int elapsedMs);
    void setState(State state);

    static constexpr int MaximumCandidateLimit{100'000'000};
    static constexpr int MaximumThreadCount{8};

    // One QThread per worker, created for each run and parented to this object.
    QList<QThread *> m_threads;
    int m_runningThreads{0};
    int m_finishedWorkers{0};
    bool m_anyWorkerCancelled{false};

    // Shared with the workers: the cancel request and the next block of
    // candidates to claim. Both outlive the workers because the destructor
    // waits for every thread.
    std::atomic_bool m_cancelRequested{false};
    std::atomic_int m_nextCandidate{2};

    int m_candidateLimit{0};
    QList<int> m_workerProcessed;
    QList<int> m_workerPrimes;
    QElapsedTimer m_elapsedTimer;
    QTimer m_elapsedTicker;
    int m_elapsedMs{0};
    int m_progress{0};
    int m_primesFound{0};
    State m_state{State::Idle};
};

#endif // THREADED_PROCESSOR_H

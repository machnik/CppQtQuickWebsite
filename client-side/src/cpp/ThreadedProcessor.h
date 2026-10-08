#ifndef THREADED_PROCESSOR_H
#define THREADED_PROCESSOR_H

#include <QtCore/QObject>
#include <QtCore/QThread>

#include <atomic>

#include <QtQml/QtQml>

class ThreadedProcessor : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int maximumCandidateLimit READ maximumCandidateLimit CONSTANT)
    Q_PROPERTY(bool threadingSupported READ threadingSupported CONSTANT)
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(int primesFound READ primesFound NOTIFY primesFoundChanged)
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
    bool threadingSupported() const;
    int progress() const;
    int primesFound() const;
    State state() const;
    bool isBusy() const;

    Q_INVOKABLE void start(int candidateLimit);
    Q_INVOKABLE void cancel();
    Q_INVOKABLE void reset();

signals:
    void progressChanged();
    void primesFoundChanged();
    void stateChanged();

private:
    void handleProgress(int progress, int primesFound);
    void handleWorkFinished(int primesFound, bool cancelled);
    void setProgress(int progress);
    void setPrimesFound(int primesFound);
    void setState(State state);

    static constexpr int MaximumCandidateLimit{100'000'000};

    QThread m_workerThread;
    std::atomic_bool m_cancelRequested{false};
    int m_progress{0};
    int m_primesFound{0};
    State m_state{State::Idle};
};

#endif // THREADED_PROCESSOR_H

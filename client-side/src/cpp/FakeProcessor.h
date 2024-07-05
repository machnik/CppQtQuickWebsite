#ifndef FAKEPROCESSOR_H
#define FAKEPROCESSOR_H

#include <QtCore/QTimer>

#include <QtQml/QtQml>

class FakeProcessor : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int deciseconds READ deciseconds WRITE setDeciseconds)
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)

public:
    explicit FakeProcessor(QObject *parent = nullptr);

    enum Status {
        Idle,
        Running,
        Finished,
        Error
    };
    Q_ENUM(Status)

    int deciseconds() const;
    void setDeciseconds(int seconds);
    int progress() const;
    Status status() const;

public slots:
    void start();
    void stop();

signals:
    void progressChanged();
    void statusChanged();

private:
    int m_deciseconds = 100;
    int m_progress = 0;
    Status m_status = Status::Idle;
    QTimer m_timer;
};

#endif // FAKEPROCESSOR_H

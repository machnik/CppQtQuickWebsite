#include "FakeProcessor.h"

#include <random>

FakeProcessor::FakeProcessor(QObject *parent)
    : QObject(parent)
{
    m_timer.setInterval(100); // 1 decisecond

    connect(&m_timer, &QTimer::timeout, this, [this](){
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> distribution(1, 1000);

        if (distribution(gen) <= 7) {
            m_status = Status::Error;
            emit statusChanged();
            m_timer.stop();
        } else {
            m_progress++;
            emit progressChanged();

            if (m_progress >= m_deciseconds) {
                m_status = Status::Finished;
                emit statusChanged();
                m_timer.stop();
            }
        }
    });
}

void FakeProcessor::start()
{
    m_progress = 0;
    emit progressChanged();
    m_status = Status::Running;
    emit statusChanged();
    m_timer.start();
}

void FakeProcessor::stop()
{
    m_timer.stop();
    m_progress = 0;
    emit progressChanged();
    m_status = Status::Idle;
    emit statusChanged();
}

int FakeProcessor::deciseconds() const
{
    return m_deciseconds;
}

void FakeProcessor::setDeciseconds(int deciseconds)
{
    m_deciseconds = deciseconds;
}

int FakeProcessor::progress() const
{
    return m_progress;
}

FakeProcessor::Status FakeProcessor::status() const
{
    return m_status;
}

#ifndef COUNTER_H
#define COUNTER_H

#include <QtCore/QObject>

class Counter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)

public:
    explicit Counter(QObject *parent = nullptr);

    int count() const;
    void setCount(int count);

signals:
    void countChanged();

private:
    int m_count;
};

#endif // COUNTER_H

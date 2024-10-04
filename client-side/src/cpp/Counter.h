#ifndef COUNTER_H
#define COUNTER_H

#include <QtCore/QObject>

#include <QtQml/QtQml>

/*  Implementing a simple counter class that can be used in QML.
    It is not a singleton, so it can be instantiated many times.
*/

class Counter : public QObject
{
    Q_OBJECT
    QML_ELEMENT

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

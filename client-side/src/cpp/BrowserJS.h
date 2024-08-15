#ifndef JAVASCRIPT_H
#define JAVASCRIPT_H

#include <QtCore/QObject>

#include <QtQml/QQmlProperty>

class BrowserJS : public QObject {

    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(bool available READ isAvailable CONSTANT)

public:
    explicit BrowserJS(QObject *parent = nullptr);

    bool isAvailable() const;

public slots:
    int runJS(const QString & code);

private:
    const bool available;
};

#endif // JAVASCRIPT_H
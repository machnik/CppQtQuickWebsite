#ifndef JAVASCRIPT_H
#define JAVASCRIPT_H

#include <QtCore/QObject>

#include <QtQml/QQmlProperty>

class BrowserJS : public QObject {

    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(bool browserEnvironment READ isBrowserEnvionment CONSTANT)

public:
    explicit BrowserJS(QObject *parent = nullptr);

    bool isBrowserEnvionment() const;

public slots:
    int runJS(const QString & code);

private:
    const bool b_browserEnvironment;
};

#endif // JAVASCRIPT_H
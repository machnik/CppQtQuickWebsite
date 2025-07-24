#ifndef JAVASCRIPT_H
#define JAVASCRIPT_H

#include <QtCore/QObject>

#include <QtQml/QQmlProperty>

class BrowserJS : public QObject {

    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(bool browserEnvironment READ isBrowserEnvironment CONSTANT)

public:
    explicit BrowserJS(QObject *parent = nullptr);

    bool isBrowserEnvironment() const;

    static BrowserJS* instance(); // Get the singleton instance

public slots:
    int runIntJS(const QString & code);
    QString runStringJS(const QString & code);
    void runVoidJS(const QString & code);

private:
    const bool b_browserEnvironment;
    static BrowserJS* s_instance;
};

#endif // JAVASCRIPT_H
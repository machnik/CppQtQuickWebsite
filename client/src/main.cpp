/* TODO
- WebAssembly
- Write QML property from C++
- Auto adjust app window size to browser window size
- Better menu
*/

#include <QtGui/QGuiApplication>

#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>

#include "Backend.h"
#include "Counter.h"
#include "WebSocketServer.h"
#include "WebSocketClient.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Backend backend;
    qmlRegisterSingletonInstance<Backend>("CppQtQuickWebsite.CppObjects", 1, 0, "Backend", &backend);

    qmlRegisterType<Counter>("CppQtQuickWebsite.CppClasses", 1, 0, "Counter");

    WebSocketServer server;
    WebSocketClient client;

    qmlRegisterSingletonInstance("CppQtQuickWebsite.CppObjects", 1, 0, "WebSocketServer", &server);
    qmlRegisterSingletonInstance("CppQtQuickWebsite.CppObjects", 1, 0, "WebSocketClient", &client);

    const QUrl url(QStringLiteral("qrc:/src/ui/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

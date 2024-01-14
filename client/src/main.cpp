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

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Backend backend;
    qmlRegisterSingletonInstance<Backend>("CppQtQuickWebpage.Backend", 1, 0, "Backend", &backend);

    qmlRegisterType<Counter>("CppQtQuickWebpage.CppClasses", 1, 0, "Counter");

    const QUrl url(QStringLiteral("qrc:/src/ui/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

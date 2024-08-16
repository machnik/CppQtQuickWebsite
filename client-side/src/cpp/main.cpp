#ifdef Q_OS_WASM
    #include <emscripten.h>
    #include <QtGui/QGuiApplication>
#else
    #include <QtWidgets/QApplication>
#endif

#include <QtQml/QQmlApplicationEngine>

int main(int argc, char *argv[])
{
#ifdef Q_OS_WASM
    QGuiApplication app(argc, argv);
#else
    QApplication app(argc, argv);
#endif

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}

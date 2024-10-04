#ifdef Q_OS_WASM
/*  Emscripten is a toolchain for compiling to WebAssembly, that also provides a set of APIs
    for interacting with WebAssembly at runtime, which allows running C and C++ code
    on the web at near-native speed.
*/
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

#ifdef Q_OS_WASM
/*  Emscripten is a toolchain for compiling to WebAssembly, that also provides a set of APIs
    for interacting with WebAssembly at runtime, which allows running C and C++ code
    on the web at near-native speed.
*/
    #include <emscripten.h>
#endif

#include <QtWidgets/QApplication>

#include <QtQml/QQmlApplicationEngine>
#include <QtQuickControls2/QQuickStyle>

int main(int argc, char *argv[])
{
//  If the Widgets module is not needed, you can use QGuiApplication instead of QApplication:
    QApplication app(argc, argv);

    // Set the Material UI theme to Light:
    qputenv("QT_QUICK_CONTROLS_MATERIAL_THEME", "Light");
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    engine.load(":/qml/main.qml");

    return app.exec();
}

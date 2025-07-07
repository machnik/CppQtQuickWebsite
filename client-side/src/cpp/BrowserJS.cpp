#include "BrowserJS.h"

#ifdef Q_OS_WASM
    #include <emscripten.h>
    #include <emscripten/val.h>
#endif

BrowserJS::BrowserJS(QObject *parent)
    :   QObject{parent},
#ifdef Q_OS_WASM
        b_browserEnvironment{true}
#else
        b_browserEnvironment{false}
#endif
{}

bool BrowserJS::isBrowserEnvironment() const {
    return b_browserEnvironment;
}

int BrowserJS::runIntJS(const QString & code) {
#ifdef Q_OS_WASM
    return emscripten_run_script_int(code.toLatin1().data());
#else
    return 0;
#endif
}

QString BrowserJS::runStringJS(const QString & code) {
#ifdef Q_OS_WASM
    char* result = emscripten_run_script_string(code.toLatin1().data());
    QString qstr = QString::fromUtf8(result);
    free(result);
    return qstr;
#else
    return QString();
#endif
}

void BrowserJS::runVoidJS(const QString & code) {
#ifdef Q_OS_WASM
    emscripten_run_script(code.toLatin1().data());
#endif
}

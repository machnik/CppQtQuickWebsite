#include "BrowserJS.h"

#include <exception>

#ifdef Q_OS_WASM
    #include <emscripten.h>
#endif

BrowserJS::BrowserJS(QObject *parent)
    :   QObject{parent},
#ifdef Q_OS_WASM
        available{true}
#else
        available{false}
#endif
{}

bool BrowserJS::isAvailable() const {
    return available;
}

void BrowserJS::runJS(const QString & code) {
#ifdef Q_OS_WASM
    emscripten_run_script(code.toLatin1());
#endif
}

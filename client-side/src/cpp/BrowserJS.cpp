#include "BrowserJS.h"

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

int BrowserJS::runJS(const QString & code) {
#ifdef Q_OS_WASM
    return emscripten_run_script_int(code.toLatin1().data());
#else
    return 0;
#endif
}

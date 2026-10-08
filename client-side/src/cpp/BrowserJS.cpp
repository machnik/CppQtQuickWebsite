#include "BrowserJS.h"

#ifdef Q_OS_WASM
    #include <emscripten.h>
    #include <emscripten/val.h>
#endif

BrowserJS* BrowserJS::s_instance = nullptr;

BrowserJS::BrowserJS(QObject *parent)
    :   QObject{parent},
#ifdef Q_OS_WASM
        b_browserEnvironment{true}
#else
        b_browserEnvironment{false}
#endif
{
    s_instance = this;
}

BrowserJS::~BrowserJS()
{
    if (s_instance == this) {
        s_instance = nullptr;
    }
}

bool BrowserJS::isBrowserEnvironment() const {
    return b_browserEnvironment;
}

BrowserJS* BrowserJS::instance() {
    return s_instance;
}

int BrowserJS::runIntJS(const QString & code) {
#ifdef Q_OS_WASM
    // Emscripten's helpers are deliberately separated by return type so the
    // caller can choose a conversion the C++/JavaScript boundary supports.
    return emscripten_run_script_int(code.toLatin1().data());
#else
    return 0;
#endif
}

QString BrowserJS::runStringJS(const QString & code) {
#ifdef Q_OS_WASM
    auto *result{emscripten_run_script_string(code.toLatin1().data())};
    auto qstr{QString::fromUtf8(result)};
    // Emscripten allocates this returned C string for the caller.
    free(result);
    return qstr;
#else
    return QString{};
#endif
}

void BrowserJS::runVoidJS(const QString & code) {
#ifdef Q_OS_WASM
    emscripten_run_script(code.toLatin1().data());
#endif
}

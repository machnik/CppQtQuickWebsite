# CppQtQuickWebsite

## ✅ Requirements

- **[CMake](https://cmake.org/download/)** version >= `3.30.2`
- **[Qt](https://www.qt.io/download-open-source)** version `6.8.0` with pre-built binaries for:
  - 🐧 Linux: **GCC**
  - 🪟︎ Windows: **LLVM-MinGW**
  - **WebAssembly** (multi-threaded)
- **C++ Compiler:**
  - 🐧 Linux: **GCC**
  - 🪟︎ Windows: **LLVM-MinGW**
- **[emscripten](https://emscripten.org/docs/getting_started/downloads.html)** version `3.1.59`

## 💻 Environment Setup

### 🐧 Linux

#### Qt

```
export QT_BIN_WASM="$HOME/Qt/6.8.0/wasm_multithread"
export QT_BIN_GCC="$HOME/Qt/6.8.0/gcc_64"
```

#### emscripten

```
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install 3.1.59
./emsdk activate 3.1.59
source emsdk_env.sh
```

### 🪟︎ Windows

_TIP: `setx` sets permanent system environment variables. They are available in all NEW terminal instances. To set temporary variables that are available only in the current terminal instance, use `set` instead._

#### LLVM-MinGW
Select **LLVM-MinGW** in the **Qt Maintenance Tool** (under Qt -> Developer and Designer Tools).

```
setx PATH "%PATH%;"%USERPROFILE%\Qt\Tools\llvm-mingw1706_64\bin"
```

#### Qt
```
setx QT_BIN_LLVM_MINGW "%USERPROFILE%\Qt\6.8.0\llvm-mingw_64\bin"

setx PATH %QT_BIN_LLVM_MINGW%\bin;%PATH%
setx QML2_IMPORT_PATH "%QT_BIN_LLVM_MINGW%\qml"
setx QT_PLUGIN_PATH "%QT_BIN_LLVM_MINGW%\plugins"
```

#### emscripten

// TODO

## 🌐 Build for WebAssembly

### On Linux

```
cd CppQtQuickWebsite/client-side
mkdir build_wasm && cd build_wasm
"$QT_BIN_WASM/bin/qt-cmake" ..
"$QT_BIN_WASM/bin/qt-cmake" --build .
```

#### Run

```
"$EMSDK/upstream/emscripten/emrun" --browser=chrome Website.html
```

### On Windows

// TODO

#### Run

// TODO

## 🐧 Build for Linux
```
cd CppQtQuickWebsite/client-side
mkdir build_linux && cd build_linux
"$QT_BIN_GCC/bin/qt-cmake" ..
"$QT_BIN_GCC/bin/qt-cmake" --build .
```

### Run
```
./Website
```

## 🪟︎ Build for Windows
```
cd CppQtQuickWebsite/client-side
mkdir build_win && cd build_win
"%QT_BIN_LLVM_MINGW%\bin\qt-cmake.bat" -G "MinGW Makefiles" ..
"%QT_BIN_LLVM_MINGW%\bin\qt-cmake.bat" --build .
```

### Run
```
Website.exe
```

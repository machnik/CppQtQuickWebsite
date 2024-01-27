# CppQtQuickWebsite

## Requirements

- **CMake** version `3.27`
- **Qt** version `6.6.1` with pre-built binaries for WebAssembly (single thread)
- **emscripten** version `3.1.37`

## Environment

### Qt

```
export QT_BIN_WASM="$HOME/Qt/6.6.1/wasm_singlethread/bin"
export QT_BIN_GCC="$HOME/Qt/6.6.1/gcc_64/bin"
```

### emscripten

```
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install 3.1.37
./emsdk activate 3.1.37
source emsdk_env.sh
```

## Build for WebAssembly

```
cd CppQtQuickWebsite/client
mkdir build_wasm && cd build_wasm
"$QT_BIN_WASM/qt-cmake" ..
cmake --build .
```

### Run

```
"$EMSDK/upstream/emscripten/emrun" --browser=chrome CppQtQuickWebsite.html
```

## Build for Linux
```
cd CppQtQuickWebsite/client
mkdir build_linux && cd build_linux
"$QT_BIN_GCC/qt-cmake" ..
cmake --build .
```

# terminal:
# export QT_DIR="$HOME/Qt/6.7.0"
# source "$HOME/emscripten/emsdk_env.sh"

cmake_minimum_required(VERSION 3.16)
project(CppQtQuickWebsite)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

#set(CMAKE_PREFIX_PATH "$ENV{QT_DIR}/wasm_singlethread/lib/cmake/Qt6")
set(CMAKE_PREFIX_PATH "$ENV{QT_DIR}/gcc_64/lib/cmake/Qt6")

find_package(Qt6 COMPONENTS Core Quick Multimedia MultimediaWidgets WebView REQUIRED)

#set(CMAKE_TOOLCHAIN_FILE "$ENV{EMSDK}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake")

#set(CMAKE_EXECUTABLE_SUFFIX ".html")

add_executable(${PROJECT_NAME}
    "src/main.cpp"
    "src/Backend.cpp"
    "src/Counter.cpp"
    "src/ListModel.cpp"    
    "bundle.qrc"
)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt6::Core Qt6::Quick Qt6::Multimedia Qt6::MultimediaWidgets Qt6::WebView)

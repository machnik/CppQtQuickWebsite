cmake_minimum_required(VERSION 3.16)

project(CppQtQuickWebsite)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_PREFIX_PATH "$ENV{QT_DIR}")

if(CMAKE_VERSION VERSION_LESS "3.7.0")
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
endif()

find_package(Qt6 COMPONENTS Core Quick Multimedia WebView REQUIRED)

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
    PRIVATE Qt6::Core Qt6::Quick Qt6::Multimedia Qt6::WebView)

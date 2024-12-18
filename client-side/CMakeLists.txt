cmake_minimum_required(VERSION 3.27)
project(CppQtQuickWebsite LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Quick3D Multimedia WebSockets Widgets)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/cpp)

qt_standard_project_setup()

qt_add_executable(${PROJECT_NAME}
    "src/cpp/main.cpp"
    "src/cpp/Backend.cpp"
    "src/cpp/Base64Converter.cpp"
    "src/cpp/BrowserJS.cpp"
    "src/cpp/Counter.cpp"
    "src/cpp/FakeProcessor.cpp"
    "src/cpp/ListModel.cpp"
    "src/cpp/TextFileIO.cpp"
    "src/cpp/WebSocketServer.cpp"
    "src/cpp/WebSocketClient.cpp"  
    "src/cpp/SystemInformation.cpp"
    "src/js/js.qrc" 
    "src/qml/qml.qrc"
    "resources/resources.qrc"
)

qt_policy(
    SET QTP0001 NEW
)

# Exposing C++ items to QML
qt6_add_qml_module(${PROJECT_NAME}
    URI "CppQtQuickWebsite.CppObjects"
    VERSION 1.0
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt6::Core Qt6::Quick Qt6::Quick3D Qt6::Multimedia Qt6::WebSockets Qt6::Widgets
)

set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "WebApplication")

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/resources/icons/favicon.ico
        ${CMAKE_CURRENT_BINARY_DIR}/favicon.ico
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/splash.svg
        ${CMAKE_CURRENT_BINARY_DIR}/qtlogo.svg
    COMMENT "Copying website icon and splash image to build directory..."
)

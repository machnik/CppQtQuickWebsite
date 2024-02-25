cmake_minimum_required(VERSION 3.27)
project(CppQtQuickWebsite LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Quick3D Multimedia WebSockets)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

qt_standard_project_setup()

qt_add_executable(${PROJECT_NAME}
    "src/main.cpp"
    "src/Backend.cpp"
    "src/Counter.cpp"
    "src/ListModel.cpp"
    "src/WebSocketServer.cpp"
    "src/WebSocketClient.cpp"    
    "bundle.qrc"
)

qt_policy(
    SET QTP0001 NEW
)

qt6_add_qml_module(${PROJECT_NAME}
    URI "CppQtQuickWebsite.CppObjects"
    VERSION 1.0
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt6::Core Qt6::Quick Qt6::Quick3D Qt6::Multimedia Qt6::WebSockets
)

set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "Website")

cmake_minimum_required(VERSION 3.27)
project(CppQtQuickWebsite LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Multimedia)

qt_standard_project_setup()

qt_add_executable(${PROJECT_NAME}
    "src/main.cpp"
    "src/Backend.cpp"
    "src/Counter.cpp"
    "src/ListModel.cpp"    
    "bundle.qrc"
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt6::Core Qt6::Quick Qt6::Multimedia
)

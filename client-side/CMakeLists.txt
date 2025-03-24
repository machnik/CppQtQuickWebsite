cmake_minimum_required(VERSION 3.29)
project(CppQtQuickWebsite LANGUAGES CXX)

# Set the project's C++ standard to C++20
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable the Qt Meta-Object Compiler and Qt Resource Compiler
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Toggleable option to enable WebAssembly exceptions
option(ENABLE_WASM_EXCEPTIONS "Enable C++ exceptions in WebAssembly builds" OFF)

# Set default build type if not specified: Release
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type: Debug or Release" FORCE)
endif()

# Configure debug build
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(STATUS "Configuring Debug build")

    add_compile_options(
        "-O0" # No optimization
        "-g" # Debugging information
    )
    
    # WebAssembly-specific debug settings
    if(EMSCRIPTEN)
        if(ENABLE_WASM_EXCEPTIONS)
            add_compile_options("-fexceptions") # Enable C++ exceptions
        endif()
        
        add_link_options(
            "--profiling-funcs" # Enable function-level profiling
            "-O0" # No optimization
            "-g" # Debugging information
            "-sASSERTIONS=1" # Enable runtime assertions
            "-sSAFE_HEAP=1" # Enable safe heap
            "-sSAFE_HEAP_LOG=1" # Enable safe heap logging
            "-sSTACK_OVERFLOW_CHECK=2" # Enable stack overflow checking
        )
        
        if(ENABLE_WASM_EXCEPTIONS)
            add_link_options("-fexceptions") # Enable C++ exceptions
        endif()

        add_compile_definitions(
            QT_QML_DEBUG # Enable QML debugging
            EMSCRIPTEN_TRACING # Makes C++-to-JavaScript and JavaScript-to-C++ calls traceable
        )
    endif()
# Configure release build
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    message(STATUS "Configuring Release build")

    add_compile_options(
        "-O3" # Full optimization
        "-DNDEBUG" # Disable assertions
    )

    # WebAssembly-specific release optimizations
    if(EMSCRIPTEN)
        if(ENABLE_WASM_EXCEPTIONS)
            add_compile_options("-fexceptions") # Enable C++ exceptions
        endif()
        
        add_link_options(
            "--closure=1" # Enable Closure Compiler optimizations
            "-O3" # Full optimization
            "-sASSERTIONS=0" # Disable runtime assertions
            "-sSAFE_HEAP=0" # Disable safe heap
            "-sSTACK_OVERFLOW_CHECK=0" # Disable stack overflow checking
            "-sELIMINATE_DUPLICATE_FUNCTIONS=1" # Eliminate duplicate functions
        )

        if(ENABLE_WASM_EXCEPTIONS)
            add_link_options("-fexceptions") # Enable C++ exceptions
        endif()
    endif()
endif()

# Find the required Qt modules
find_package(Qt6 REQUIRED COMPONENTS Core Quick Quick3D Multimedia WebSockets Widgets)

# Include the project's C++ headers
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/cpp)

# Sets Qt-specific settings for the project
qt_standard_project_setup()

# Disables CMake warning about default resource prefix for QML files
qt_policy(
    SET QTP0001 NEW
)

# Add the executable target
qt_add_executable(${PROJECT_NAME}
    "src/cpp/main.cpp"
    "src/cpp/Backend.cpp"
    "src/cpp/Base64Converter.cpp"
    "src/cpp/BrowserJS.cpp"
    "src/cpp/Counter.cpp"
    "src/cpp/FakeProcessor.cpp"
    "src/cpp/ListModel.cpp"
    "src/cpp/Localization.cpp"
    "src/cpp/TextFileIO.cpp"
    "src/cpp/WebSocketServer.cpp"
    "src/cpp/WebSocketClient.cpp"  
    "src/cpp/SystemInformation.cpp"
    "src/js/js.qrc" 
    "src/qml/qml.qrc"
    "resources/resources.qrc"
)

# Exposing C++ items to QML
qt6_add_qml_module(${PROJECT_NAME}
    URI "CppQtQuickWebsite.CppObjects"
    VERSION 1.0
)

# Link the Qt modules to the executable
target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt6::Core Qt6::Quick Qt6::Quick3D Qt6::Multimedia Qt6::WebSockets Qt6::Widgets
)

# Set the output name of the executable to "WebApplication"
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "WebApplication")

# Copy website icon and splash image to build directory
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/resources/icons/favicon.ico
        ${CMAKE_CURRENT_BINARY_DIR}/favicon.ico
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/splash.svg
        ${CMAKE_CURRENT_BINARY_DIR}/qtlogo.svg
    COMMENT "Copying website icon and splash image to build directory..."
)

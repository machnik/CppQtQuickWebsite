cmake_minimum_required(VERSION 3.29)
project(CppQtQuickWebsite VERSION 1.1.7 LANGUAGES CXX)

# Enable the Qt Meta-Object Compiler and Qt Resource Compiler
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Toggleable option to enable WebAssembly exceptions
option(ENABLE_WASM_EXCEPTIONS "Enable C++ exceptions in WebAssembly builds" OFF)
# This injects the browser isolation shim; Qt's wasm_multithread toolchain still
# has to be selected separately when configuring the WebAssembly build.
option(ENABLE_WASM_THREADING_HELPER "Inject the cross-origin isolation helper for multithreaded WebAssembly builds" OFF)
# Web Workers pre-created for C++ threads in wasm_multithread builds (Qt's default is 4).
# Keep it at least as high as the number of threads the application starts at once.
set(WASM_PTHREAD_POOL_SIZE 10 CACHE STRING "Size of the Emscripten pthread pool in multithreaded WebAssembly builds")

set(WASM_COMPILE_OPTIONS)
set(WASM_COMPILE_DEFINITIONS)

if(ENABLE_WASM_THREADING_HELPER AND NOT EMSCRIPTEN)
    message(FATAL_ERROR "ENABLE_WASM_THREADING_HELPER is only available for WebAssembly builds.")
endif()

# Set default build type for single-configuration generators if not specified: Release
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type: Debug or Release" FORCE)
endif()

# WebAssembly-specific settings
if(EMSCRIPTEN)
    if(ENABLE_WASM_EXCEPTIONS)
        # Enable C++ exceptions (disabled by default)
        list(APPEND WASM_COMPILE_OPTIONS "-fexceptions")
        add_link_options("-fexceptions")
    endif()

    # Configuration-dependent Emscripten settings use generator expressions so
    # multi-config generators (for example Ninja Multi-Config) select the right
    # options for each build configuration.
    add_link_options(
        # Debug: these runtime checks make memory and stack errors easier to
        # locate while debugging, at a significant runtime cost.
        "$<$<CONFIG:Debug>:--profiling-funcs;-O0;-g;-sASSERTIONS=1;-sSAFE_HEAP=1;-sSAFE_HEAP_LOG=1;-sSTACK_OVERFLOW_CHECK=2>"
        # Release: reduce runtime overhead and output size after the debug
        # checks have served their purpose.
        "$<$<CONFIG:Release>:-O3;-sASSERTIONS=0;-sSAFE_HEAP=0;-sSTACK_OVERFLOW_CHECK=0;-sELIMINATE_DUPLICATE_FUNCTIONS=1>"
    )

    list(APPEND WASM_COMPILE_DEFINITIONS
        "$<$<CONFIG:Debug>:QT_QML_DEBUG>" # Enable QML debugging
        "$<$<CONFIG:Debug>:EMSCRIPTEN_TRACING>" # Makes C++-to-JavaScript and JavaScript-to-C++ calls traceable
    )
endif()

# Find the required Qt modules
find_package(Qt6 6.12 REQUIRED COMPONENTS Core Quick Quick3D QuickControls2 Multimedia WebSockets Widgets Network)

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
    "src/cpp/Backend.h"
    "src/cpp/Base64Converter.cpp"
    "src/cpp/Base64Converter.h"
    "src/cpp/BinaryStorage.cpp"
    "src/cpp/BinaryStorage.h"
    "src/cpp/BrowserJS.cpp"
    "src/cpp/BrowserJS.h"
    "src/cpp/Counter.cpp"
    "src/cpp/Counter.h"
    "src/cpp/FakeProcessor.cpp"
    "src/cpp/FakeProcessor.h"
    "src/cpp/ImageDownloader.cpp"
    "src/cpp/ImageDownloader.h"
    "src/cpp/ListModel.cpp"
    "src/cpp/ListModel.h"
    "src/cpp/Localization.cpp"
    "src/cpp/Localization.h"
    "src/cpp/SystemInformation.cpp"
    "src/cpp/SystemInformation.h"
    "src/cpp/TextFileIO.cpp"
    "src/cpp/TextFileIO.h"
    "src/cpp/WebSocketServer.cpp"
    "src/cpp/WebSocketServer.h"
    "src/cpp/WebSocketClient.cpp"
    "src/cpp/WebSocketClient.h"
    "src/cpp/ThreadedProcessor.cpp"
    "src/cpp/ThreadedProcessor.h"
    "src/js/js.qrc" 
    "src/qml/qml.qrc"
    "resources/resources.qrc"
)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/cpp)

# QML_ELEMENT classes in this target are generated into a module so QML can
# import their types from one URI instead of relying on context properties.
qt6_add_qml_module(${PROJECT_NAME}
    URI "CppQtQuickWebsite.CppObjects"
    VERSION 1.0
)

# Link the Qt modules to the executable
target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt6::Core Qt6::Quick Qt6::Quick3D Qt6::QuickControls2 Qt6::Multimedia Qt6::WebSockets Qt6::Widgets Qt6::Network
)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE
        CPP_QT_QUICK_WEBSITE_VERSION="${PROJECT_VERSION}"
        ${WASM_COMPILE_DEFINITIONS}
)

target_compile_options(${PROJECT_NAME}
    PRIVATE ${WASM_COMPILE_OPTIONS}
)

# Set the output name of the executable to "WebApplication"
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "WebApplication")

# Read by Qt's WebAssembly finalization, which passes it to Emscripten as
# PTHREAD_POOL_SIZE; it has no effect on single-threaded builds.
if(EMSCRIPTEN)
    set_target_properties(${PROJECT_NAME} PROPERTIES QT_WASM_PTHREAD_POOL_SIZE ${WASM_PTHREAD_POOL_SIZE})
endif()

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

if(EMSCRIPTEN AND ENABLE_WASM_THREADING_HELPER)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_SOURCE_DIR}/src/js/shared_array_buffer_fix.js
            ${CMAKE_CURRENT_BINARY_DIR}/shared_array_buffer_fix.js
        COMMAND ${CMAKE_COMMAND}
            -DHTML_FILE=${CMAKE_CURRENT_BINARY_DIR}/WebApplication.html
            -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/InjectWasmThreadingHelper.cmake
        COMMENT "Enabling the WebAssembly threading helper..."
    )
endif()

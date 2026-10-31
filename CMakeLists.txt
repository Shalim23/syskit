cmake_minimum_required(VERSION 4.2)

# CMake 4.2 experimental gate for C++23 `import std;` (must precede `project()`).
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")

# Must precede `project()` so Clang's `std.pcm` target matches consumer flags.
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project(syskit LANGUAGES CXX)

set(CMAKE_CXX_MODULE_STD ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(CMAKE_BINARY_DIR STREQUAL "${CMAKE_SOURCE_DIR}/build/debug")
    file(CREATE_LINK "${CMAKE_BINARY_DIR}/compile_commands.json"
         "${CMAKE_SOURCE_DIR}/compile_commands.json" COPY_ON_ERROR SYMBOLIC)
endif()

add_library(syskit_warnings INTERFACE)
add_library(syskit::warnings ALIAS syskit_warnings)
target_compile_options(syskit_warnings INTERFACE
    -Wall -Wextra -Wpedantic -Werror
    -Wconversion -Wsign-conversion -Wshadow -Wundef
    -Wformat=2 -Wcast-qual -Wold-style-cast
    -Wnon-virtual-dtor -Woverloaded-virtual
    -Wnull-dereference -Wdouble-promotion -Wimplicit-fallthrough
)

enable_testing()

file(GLOB _subprojects LIST_DIRECTORIES FALSE CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/projects/*/CMakeLists.txt"
)
list(SORT _subprojects)
foreach(_manifest IN LISTS _subprojects)
    get_filename_component(_dir "${_manifest}" DIRECTORY)
    add_subdirectory("${_dir}")
endforeach()

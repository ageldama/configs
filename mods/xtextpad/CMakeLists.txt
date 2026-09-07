cmake_minimum_required(VERSION 3.12)
project(xtextpad C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_package(PkgConfig REQUIRED)

pkg_check_modules(GTK3 REQUIRED IMPORTED_TARGET gtk+-3.0)
pkg_check_modules(GDK_X11 REQUIRED IMPORTED_TARGET gdk-x11-3.0)
find_package(X11 REQUIRED)

add_executable(xtextpad xtextpad.c)

target_link_libraries(xtextpad
    PRIVATE
        PkgConfig::GTK3
        PkgConfig::GDK_X11
        X11::X11
)

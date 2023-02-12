# Copyright (c) 2023 Michael Heilmann. All rights reserved.
cmake_minimum_required(VERSION 3.20)

project("PrimordialMachine.ExternalDependencies")

include(ExternalProject)

#message("CMAKE_BUILD_DIR := ${CMAKE_CURRENT_BINARY_DIR}")



########################################################################################
# zlib
########################################################################################

ExternalProject_Add(zlib
                    GIT_REPOSITORY https://github.com/madler/zlib.git
                    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=""
                    GIT_SHALLOW 1)
set(ZLIB_INCLUDE_DIR "${CMAKE_CURRENT_BINARY_DIR}/zlib-prefix/src/zlib-build/include")
set(ZLIB_LIBRARY "${CMAKE_CURRENT_BINARY_DIR}/zlib-prefix/src/zlib-build/lib/zlibstatic.lib")
#message("ZLIB_INCLUDE_DIR := ${ZLIB_INCLUDE_DIR}")
#message("ZLIB_INCLUDE_DIR := ${ZLIB_LIBRARY}")

########################################################################################
# bzip2
########################################################################################

# bzip2 requires Python to build and install.
# Disable it.
if (FALSE)
  ExternalProject_Add(bzip2
                      GIT_REPOSITORY https://gitlab.com/bzip2/bzip2.git
                      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=""
                      GIT_SHALLOW 1)
  set(BZIP2_INCLUDE_DIR "${CMAKE_CURRENT_BINARY_DIR}/bzip2-prefix/src/bzip2-build/include")
  set(BZIP2_LIBRARY "${CMAKE_CURRENT_BINARY_DIR}/bzip2-prefix/src/bzip2-build/lib/zlibstatic.lib")
  #message("BZIP2_INCLUDE_DIR := ${BZIP2_INCLUDE_DIR}")
  #message("BZIP2_INCLUDE_DIR := ${BZIP2_LIBRARY}")
endif()

########################################################################################
# libpng
########################################################################################

# Add "zlib".
list(APPEND CMAKE_ARGS "-DZLIB_INCLUDE_DIRS=${ZLIB_INCLUDE_DIR}")
list(APPEND CMAKE_ARGS "-DPNG_BUILD_ZLIB=ON")

# No shared library.
list(APPEND CMAKE_ARGS "-DPNG_SHARED=OFF")
# No tests.
list(APPEND CMAKE_ARGS "-DPNG_TESTS=OFF")
# No shared library.
list(APPEND CMAKE_ARGS "-DPNG_SHARED=OFF")
# @todo What does this doe?
list(APPEND CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=\"\"")
#message("CMAKE_ARGS := ${CMAKE_ARGS}")

ExternalProject_Add(libpng
                    GIT_REPOSITORY https://github.com/glennrp/libpng.git
                    CMAKE_ARGS ${CMAKE_ARGS}
                    DEPENDS zlib
                    GIT_SHALLOW 1)
set(LIBPNG_INCLUDE_DIR "${CMAKE_CURRENT_BINARY_DIR}/libpng-prefix/src/libpng-build/include")
set(LIBPNG_LIBRARY "${CMAKE_CURRENT_BINARY_DIR}/libpng-prefix/src/libpng-build/lib/libpng16_static.lib")
#message("LIBPNG_INCLUDE_DIR := ${LIBPNG_INCLUDE_DIR}")
#message("LIBPNG_INCLUDE_DIR := ${LIBPNG_LIBRARY}")

########################################################################################
# freetype
########################################################################################

set(CMAKE_ARGS "")
# Add "zlib".
list(APPEND CMAKE_ARGS "-DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}")
list(APPEND CMAKE_ARGS "-DZLIB_LIBRARY=${ZLIB_LIBRARY}")
# Add "libpng".
list(APPEND CMAKE_ARGS "-DPNG_PNG_INCLUDE_DIR=${LIBPNG_INCLUDE_DIR}")
list(APPEND CMAKE_ARGS "-DPNG_LIBRARY=${LIBPNG_LIBRARY}")
# We do not want shared libs. Default is false, but just to make sure.
list (APPEND CMAKE_ARGS "-DBUILD_SHARED_LIBS=false") 
# @todo What does this doe?
list(APPEND CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=\"\"")
#message("CMAKE_ARGS := ${CMAKE_ARGS}")
ExternalProject_Add(freetype
                    GIT_REPOSITORY https://gitlab.freedesktop.org/freetype/freetype.git
                    CMAKE_ARGS ${CMAKE_ARGS}
                    DEPENDS libpng zlib
                    GIT_SHALLOW 1)

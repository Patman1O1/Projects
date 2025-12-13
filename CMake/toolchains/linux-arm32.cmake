#-----------------------------------------------------------------------------------------------------------------------
# Linux ARM Toolchain
#
# Description:
#   A toolchain for Linux OS distributions using CPUs with the ARM32 architecture.
#-----------------------------------------------------------------------------------------------------------------------
# Target System
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Host Compilers
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

# Cross Compilers
set(CMAKE_C_COMPILER_TARGET  arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER_TARGET  arm-linux-gnueabihf-g++)

# System Root for Target System
set(CMAKE_SYSROOT /usr/arm-linux-gnueabihf)
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})

# Never search the host for target headers/libs
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Avoid try_compile() using executables
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

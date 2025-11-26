#!/usr/bin/env bash

# ----------------------------------------------------------------
# mkprg.sh
#
# Usage:
#   ./mkprg.sh <name>
# ----------------------------------------------------------------

# Exit the script whenever a non-zero exit status is received
set -e

# Define arguments
NAME="$1"

# Create the C++ program using CMake
cmake -DLIBRARY_NAME="${NAME}" -P cmake_library.cmake

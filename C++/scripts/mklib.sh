#!/usr/bin/env bash

# ----------------------------------------------------------------
# mklib.sh
#
# Usage:
#   ./mklib.sh <type> <name> [namespace]

# Where <type> is either shared or static
# ----------------------------------------------------------------

# Exit the script whenever a non-zero exit status is received
set -e

# Define arguments
TYPE="$1"
NAME="$2"
NAMESPACE="${3-${NAME}}"

# Create the C++ library using CMake
cmake -DLIBRARY_TYPE="${TYPE}" -DLIBRARY_NAME="${NAME}" -DLIBRARY_NAMESPACE="${NAMESPACE}" -P cmake_library.cmake

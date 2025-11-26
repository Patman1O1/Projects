#!/usr/bin/env bash

# Define parameters
TYPE="$1"

# Define local variables
LIB="lambda"
PRO="pi"

# Delete the library from the C directory
echo "Removing files from libraries/${TYPE}/${LIB}..."
cd "libraries/${TYPE}" || echo "libraries/${TYPE}/${LIB} already deleted"
rm -r "${LIB}"
echo "Successfully removed files from libraries/${TYPE}/${LIB}..."

# Delete library files from /usr/local/lib
echo "Removing files from /usr/local/lib"
sudo rm -r "/usr/local/lib/lib${LIB}.so.1.0.0" || echo "/usr/local/lib/lib${LIB}.so.1.0.0 already removed"
sudo rm -r "/usr/local/lib/lib${LIB}.so.1" || echo "/usr/local/lib/lib${LIB}.so.1 already removed"
sudo rm -r "/usr/local/lib/lib${LIB}.so" || echo "/usr/local/lib/lib${LIB}.so already removed"

# Delete library files from /usr/local/include
echo "Removing files from /usr/local/include"
sudo rm -r "/usr/local/include/${LIB}" || echo "/usr/local/include already removed"

# Delete library files from /usr/local/lib/cmake
echo "Removing files files /usr/local/lib/cmake"
sudo rm -r "/usr/local/lib/cmake/${LIB}" || echo "/usr/local/lib/cmake already removed"

# Go back to the C directory
cd ..
cd ..

# Delete the program from the C directory
echo "Removing files from program/${PRO}..."
cd "programs" || echo "programs/${PRO} already removed"
rm -r "${PRO}"

echo "All files successfully removed"
exit 0

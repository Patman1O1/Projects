#-----------------------------------------------------------------------------------------------------------------------
# Includes
#-----------------------------------------------------------------------------------------------------------------------
include("../CMake/modules/VariablesCMake.cmake")


#-----------------------------------------------------------------------------------------------------------------------
# Variable Configuration
#-----------------------------------------------------------------------------------------------------------------------
# Required
set(NAME "" CACHE STRING "NAME") # Required

# Optional
set(NAMESPACE "" CACHE STRING "NAMESPACE")
set(DESCRIPTION "\"\"" CACHE STRING "DESCRIPTION")
set(VERSION 1.0.0)

# Predefined
set(NAME_UPPER "${NAME}" CACHE STRING "NAME_UPPER")
set(NAME_LOWER "${NAME}" CACHE STRING "NAME_LOWER")
set(EXECUTABLE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/executables/${NAME}")
set(TEMPLATE_DIR "${CMAKE_SOURCE_DIR}/executables/__template__")

# Formating
string(TOUPPER "${NAME_UPPER}" NAME_UPPER)
string(TOLOWER "${NAME_LOWER}" NAME_LOWER)

# Make sure required arguments were specified
if (NOT NAME)
    message(FATAL_ERROR "-DNAME was not specified")
endif()

# Make the namespace the name of the library if a namespace has not been specified...
if (NOT NAMESPACE)
    set(NAMESPACE "${NAME}")
endif()

# Prompt the user of the creation of the executable
message(STATUS "Creating ${NAME}...")


#-----------------------------------------------------------------------------------------------------------------------
# Source Directory Configuration
#-----------------------------------------------------------------------------------------------------------------------
# Configure ${EXECUTABLE_SOURCE_DIR}
file(MAKE_DIRECTORY "${EXECUTABLE_SOURCE_DIR}")

configure_file(
        "${TEMPLATE_DIR}/CMakeLists.txt.in"
        "${EXECUTABLE_SOURCE_DIR}/CMakeLists.txt"
        @ONLY
)

file(COPY_FILE "CMakePresets.json" "${EXECUTABLE_SOURCE_DIR}/CMakePresets.json")

file(COPY_FILE ".gitignore" "${EXECUTABLE_SOURCE_DIR}/.gitignore")


# Configure ${EXECUTABLE_SOURCE_DIR}/src
file(MAKE_DIRECTORY "${EXECUTABLE_SOURCE_DIR}/src")

configure_file(
        "${TEMPLATE_DIR}/src/main.c.in"
        "${EXECUTABLE_SOURCE_DIR}/src/main.c"
        @ONLY
)

configure_file(
        "${TEMPLATE_DIR}/src/CMakeLists.txt.in"
        "${EXECUTABLE_SOURCE_DIR}/src/CMakeLists.txt"
        @ONLY
)


# Configure ${EXECUTABLE_SOURCE_DIR}/tests
file(MAKE_DIRECTORY "${EXECUTABLE_SOURCE_DIR}/tests")

configure_file(
        "${TEMPLATE_DIR}/tests/CMakeLists.txt.in"
        "${EXECUTABLE_SOURCE_DIR}/tests/CMakeLists.txt"
)

configure_file(
        "${TEMPLATE_DIR}/tests/__template___tests.c.in"
        "${EXECUTABLE_SOURCE_DIR}/tests/${NAME}_tests.c"
)

# Prompt the user that the executable was successfully created
message(STATUS "${NAME} successfully created")

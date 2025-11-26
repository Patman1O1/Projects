#-----------------------------------------------------------------------------------------------------------------------
# Includes
#-----------------------------------------------------------------------------------------------------------------------
include("cmake/preconfigure.cmake")


#-----------------------------------------------------------------------------------------------------------------------
# Variable Configuration
#-----------------------------------------------------------------------------------------------------------------------
# Required
set(NAME "" CACHE STRING "NAME") # Required

# Optional
set(DESCRIPTION "\"\"" CACHE STRING "DESCRIPTION")
set(VERSION 1.0.0)

# Predefined
set(NAME_UPPER "${NAME}" CACHE STRING "NAME_UPPER")
set(NAME_LOWER "${NAME}" CACHE STRING "NAME_LOWER")
set(PROGRAM_SOURCE_DIR "${CMAKE_SOURCE_DIR}/programs/${NAME}")
set(TEMPLATE_DIR "${CMAKE_SOURCE_DIR}/programs/__template__")

# Formating
string(TOUPPER "${NAME_UPPER}" NAME_UPPER)
string(TOLOWER "${NAME_LOWER}" NAME_LOWER)

# Make sure required arguments were specified
if (NOT NAME)
    message(FATAL_ERROR "-DNAME was not specified")
endif()

# Prompt the user of the creation of the program
message(STATUS "Creating ${NAME}...")


#-----------------------------------------------------------------------------------------------------------------------
# Source Directory Configuration
#-----------------------------------------------------------------------------------------------------------------------
# Configure ${PROGRAM_SOURCE_DIR}
file(MAKE_DIRECTORY "${PROGRAM_SOURCE_DIR}")

configure_file(
        "${TEMPLATE_DIR}/CMakeLists.txt.in"
        "${PROGRAM_SOURCE_DIR}/CMakeLists.txt"
        @ONLY
)

file(COPY_FILE "CMakePresets.json" "${PROGRAM_SOURCE_DIR}/CMakePresets.json")

file(COPY_FILE ".gitignore" "${PROGRAM_SOURCE_DIR}/.gitignore")


# Configure ${PROGRAM_SOURCE_DIR}/src
file(MAKE_DIRECTORY "${PROGRAM_SOURCE_DIR}/src")

configure_file(
        "${TEMPLATE_DIR}/src/main.cpp.in"
        "${PROGRAM_SOURCE_DIR}/src/main.cpp"
        @ONLY
)

configure_file(
        "${TEMPLATE_DIR}/src/CMakeLists.txt.in"
        "${PROGRAM_SOURCE_DIR}/src/CMakeLists.txt"
        @ONLY
)


# Configure ${PROGRAM_SOURCE_DIR}/tests
file(MAKE_DIRECTORY "${PROGRAM_SOURCE_DIR}/tests")

configure_file(
        "${TEMPLATE_DIR}/tests/CMakeLists.txt.in"
        "${PROGRAM_SOURCE_DIR}/tests/CMakeLists.txt"
)

configure_file(
        "${TEMPLATE_DIR}/tests/__template___tests.cpp.in"
        "${PROGRAM_SOURCE_DIR}/tests/${NAME}_tests.cpp"
)

# Prompt the user that the program was successfully created
message(STATUS "${NAME} successfully created")

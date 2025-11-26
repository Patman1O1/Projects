#-----------------------------------------------------------------------------------------------------------------------
# Includes
#-----------------------------------------------------------------------------------------------------------------------
include("../CMake/preconfigure.cmake")

#-----------------------------------------------------------------------------------------------------------------------
# Variable Configuration
#-----------------------------------------------------------------------------------------------------------------------
# Required
set(NAME "" CACHE STRING "NAME")
set(TYPE "" CACHE STRING "TYPE \"\^(STATIC|SHARED|INTERFACE)\$\"")

# Optional
set(NAMESPACE "" CACHE STRING "NAMESPACE")
set(DESCRIPTION "\"\"" CACHE STRING "DESCRIPTION")
set(VERSION 1.0.0)

# Predefined
set(NAME_UPPER "${NAME}" CACHE STRING "NAME_UPPER")
set(NAME_LOWER "${NAME}" CACHE STRING "NAME_LOWER")
set(TYPE_LOWER "${TYPE}" CACHE STRING "TYPE_LOWER")
set(LIBRARY_SOURCE_DIR "${CMAKE_SOURCE_DIR}/libraries/${TYPE_LOWER}/${NAME}")
set(TEMPLATE_DIR "${CMAKE_SOURCE_DIR}/libraries/${TYPE_LOWER}/__template__")

# Formating
string(TOUPPER "${NAME_UPPER}" NAME_UPPER)
string(TOLOWER "${NAME_LOWER}" NAME_LOWER)
string(TOUPPER "${TYPE}" TYPE)
string(TOLOWER "${TYPE}" TYPE_LOWER)

# Set CMake and C related variables
set(PACKAGE_INIT "\@PACKAGE_INIT\@")

# Fail the configuration process if the user does not specify a library name
if (NOT NAME)
    message(FATAL_ERROR "-DNAME was not specified")
endif()

# Make the namespace the name of the library if a namespace has not been specified...
if (NOT NAMESPACE)
    set(NAMESPACE "${NAME}")
endif()

# Fail the configuration process if the user does not specify a valid library type
if (NOT TYPE MATCHES "^(STATIC|SHARED|INTERFACE)$")
    message(FATAL_ERROR "-DTYPE was not specified as STATIC, SHARED, or INTERFACE")
endif()

# Prompt the user of the creation of the library
message(STATUS "Creating ${NAME}...")


#-----------------------------------------------------------------------------------------------------------------------
# Source Directory Configuration
#-----------------------------------------------------------------------------------------------------------------------
# Configure ${LIBRARY_SOURCE_DIR}
file(MAKE_DIRECTORY "${LIBRARY_SOURCE_DIR}")
configure_file(
        "${TEMPLATE_DIR}/CMakeLists.txt.in"
        "${LIBRARY_SOURCE_DIR}/CMakeLists.txt"
        @ONLY
)

file(COPY_FILE "CMakePresets.json" "${LIBRARY_SOURCE_DIR}/CMakePresets.json")

file(COPY_FILE ".gitignore" "${LIBRARY_SOURCE_DIR}/.gitignore")

# Configure ${LIBRARY_SOURCE_DIR}/include/${NAME}
file(MAKE_DIRECTORY "${LIBRARY_SOURCE_DIR}/include/${NAME}")
configure_file(
        "${TEMPLATE_DIR}/include/__template__/__template__.hpp.in"
        "${LIBRARY_SOURCE_DIR}/include/${NAME}/${NAME}.hpp"
        @ONLY
)

if(NOT "${TYPE}" MATCHES "INTERFACE")
    configure_file(
            "${TEMPLATE_DIR}/include/__template__/export.hpp.in"
            "${LIBRARY_SOURCE_DIR}/include/${NAME}/export.hpp"
            @ONLY
    )

    # Configure ${LIBRARY_SOURCE_DIR}/src
    file(MAKE_DIRECTORY "${LIBRARY_SOURCE_DIR}/src")
    configure_file(
            "${TEMPLATE_DIR}/src/__template__.cpp.in"
            "${LIBRARY_SOURCE_DIR}/src/${NAME}.cpp"
            @ONLY
    )


endif()

configure_file(
        "${TEMPLATE_DIR}/src/CMakeLists.txt.in"
        "${LIBRARY_SOURCE_DIR}/src/CMakeLists.txt"
        @ONLY
)

configure_file(
        "${TEMPLATE_DIR}/src/main.cpp.in"
        "${LIBRARY_SOURCE_DIR}/src/main.cpp"
        @ONLY
)


# Configure ${LIBRARY_SOURCE_DIR}/tests
file(MAKE_DIRECTORY "${LIBRARY_SOURCE_DIR}/tests")
configure_file(
        "${TEMPLATE_DIR}/tests/CMakeLists.txt.in"
        "${LIBRARY_SOURCE_DIR}/tests/CMakeLists.txt"
        @ONLY
)

configure_file(
        "${TEMPLATE_DIR}/tests/__template___tests.cpp.in"
        "${LIBRARY_SOURCE_DIR}/tests/${NAME}_tests.cpp"
        @ONLY
)

# Configure ${NAME}/cmake
file(MAKE_DIRECTORY "${LIBRARY_SOURCE_DIR}/cmake")
configure_file(
        "${TEMPLATE_DIR}/cmake/__template__-config.cmake.in.in"
        "${LIBRARY_SOURCE_DIR}/cmake/${NAME}-config.cmake.in"
        @ONLY
)

file(COPY_FILE "templates/cmake_uninstall.cmake.in" "${LIBRARY_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in")

# Prompt the user that the library was created
message(STATUS "${NAME} successfully created")


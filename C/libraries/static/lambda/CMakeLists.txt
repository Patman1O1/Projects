#-----------------------------------------------------------------------------------------------------------------------
# Information
#-----------------------------------------------------------------------------------------------------------------------
cmake_minimum_required(VERSION 4.0)
project(lambda
    VERSION 1.0.0
    DESCRIPTION ""
    LANGUAGES C)


#-----------------------------------------------------------------------------------------------------------------------
# Includes
#-----------------------------------------------------------------------------------------------------------------------
include(GNUInstallDirs)
include(GenerateExportHeader)
include(CMakePackageConfigHelpers)


#-----------------------------------------------------------------------------------------------------------------------
# Settings and Options
#-----------------------------------------------------------------------------------------------------------------------
string(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}" IS_TOP_LEVEL)

option(LAMBDA_BUILD_DOCS "Build lambda documentation" OFF)

set(LAMBDA_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/lambda" CACHE STRING
    "Install path for lambda package-related CMake files")

if(NOT DEFINED CMAKE_BUILD_TYPE AND NOT DEFINED CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

add_library(lambda STATIC)
add_library(lambda::lambda ALIAS lambda)


#-----------------------------------------------------------------------------------------------------------------------
# Sources
#-----------------------------------------------------------------------------------------------------------------------
add_subdirectory(tests)
add_subdirectory(src)

set(EXPORT_FILE_NAME "export_static.h")

generate_export_header(lambda EXPORT_FILE_NAME include/lambda/${EXPORT_FILE_NAME})

set(SOURCES
    include/lambda/export.h
    include/lambda/lambda.h
    src/lambda.c)
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${SOURCES})


#-----------------------------------------------------------------------------------------------------------------------
# Targets
#-----------------------------------------------------------------------------------------------------------------------
target_sources(lambda PRIVATE ${SOURCES})
target_compile_definitions(lambda PUBLIC "${LAMBDA_STATIC_DEFINE}")

target_include_directories(lambda
    PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>")

set_target_properties(lambda PROPERTIES
    SOVERSION ${PROJECT_VERSION_MAJOR}
    VERSION ${PROJECT_VERSION})


#-----------------------------------------------------------------------------------------------------------------------
# Dependencies
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# Installation
#-----------------------------------------------------------------------------------------------------------------------
if(NOT CMAKE_SKIP_INSTALL_RULES)
    configure_package_config_file(cmake/lambda-config.cmake.in lambda-config.cmake
        INSTALL_DESTINATION "${LAMBDA_INSTALL_CMAKEDIR}")

    write_basic_package_version_file(lambda-config-version.cmake
        COMPATIBILITY SameMajorVersion)

    install(TARGETS lambda EXPORT lambda_export
        RUNTIME COMPONENT lambda
        LIBRARY COMPONENT lambda NAMELINK_COMPONENT lambda-dev
        ARCHIVE COMPONENT lambda-dev
        INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
    install(DIRECTORY include/
        TYPE INCLUDE
        COMPONENT lambda-dev)
    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/include/lambda/${EXPORT_FILE_NAME}"
        COMPONENT lambda-dev
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/lambda")

    set(TARGETS_FILE "lambda-static-targets.cmake")

    install(EXPORT lambda_export
        COMPONENT lambda-dev
        FILE "${TARGETS_FILE}"
        DESTINATION "${LAMBDA_INSTALL_CMAKEDIR}"
        NAMESPACE lambda::)

    install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/lambda-config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/lambda-config-version.cmake"
        COMPONENT lambda-dev
        DESTINATION "${LAMBDA_INSTALL_CMAKEDIR}")

endif()

if(LAMBDA_BUILD_DOCS)
    find_package(Doxygen REQUIRED)
    doxygen_add_docs(docs include)
endif()


#-----------------------------------------------------------------------------------------------------------------------
# Uninstallation
#-----------------------------------------------------------------------------------------------------------------------
if(NOT TARGET uninstall)
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

  add_custom_target(uninstall COMMAND ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake")
endif()

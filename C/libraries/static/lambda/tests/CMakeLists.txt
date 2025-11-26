#-----------------------------------------------------------------------------------------------------------------------
# Information
#-----------------------------------------------------------------------------------------------------------------------
cmake_minimum_required(VERSION 4.0)
project(lambda-tests)


#-----------------------------------------------------------------------------------------------------------------------
# Includes
#-----------------------------------------------------------------------------------------------------------------------
include(FetchContent)


#-----------------------------------------------------------------------------------------------------------------------
# Settings and Options
#-----------------------------------------------------------------------------------------------------------------------
string(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}" IS_TOP_LEVEL)
if(IS_TOP_LEVEL)
    enable_testing()
endif()


#-----------------------------------------------------------------------------------------------------------------------
# Google Tests
#-----------------------------------------------------------------------------------------------------------------------
FetchContent_Declare(googletest URL https://github.com/google/googletest/archive/refs/tags/release-1.12.1.tar.gz)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE) # do not override parent project's runtime settings on Windows
set(INSTALL_GTEST OFF)

# For simplicity, always build googletest as static library. This prevents lambda-tests executable from
# complaining about missing googletest DLLs on Windows.
set(BUILD_SHARED_LIBS OFF)

FetchContent_MakeAvailable(googletest)

include(GoogleTest)


#-----------------------------------------------------------------------------------------------------------------------
# Dependencies
#-----------------------------------------------------------------------------------------------------------------------
if(IS_TOP_LEVEL)
    find_package(lambda REQUIRED)
endif()


#----------------------------------------------------------------------------------------------------------------------
# Sources
#----------------------------------------------------------------------------------------------------------------------
set(SOURCES
    lambda_tests.cpp)
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${SOURCES})


#----------------------------------------------------------------------------------------------------------------------
# Targets
#----------------------------------------------------------------------------------------------------------------------
add_executable(lambda-tests)
target_sources(lambda-tests PRIVATE ${SOURCES})

target_link_libraries(lambda-tests
    PRIVATE
        lambda::lambda
        gtest_main)

gtest_discover_tests(lambda-tests)

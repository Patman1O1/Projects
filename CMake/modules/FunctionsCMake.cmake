#-----------------------------------------------------------------------------------------------------------------------
# Includes
#-----------------------------------------------------------------------------------------------------------------------
include(FetchContent)


#-----------------------------------------------------------------------------------------------------------------------
# fetch_gtest()
#
#
#-----------------------------------------------------------------------------------------------------------------------
function(fetch_gtest)
    FetchContent_Declare(googletest URL https://github.com/google/googletest/archive/refs/tags/release-1.12.1.tar.gz)

    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE) # do not override parent project's runtime settings on Windows
    set(INSTALL_GTEST OFF)

    # For simplicity, always build googletest as static library. This prevents @NAME@-tests executable from
    # complaining about missing googletest DLLs on Windows.
    set(BUILD_SHARED_LIBS OFF)

    FetchContent_MakeAvailable(googletest)

    include(GoogleTest)
endfunction()


#-----------------------------------------------------------------------------------------------------------------------
# build_docs()
#
#
#-----------------------------------------------------------------------------------------------------------------------
function(build_docs)
    find_package(Doxygen REQUIRED)
    doxygen_add_docs(docs include)
endfunction()


#-----------------------------------------------------------------------------------------------------------------------
# uninstall()
#
#
# Parameters:
#   LIBRARY_TARGET
#-----------------------------------------------------------------------------------------------------------------------
function(uninstall LIBRARY_TARGET)
    # Ensure the target exists
    if(NOT TARGET ${LIBRARY_TARGET})
        message(FATAL_ERROR "Could not find LIBRARY_TARGET: ${LIBRARY_TARGET}")
    endif()


endfunction()

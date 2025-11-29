#-----------------------------------------------------------------------------------------------------------------------
# Includes
#-----------------------------------------------------------------------------------------------------------------------
include(GNUInstallDirs)
include(GenerateExportHeader)
include(CMakePackageConfigHelpers)


#-----------------------------------------------------------------------------------------------------------------------
# configure_static_cxx_library()
#
#
# Parameters:
#   LIBRARY_TARGET - The target created using add_library()
#-----------------------------------------------------------------------------------------------------------------------
function(configure_static_cxx_library LIBRARY_TARGET)
    # Ensure the target exists
    if(NOT TARGET ${LIBRARY_TARGET})
        message(FATAL_ERROR "Could not find LIBRARY_TARGET: ${LIBRARY_TARGET}")
    endif()

    # Set the library properties
    set_target_properties(${LIBRARY_TARGET} PROPERTIES
            SOVERSION ${PROJECT_VERSION_MAJOR}
            VERSION ${PROJECT_VERSION}
    )

    # Set default build type if not specified
    if(NOT DEFINED CMAKE_BUILD_TYPE AND NOT DEFINED CMAKE_CONFIGURATION_TYPES)
        set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
    endif()

    # Include directories
    target_include_directories(${LIBRARY_TARGET}
            PUBLIC
                "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
                "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>"
                "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )

    # Add source files
    set(LIBRARY_SOURCES
            "${CMAKE_CURRENT_SOURCE_DIR}/include/${LIBRARY_TARGET}/${LIBRARY_TARGET}.hpp"
            "${CMAKE_CURRENT_SOURCE_DIR}/src/${LIBRARY_TARGET}.cpp")

    target_sources(${LIBRARY_TARGET} PRIVATE ${LIBRARY_SOURCES})

    # Group sources for IDE
    source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${LIBRARY_SOURCES})
endfunction()


#-----------------------------------------------------------------------------------------------------------------------
# install_static_cxx_library()
#
#
# Parameters:
#   LIBRARY_TARGET - The target created using add_library()
#-----------------------------------------------------------------------------------------------------------------------
function(install_static_cxx_library LIBRARY_TARGET)
    # Create package configuration file
    configure_package_config_file(
            "${CMAKE_CURRENT_SOURCE_DIR}/cmake/${LIBRARY_TARGET}-config.cmake.in"
            "${LIBRARY_TARGET}-config.cmake"
            INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${LIBRARY_TARGET}"
            NO_CHECK_REQUIRED_COMPONENTS_MACRO
    )

    # Create version file
    write_basic_package_version_file(
            "${LIBRARY_TARGET}-config-version.cmake"
            COMPATIBILITY SameMajorVersion)

    # Create installation rules
    install(TARGETS ${LIBRARY_TARGET}
            EXPORT ${LIBRARY_TARGET}-targets
            RUNTIME COMPONENT ${LIBRARY_TARGET}
            LIBRARY COMPONENT ${LIBRARY_TARGET} NAMELINK_COMPONENT ${LIBRARY_TARGET}-dev
            ARCHIVE COMPONENT ${LIBRARY_TARGET}-dev
            INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")

    install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/"
            TYPE INCLUDE
            COMPONENT ${LIBRARY_TARGET}-dev)

    install(FILES
            "${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_TARGET}-config.cmake"
            "${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_TARGET}-config-version.cmake"
            COMPONENT ${LIBRARY_TARGET}-dev
            DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${LIBRARY_TARGET}")
endfunction()


#-----------------------------------------------------------------------------------------------------------------------
# configure_shared_cxx_library()
#
#
# Parameters:
#   LIBRARY_TARGET - The target created using add_library()
#-----------------------------------------------------------------------------------------------------------------------
function(configure_shared_cxx_library LIBRARY_TARGET)
    # Ensure the target exists
    if(NOT TARGET ${LIBRARY_TARGET})
        message(FATAL_ERROR "Could not find LIBRARY_TARGET: ${LIBRARY_TARGET}")
    endif()

    # Set the library properties
    set_target_properties(${LIBRARY_TARGET} PROPERTIES
            SOVERSION ${PROJECT_VERSION_MAJOR}
            VERSION ${PROJECT_VERSION}
    )

    # Set default build type if not specified
    if(NOT DEFINED CMAKE_BUILD_TYPE AND NOT DEFINED CMAKE_CONFIGURATION_TYPES)
        set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
    endif()

    # Set visibility
    set_target_properties(${LIBRARY_TARGET}
            PROPERTIES
            CXX_VISIBILITY_PRESET hidden
            VISIBILITY_INLINES_HIDDEN YES
    )

    # Generate the export header
    generate_export_header(${LIBRARY_TARGET}
            EXPORT_FILE_NAME "${CMAKE_CURRENT_SOURCE_DIR}/include/${LIBRARY_TARGET}/export.hpp"
    )

    # Include directories
    target_include_directories(${LIBRARY_TARGET}
            PUBLIC
            "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
            "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )

    # Add source files
    set(LIBRARY_SOURCES
            "${CMAKE_CURRENT_SOURCE_DIR}/include/${LIBRARY_TARGET}/export.hpp"
            "${CMAKE_CURRENT_SOURCE_DIR}/include/${LIBRARY_TARGET}/${LIBRARY_TARGET}.hpp"
            "${CMAKE_CURRENT_SOURCE_DIR}/src/${LIBRARY_TARGET}.cpp")

    target_sources(${LIBRARY_TARGET} PRIVATE ${LIBRARY_SOURCES})

    # Group sources for IDE
    source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${LIBRARY_SOURCES})
endfunction()


#-----------------------------------------------------------------------------------------------------------------------
# install_shared_cxx_library()
#
#
# Parameters:
#   LIBRARY_TARGET - The target created using add_library()
#-----------------------------------------------------------------------------------------------------------------------
function(install_shared_cxx_library LIBRARY_TARGET NAMESPACE)
    configure_package_config_file(
            "${CMAKE_CURRENT_SOURCE_DIR}/cmake/${LIBRARY_TARGET}-config.cmake.in"
            "${LIBRARY_TARGET}-config.cmake"
            INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${LIBRARY_TARGET}"
            NO_CHECK_REQUIRED_COMPONENTS_MACRO
    )

    write_basic_package_version_file(
            "${LIBRARY_TARGET}-config-version.cmake"
            COMPATIBILITY SameMajorVersion
    )

    install(TARGETS ${LIBRARY_TARGET}
            EXPORT ${LIBRARY_TARGET}-targets
            RUNTIME COMPONENT ${LIBRARY_TARGET}
            LIBRARY COMPONENT ${LIBRARY_TARGET} NAMELINK_COMPONENT ${LIBRARY_TARGET}-dev
            ARCHIVE COMPONENT ${LIBRARY_TARGET}-dev
            INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")

    install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/"
            TYPE INCLUDE
            COMPONENT ${LIBRARY_TARGET}-dev)

    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/include/${LIBRARY_TARGET}/export.hpp"
            COMPONENT ${LIBRARY_TARGET}-dev
            DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBRARY_TARGET}")

    install(EXPORT ${LIBRARY_TARGET}-targets
            COMPONENT ${LIBRARY_TARGET}-dev
            FILE "${LIBRARY_TARGET}-export.cmake"
            DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${LIBRARY_TARGET}"
            NAMESPACE ${NAMESPACE}::)

    install(FILES
            "${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_TARGET}-config.cmake"
            "${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_TARGET}-config-version.cmake"
            COMPONENT ${LIBRARY_TARGET}-dev
            DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${LIBRARY_TARGET}")
endfunction()


#-----------------------------------------------------------------------------------------------------------------------
# configure_interface_cxx_library()
#
#
# Parameters:
#   LIBRARY_TARGET - The target created using add_library()
#-----------------------------------------------------------------------------------------------------------------------
function(configure_interface_cxx_library LIBRARY_TARGET)
    # Ensure the target exists
    if(NOT TARGET ${LIBRARY_TARGET})
        message(FATAL_ERROR "Could not find LIBRARY_TARGET: ${LIBRARY_TARGET}")
    endif()

    # Set default build type if not specified
    if(NOT DEFINED CMAKE_BUILD_TYPE AND NOT DEFINED CMAKE_CONFIGURATION_TYPES)
        set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
    endif()

    # Include directories
    target_include_directories(${LIBRARY_TARGET}
            INTERFACE
            "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
            "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )
endfunction()


#-----------------------------------------------------------------------------------------------------------------------
# install_interface_cxx_library()
#
#
# Parameters:
#   LIBRARY_TARGET - The target created using add_library()
#-----------------------------------------------------------------------------------------------------------------------
function(install_interface_cxx_library LIBRARY_TARGET)
    configure_package_config_file(
            "${CMAKE_CURRENT_SOURCE_DIR}/cmake/${LIBRARY_TARGET}-config.cmake.in"
            "${LIBRARY_TARGET}-config.cmake"
            INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${LIBRARY_TARGET}")

    write_basic_package_version_file(
            "${LIBRARY_TARGET}-config-version.cmake"
            COMPATIBILITY SameMajorVersion)

    install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/"
            TYPE INCLUDE
            COMPONENT ${LIBRARY_TARGET}-dev)

    install(TARGETS ${LIBRARY_TARGET}
            EXPORT ${LIBRARY_TARGET}-targets
            COMPONENT ${LIBRARY_TARGET}-dev
    )

    install(FILES
            "${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_TARGET}-config.cmake"
            "${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_TARGET}-config-version.cmake"
            COMPONENT ${LIBRARY_TARGET}-dev
            DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${LIBRARY_TARGET}")
endfunction()


#-----------------------------------------------------------------------------------------------------------------------
# build_main_cxx()
#
#
# Parameters:
#   LIBRARY_TARGET - The target created using add_library()
#   NAMESPACE - The namespace the target is in
#-----------------------------------------------------------------------------------------------------------------------
function(build_main_cxx LIBRARY_TARGET NAMESPACE)
    if(NOT TARGET ${LIBRARY_TARGET} AND NOT TARGET ${NAMESPACE}::${LIBRARY_TARGET})
        find_package(${LIBRARY_TARGET} REQUIRED)
    endif()

    set(SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp")
    source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${SOURCES})

    add_executable(${LIBRARY_TARGET}-main)
    target_sources(${LIBRARY_TARGET}-main PRIVATE ${SOURCES})
    target_link_libraries(${LIBRARY_TARGET}-main PRIVATE ${NAMESPACE}::${LIBRARY_TARGET})
endfunction()


#-----------------------------------------------------------------------------------------------------------------------
# build_tests()
#
#
# Parameters:
#   LIBRARY_TARGET - The target created using add_library()
#   NAMESPACE - The namespace the target is in
#-----------------------------------------------------------------------------------------------------------------------
function(build_tests LIBRARY_TARGET NAMESPACE)
    if(NOT TARGET ${LIBRARY_TARGET} AND NOT TARGET ${NAMESPACE}::${LIBRARY_TARGET})
        find_package(${LIBRARY_TARGET} REQUIRED)
    endif()

    fetch_gtest()

    set(SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/${LIBRARY_TARGET}_tests.cpp")
    source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${SOURCES})

    add_executable(${LIBRARY_TARGET}-tests)
    target_sources(${LIBRARY_TARGET}-tests PRIVATE ${SOURCES})
    target_link_libraries(${LIBRARY_TARGET}-tests
            PRIVATE
                ${NAMESPACE}::${LIBRARY_TARGET}
                gtest_main)

    gtest_discover_tests(${LIBRARY_TARGET}-tests)
endfunction()

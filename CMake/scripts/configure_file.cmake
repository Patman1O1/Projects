set(INPUT "" CACHE STRING "Input Filepath")
if(NOT "${INPUT}")
    message(FATAL_ERROR "-DINPUT was not specified")
endif()

set(OUTPUT "" CACHE STRING "Output Filepath")
if (NOT "${OUTPUT}")
    message(FATAL_ERROR "-DOUTPUT was not specified")
endif()

configure_file("${INPUT}" "${OUTPUT}")

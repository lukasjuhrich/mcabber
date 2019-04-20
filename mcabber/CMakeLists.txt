project(mcabber)
cmake_minimum_required(VERSION 3.13)

cmake_policy(SET CMP0054 NEW)

add_compile_options(-W -Wall)

include(dependencies.cmake)  # project-wide dependencies
add_subdirectory(mcabber)
add_subdirectory(doc)
add_subdirectory(modules)

# TODO configure the config in `include`
# TODO what is the top-level config used for?
# configure_file("include/config-cmake.h.in" "include/config.h")

# TODO
# install(FILES  mcabber.pc DESTINATION bin/mcabber)

# uninstall target
if(NOT TARGET uninstall)
    configure_file(
            "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
            "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
            IMMEDIATE @ONLY)

    add_custom_target(uninstall
            COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endif()

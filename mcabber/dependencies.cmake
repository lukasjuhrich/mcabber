# Packages which are required project-wide.
# (that is, not only required for the mcabber binary, but also e.g. for modules)

# TODO insert that into a separate cmake module
# https://cmake.org/pipermail/cmake/2010-November/041052.html
find_package(PkgConfig REQUIRED)


# GLIB

# Sets $GLIB_* variables. see cmake --help-module FindPkgConfig
pkg_search_module(GLIB REQUIRED glib-2.0)
if(${GLIB_FOUND})
    set(HAVE_GLIB)
endif()

include_directories(PRIVATE ${GLIB_INCLUDE_DIRS})
link_libraries(${GLIB_LDFLAGS})



# LOUDMOUTH

pkg_search_module(LOUDMOUTH REQUIRED loudmouth-1.0>=1.4.2)
include_directories(PRIVATE ${LOUDMOUTH_INCLUDE_DIRS})
link_libraries(${LOUDMOUTH_LDFLAGS})

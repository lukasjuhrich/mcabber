include(../macros/macros.cmake)

# TEMPLATES / CONFIG
# The version number.
set(PACKAGE_NAME "mcabber")
# set(PACKAGE_TARNAME, "TODO")
set(PACKAGE_VERSION "1.1.1-dev")
# set(PACKAGE_STRING, "TODO")
set(PACKAGE_BUGREPORT "mcabber@lilotux.net")
# set(PACKAGE_URL, "TODO")
set(MCABBER_BRANCH "cmake")

# options can be set by adding e.g. `-DWITH_ASPELL=ON`
# for a list of available options, use `cmake -LH .`
option(WITH_ENCHANT "Compile with ENCHANT support")
option(HAVE_GPGME "Compile with GPGME support")
option(PKGLIB_DIR "TODO")  # TODO
option(ENABLE_DEBUG "Build in DEBUG configuration")

# defines target mcabber
add_executable(mcabber
    main.c
    main.h
    roster.c
    roster.h
    events.c
    events.h
    fifo.h
    fifo_internal.c
    # ../modules/fifo/fifo.c
    commands.c
    commands.h
    compl.c
    compl.h
    hbuf.c
    hbuf.h
    screen.c
    screen.h
    logprint.h
    settings.c
    settings.h
    hooks.c
    hooks.h
    utf8.c
    utf8.h
    histolog.c
    histolog.h
    utils.c
    utils.h
    pgp.c
    pgp.h
    xmpp.c
    xmpp.h
    xmpp_helper.c
    xmpp_helper.h
    xmpp_defines.h
    xmpp_iq.c
    xmpp_iq.h
    xmpp_iqrequest.c
    xmpp_iqrequest.h
    xmpp_muc.c
    xmpp_muc.h
    xmpp_s10n.c
    xmpp_s10n.h
    caps.c
    caps.h
    help.c
    help.h
    carbons.c
    carbons.h)

# this provides the top-level directory for including `<mcabber/config.h>`
target_include_directories(mcabber PRIVATE ${PROJECT_BINARY_DIR})
# this provides the include-directory for including `<config.h>`
target_include_directories(mcabber PUBLIC ../include)

######## DEPENDENCIES ########

# TODO insert that into a separate cmake module
# https://cmake.org/pipermail/cmake/2010-November/041052.html
find_package(PkgConfig REQUIRED)

# GLIB
# Sets $GLIB_* variables. see cmake --help-module FindPkgConfig
pkg_search_module(GLIB REQUIRED glib-2.0)
if(${GLIB_FOUND})
    set(HAVE_GLIB)
endif()

# option(HAVE_GLIB "Enable or disable glib support")  # TODO think whether that makes sense.

target_include_directories(mcabber PRIVATE ${GLIB_INCLUDE_DIRS})
add_definitions(${GLIB_CFLAGS_OTHER})  # TODO check whether that's necessary
target_link_libraries(mcabber ${GLIB_LDFLAGS})


# NCURSES

pkg_search_module(NCURSES REQUIRED ncursesw ncurses)
target_include_directories(mcabber PRIVATE ${NCURSES_INCLUDE_DIRS})
target_link_libraries(mcabber ${NCURSES_LDFLAGS})

option(HAVE_UNICODE "whether to compile with unicode support." ON)  # TODO use a check script instead

# panelw is optional
pkg_search_module(PANEL panelw panel)
target_include_directories(mcabber PRIVATE ${PANEL_INCLUDE_DIRS})
target_link_libraries(mcabber ${PANEL_LDFLAGS})

# what did we get? libpanelw or libpanel?
if(panelw IN_LIST PANEL_LIBS)
    set(HAVE_LIBPANELW)
elseif(panel IN_LIST PANEL_LIBS)
    set(HAVE_LIBPANEL)
endif()

include(CheckIncludeFile)

check_include_file(ncursesw/ncurses.h HAVE_NCURSESW_NCURSES_H)
check_include_file(ncursesw/panel.h HAVE_NCURSESW_PANEL_H)

check_include_file(ncurses/ncurses.h HAVE_NCURSES_NCURSES_H)
check_include_file(ncurses/panel.h HAVE_NCURSES_PANEL_H)

check_include_file(ncurses.h HAVE_NCURSES_H)
check_include_file(panel.h HAVE_PANEL_H)


# LOUDMOUTH
pkg_search_module(LOUDMOUTH REQUIRED loudmouth-1.0>=1.4.2)

target_include_directories(mcabber PRIVATE ${LOUDMOUTH_INCLUDE_DIRS})
target_link_libraries(mcabber ${LOUDMOUTH_LDFLAGS})

# ASPELL

option(WITH_ASPELL "Compile with aspell support" OFF)
if(${WITH_ASPELL})
    pkg_search_module(ASPELL aspell)
    if(${ASPELL_FOUND})
        target_include_directories(mcabber PRIVATE ${ASPELL_INCLUDE_DIRS})
        target_link_libraries(mcabber ${ASPELL_LDFLAGS})
    else()
        message(FATAL_ERROR aspell not found.)
    endif()
endif()


# OTR
option(EnableOtr "Enable OTR support" ON)
if(EnableOtr)
    # TODO make function so we can utilize `return()` for nicer control flow.
    pkg_search_module(LIBOTR4 libotr>=4.0.0)
    if(LIBOTR4_FOUND)
        message(STATUS "Found libotr version ${LIBOTR4_VERSION}")
        target_include_directories(mcabber PRIVATE ${LIBOTR4_INCLUDE_DIRS})
        target_link_libraries(mcabber ${LIBOTR4_LDFLAGS})
    else()
        pkg_search_module(LIBOTR3 libotr=3.1.0)
        if(LIBOTR3_FOUND)
            message(STATUS "Found libotr version ${LIBOTR3_VERSION}")
            option(HAVE_LIBOTR3 "Whether to use libotr 3 instead of 4" ON)
            target_include_directories(mcabber PRIVATE ${LIBOTR3_INCLUDE_DIRS})
            target_link_libraries(mcabber ${LIBOTR3_LDFLAGS})
        else()
            message(FATAL_ERROR "libotr 3.1.0 or newer is required.")
        endif()
    endif()

    option(HAVE_LIBOTR "" ON)
    target_sources(mcabber PRIVATE otr.c otr.h nohtml.c nohtml.h)
endif()


# MODULES
option(MODULES_ENABLE "Define if you want dynamic modules loading" ON)
if(MODULES_ENABLE)
    target_sources(mcabber PRIVATE modules.h modules.c)

    pkg_search_module(GMODULE REQUIRED gmodule-2.0)
    target_include_directories(mcabber PRIVATE ${GMODULE_INCLUDE_DIRS})
    target_link_libraries(mcabber ${GMODULE_LDFLAGS})
endif()

######## CONFIG.H ########
configure_file("config-cmake.h.in" "${PROJECT_BINARY_DIR}/mcabber/config.h")
target_sources(mcabber PUBLIC "${PROJECT_BINARY_DIR}/mcabber/config.h")

######## INSTALL ########
install(TARGETS mcabber DESTINATION .)

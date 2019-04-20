add_library(urlregex SHARED urlregex.c)
target_include_directories(urlregex PRIVATE ${PROJECT_BINARY_DIR})  # allows for <mcabber/*.h> includes

option(HAVE_GLIB_REGEX "Define whether glib has regex support" ON)
if(HAVE_GLIB_REGEX)
    target_compile_options(urlregex PRIVATE "-DHAVE_GLIB_REGEX")
endif()

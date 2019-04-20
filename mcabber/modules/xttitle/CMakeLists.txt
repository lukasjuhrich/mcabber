add_library(xttitle SHARED xttitle.c)
target_include_directories(xttitle PRIVATE ${PROJECT_BINARY_DIR})  # allows for <mcabber/*.h> includes

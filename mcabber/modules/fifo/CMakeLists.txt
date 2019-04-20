add_library(fifo SHARED fifo.c)
target_include_directories(fifo PRIVATE ${PROJECT_BINARY_DIR})  # allows for <mcabber/*.h> includes

add_library(beep SHARED beep.c)
target_include_directories(beep PRIVATE ${PROJECT_BINARY_DIR})  # allows for <mcabber/*.h> includes

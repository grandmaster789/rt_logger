add_executable(test_main test_main.cpp)

target_include_directories(test_main PRIVATE ../src)
target_link_libraries(test_main rt_logger)
add_executable(test_main test_main.cpp)

target_include_directories(test_main PRIVATE ../src)
target_link_libraries(test_main PRIVATE Catch2::Catch2WithMain rt_logger)

catch_discover_tests(test_main)
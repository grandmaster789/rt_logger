add_library(rt_logger rt_logger.cpp)

# termcolor is fetched in the /dependencies CMakeLists.txt
target_link_libraries(rt_logger PRIVATE termcolor)
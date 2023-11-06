cmake_minimum_required(VERSION 3.26)

project(rt_logger)

# Project template to make a cmake fetch-content-able library with CI/CD and testing triggers
# (started out with lefticus' template, but it was too cluttered for my taste)

set(CMAKE_CXX_STANDARD 23)

add_subdirectory(src)
add_subdirectory(dependencies)
add_subdirectory(test)
cmake_minimum_required(VERSION 3.26)

project(rt_logger) # possibly name conflict with the library name itself - should look up the details, naming is hard

# Project template to make a cmake fetch-content-able library with CI/CD and testing triggers
# (started out with lefticus' template, but it was too cluttered for my taste)

set(CMAKE_CXX_STANDARD 23)

add_subdirectory(src)
add_subdirectory(dependencies)

# should probably make testing optional
enable_testing()
add_subdirectory(test)

# for projects consuming this, the only relevant part is the library
# NOTE the API is declared in /src/CMakeLists.txt
install(TARGETS rt_logger LIBRARY DESTINATION lib)
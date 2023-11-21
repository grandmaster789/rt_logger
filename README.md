<h1>Rt Logger</h1>

This is a C++23 logging framework, with a focus on making this available via <i>cmake FetchContent</i>

Features include:
- Crossplatform across Windows and Linux
- CI/CD
- Customizable message sinks
- Multi-sink outputs
- Stack traces
- Crash handling
- Threadsafe

To make use of this library in your CMake-based project, add the following to CMakeList.txt:
```
include(FetchContent)
FetchContent_Declare(
    rt_logger
    GIT_REPOSITORY "https://github.com/grandmaster789/rt_logger.git"
    GIT_TAG        "origin/main"
)
FetchContent_MakeAvailable(rt_logger)
```

include(FetchContent)

FetchContent_Declare(
        termcolor
        GIT_REPOSITORY "https://github.com/ikalnytskyi/termcolor.git"
        GIT_TAG        "v2.1.0"
)

# https://github.com/catchorg/Catch2/blob/devel/docs/Readme.md
FetchContent_Declare(
        Catch2
        GIT_REPOSITORY "https://github.com/catchorg/Catch2.git"
        GIT_TAG        "v3.0.1"
)

FetchContent_MakeAvailable(termcolor)
FetchContent_MakeAvailable(Catch2)

include(CTest)
include(Catch)
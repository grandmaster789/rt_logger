include(FetchContent)

FetchContent_Declare(
        termcolor
        GIT_REPOSITORY "https://github.com/ikalnytskyi/termcolor.git"
        GIT_TAG "v2.1.0"
)

FetchContent_MakeAvailable(termcolor)
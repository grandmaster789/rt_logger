add_library(rt_logger

            rt_logger.cpp
            log_category.cpp
            detail/log_message.h
)

# termcolor is fetched in the /dependencies CMakeLists.txt
target_link_libraries(rt_logger PRIVATE termcolor)

target_sources(rt_logger PUBLIC
    FILE_SET api
        TYPE HEADERS
        BASE_DIRS .
        FILES
               "rt_logger.h"
)
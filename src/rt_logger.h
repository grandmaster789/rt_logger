#ifndef RT_LOGGER_H
#define RT_LOGGER_H

#include <ostream>
#include <format>
#include <utility>
#include <iostream>
#include <sstream>
#include <source_location>

#include "log_category.h"

namespace rt {
  int square(int value); // something simple to check the infrastructure works...
  void show_stacktrace();

  template <typename... t_Args>
  struct LogHelper {
    explicit LogHelper(
        std::format_string<t_Args...> fmt,
        t_Args&&...                   args,
        std::source_location          location = std::source_location::current()
    ) {
      m_Buffer << std::format("{0}", e_LogCategory::debug);
      m_Buffer << std::format(fmt, std::forward<t_Args...>(args...));
      m_Buffer << std::format("{0} {1} {2} {3}",
                              location.function_name(),
                              location.file_name(),
                              location.line(),
                              location.column()
      );
    }

    ~LogHelper() {
      std::cout << "~\n";
    }

    LogHelper()                                  = default;
    LogHelper             (const LogHelper&)     = delete;
    LogHelper& operator = (const LogHelper&)     = delete;
    LogHelper             (LogHelper&&) noexcept = default;
    LogHelper& operator = (LogHelper&&) noexcept = default;

    static thread_local std::stringstream m_Buffer;
  };
}

#endif

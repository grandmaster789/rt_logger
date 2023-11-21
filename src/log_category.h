#ifndef RT_LOGGER_LOG_CATEGORY_H
#define RT_LOGGER_LOG_CATEGORY_H

#include <iosfwd>
#include <format>

namespace rt {
  enum class e_LogCategory {
    debug,
    info,
    err,
    warning,
    fatal
  };

  std::ostream& operator << (std::ostream& os, e_LogCategory cat);
}

#include "log_category.inl" // std::format specialization

#endif // RT_LOGGER_LOG_CATEGORY_H

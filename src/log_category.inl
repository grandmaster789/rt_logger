#ifndef RT_LOGGER_LOG_CATEGORY_INL
#define RT_LOGGER_LOG_CATEGORY_INL

#include "log_category.inl"

template <>
struct std::formatter<rt::e_LogCategory> {
  static constexpr auto parse(std::format_parse_context& ctx) {
    return ctx.begin();
  }

  static auto format(rt::e_LogCategory cat, std::format_context& ctx) {
    // progressively become more shouting when the category becomes more important
    // normal usage should be as unobtrusive as possible, with small highlights for
    // debug statements and warnings
    switch (cat) {
    case rt::e_LogCategory::debug:   return std::format_to(ctx.out(), "[dbg] ");
    case rt::e_LogCategory::info:    return std::format_to(ctx.out(), "      ");
    case rt::e_LogCategory::err:     return std::format_to(ctx.out(), "*wrn* ");

    case rt::e_LogCategory::warning: return std::format_to(ctx.out(), "< ERROR >     ");
    case rt::e_LogCategory::fatal:   return std::format_to(ctx.out(), "<## FATAL ##> ");
    default:                         return std::format_to(ctx.out(), "[UNKNOWN]     ");
    }
  }
};

#endif // RT_LOGGER_LOG_CATEGORY_INL
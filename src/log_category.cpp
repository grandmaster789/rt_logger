#include "log_category.h"

#include <ostream>

namespace rt {
  std::ostream& operator << (std::ostream& os, e_LogCategory cat) {
    switch (cat) {
      // progressively become more shouting when the category becomes more important
      // normal usage should be as unobtrusive as possible, with small highlights for
      // debug statements and warnings
      case rt::e_LogCategory::debug:   os << "[dbg] ";
      case rt::e_LogCategory::info:    os << "      ";
      case rt::e_LogCategory::err:     os << "*wrn* ";

      case rt::e_LogCategory::warning: os << "< ERROR >     ";
      case rt::e_LogCategory::fatal:   os << "<## FATAL ##> ";
      default:                         os << "[UNKNOWN]     ";
    }

    return os;
  }
}
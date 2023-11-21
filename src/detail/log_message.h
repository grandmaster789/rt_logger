#ifndef RT_LOGGER_LOG_MESSAGE_H
#define RT_LOGGER_LOG_MESSAGE_H

#include <sstream>
#include "../log_category.h"

namespace rt {
  class Logger;
  class LogSink;

  namespace detail {
    class LogMessage {
    private:
      friend class rt::Logger;
      friend class rt::LogSink;

      LogMessage() = default;

      void clear();

    public:
      LogMessage             (const LogMessage&) = delete;
      LogMessage& operator = (const LogMessage&) = delete;
      LogMessage             (LogMessage&&) noexcept;
      LogMessage& operator = (LogMessage&&) noexcept;

      ~LogMessage();

      // enable iostream-style appending of messages
      template <typename T>
      LogMessage& operator << (const T& value);

      // allow iostream manipulator functions to work on this
      LogMessage& operator << (std::ostream& (*fn)(std::ostream&));

      struct MetaInfo {

      };

    private:
      std::ostringstream m_Buffer;
      Logger*            m_Owner = nullptr;
      MetaInfo           m_MetaInfo;
    };
  }
}

#endif // RT_LOGGER_LOG_MESSAGE_H

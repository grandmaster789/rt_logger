#include "rt_logger.h"

#include <iostream>
#include <termcolor/termcolor.hpp>

namespace rt {
  int square(int value) {
    std::cout <<
        termcolor::yellow <<
        "Square(" << value << ") = " << (value * value) <<
        termcolor::reset << '\n';

    return value * value;
  }
}
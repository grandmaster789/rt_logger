#include "rt_logger.h"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("Dummy square test", "[dummy]") {
  REQUIRE(rt::square(7) == 49);
}

TEST_CASE("Basic stacktrace", "[dummy]") {
  rt::show_stacktrace();
}

/*int main() {
  rt::square(7);

  return 0;
}*/
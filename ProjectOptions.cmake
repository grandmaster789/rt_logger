include(cmake/SystemLink.cmake)
include(cmake/LibFuzzer.cmake)
include(CMakeDependentOption)
include(CheckCXXCompilerFlag)


macro(rt_logger_supports_sanitizers)
  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND NOT WIN32)
    set(SUPPORTS_UBSAN ON)
  else()
    set(SUPPORTS_UBSAN OFF)
  endif()

  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND WIN32)
    set(SUPPORTS_ASAN OFF)
  else()
    set(SUPPORTS_ASAN ON)
  endif()
endmacro()

macro(rt_logger_setup_options)
  option(rt_logger_ENABLE_HARDENING "Enable hardening" ON)
  option(rt_logger_ENABLE_COVERAGE "Enable coverage reporting" OFF)
  cmake_dependent_option(
    rt_logger_ENABLE_GLOBAL_HARDENING
    "Attempt to push hardening options to built dependencies"
    ON
    rt_logger_ENABLE_HARDENING
    OFF)

  rt_logger_supports_sanitizers()

  if(NOT PROJECT_IS_TOP_LEVEL OR rt_logger_PACKAGING_MAINTAINER_MODE)
    option(rt_logger_ENABLE_IPO "Enable IPO/LTO" OFF)
    option(rt_logger_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(rt_logger_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(rt_logger_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
    option(rt_logger_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(rt_logger_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
    option(rt_logger_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(rt_logger_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(rt_logger_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(rt_logger_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
    option(rt_logger_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(rt_logger_ENABLE_PCH "Enable precompiled headers" OFF)
    option(rt_logger_ENABLE_CACHE "Enable ccache" OFF)
  else()
    option(rt_logger_ENABLE_IPO "Enable IPO/LTO" ON)
    option(rt_logger_WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)
    option(rt_logger_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(rt_logger_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN})
    option(rt_logger_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(rt_logger_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN})
    option(rt_logger_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(rt_logger_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(rt_logger_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(rt_logger_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
    option(rt_logger_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
    option(rt_logger_ENABLE_PCH "Enable precompiled headers" OFF)
    option(rt_logger_ENABLE_CACHE "Enable ccache" ON)
  endif()

  if(NOT PROJECT_IS_TOP_LEVEL)
    mark_as_advanced(
      rt_logger_ENABLE_IPO
      rt_logger_WARNINGS_AS_ERRORS
      rt_logger_ENABLE_USER_LINKER
      rt_logger_ENABLE_SANITIZER_ADDRESS
      rt_logger_ENABLE_SANITIZER_LEAK
      rt_logger_ENABLE_SANITIZER_UNDEFINED
      rt_logger_ENABLE_SANITIZER_THREAD
      rt_logger_ENABLE_SANITIZER_MEMORY
      rt_logger_ENABLE_UNITY_BUILD
      rt_logger_ENABLE_CLANG_TIDY
      rt_logger_ENABLE_CPPCHECK
      rt_logger_ENABLE_COVERAGE
      rt_logger_ENABLE_PCH
      rt_logger_ENABLE_CACHE)
  endif()

  rt_logger_check_libfuzzer_support(LIBFUZZER_SUPPORTED)
  if(LIBFUZZER_SUPPORTED AND (rt_logger_ENABLE_SANITIZER_ADDRESS OR rt_logger_ENABLE_SANITIZER_THREAD OR rt_logger_ENABLE_SANITIZER_UNDEFINED))
    set(DEFAULT_FUZZER ON)
  else()
    set(DEFAULT_FUZZER OFF)
  endif()

  option(rt_logger_BUILD_FUZZ_TESTS "Enable fuzz testing executable" ${DEFAULT_FUZZER})

endmacro()

macro(rt_logger_global_options)
  if(rt_logger_ENABLE_IPO)
    include(cmake/InterproceduralOptimization.cmake)
    rt_logger_enable_ipo()
  endif()

  rt_logger_supports_sanitizers()

  if(rt_logger_ENABLE_HARDENING AND rt_logger_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR rt_logger_ENABLE_SANITIZER_UNDEFINED
       OR rt_logger_ENABLE_SANITIZER_ADDRESS
       OR rt_logger_ENABLE_SANITIZER_THREAD
       OR rt_logger_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    message("${rt_logger_ENABLE_HARDENING} ${ENABLE_UBSAN_MINIMAL_RUNTIME} ${rt_logger_ENABLE_SANITIZER_UNDEFINED}")
    rt_logger_enable_hardening(rt_logger_options ON ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()
endmacro()

macro(rt_logger_local_options)
  if(PROJECT_IS_TOP_LEVEL)
    include(cmake/StandardProjectSettings.cmake)
  endif()

  add_library(rt_logger_warnings INTERFACE)
  add_library(rt_logger_options INTERFACE)

  include(cmake/CompilerWarnings.cmake)
  rt_logger_set_project_warnings(
    rt_logger_warnings
    ${rt_logger_WARNINGS_AS_ERRORS}
    ""
    ""
    ""
    "")

  if(rt_logger_ENABLE_USER_LINKER)
    include(cmake/Linker.cmake)
    configure_linker(rt_logger_options)
  endif()

  include(cmake/Sanitizers.cmake)
  rt_logger_enable_sanitizers(
    rt_logger_options
    ${rt_logger_ENABLE_SANITIZER_ADDRESS}
    ${rt_logger_ENABLE_SANITIZER_LEAK}
    ${rt_logger_ENABLE_SANITIZER_UNDEFINED}
    ${rt_logger_ENABLE_SANITIZER_THREAD}
    ${rt_logger_ENABLE_SANITIZER_MEMORY})

  set_target_properties(rt_logger_options PROPERTIES UNITY_BUILD ${rt_logger_ENABLE_UNITY_BUILD})

  if(rt_logger_ENABLE_PCH)
    target_precompile_headers(
      rt_logger_options
      INTERFACE
      <vector>
      <string>
      <utility>)
  endif()

  if(rt_logger_ENABLE_CACHE)
    include(cmake/Cache.cmake)
    rt_logger_enable_cache()
  endif()

  include(cmake/StaticAnalyzers.cmake)
  if(rt_logger_ENABLE_CLANG_TIDY)
    rt_logger_enable_clang_tidy(rt_logger_options ${rt_logger_WARNINGS_AS_ERRORS})
  endif()

  if(rt_logger_ENABLE_CPPCHECK)
    rt_logger_enable_cppcheck(${rt_logger_WARNINGS_AS_ERRORS} "" # override cppcheck options
    )
  endif()

  if(rt_logger_ENABLE_COVERAGE)
    include(cmake/Tests.cmake)
    rt_logger_enable_coverage(rt_logger_options)
  endif()

  if(rt_logger_WARNINGS_AS_ERRORS)
    check_cxx_compiler_flag("-Wl,--fatal-warnings" LINKER_FATAL_WARNINGS)
    if(LINKER_FATAL_WARNINGS)
      # This is not working consistently, so disabling for now
      # target_link_options(rt_logger_options INTERFACE -Wl,--fatal-warnings)
    endif()
  endif()

  if(rt_logger_ENABLE_HARDENING AND NOT rt_logger_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR rt_logger_ENABLE_SANITIZER_UNDEFINED
       OR rt_logger_ENABLE_SANITIZER_ADDRESS
       OR rt_logger_ENABLE_SANITIZER_THREAD
       OR rt_logger_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    rt_logger_enable_hardening(rt_logger_options OFF ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()

endmacro()

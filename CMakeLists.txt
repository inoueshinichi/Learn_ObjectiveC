cmake_minimum_required(VERSION 3.16.0) # Objective-C(++) >= CMake 3.16.0

# CMake version
message(STATUS "CMake Verion: ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}.${CMAKE_TWEAK_VERSION}")


###############################################################################
# Policy
###############################################################################

# <= CMake3.*.*でAppleClangをコンパイラIDとして認識させる
# Report AppleClang separately from Clang. Their version numbers are different.
# https://cmake.org/cmake/help/v3.0/policy/CMP0025.html
if(POLICY CMP0025)
  cmake_policy(SET CMP0025 NEW)
endif()

if (POLICY CMP0115)
 cmake_policy(SET CMP0115 NEW) # explicit source symbol
endif()

###############################################################################
# Host PC Info
###############################################################################

# Host
message(STATUS "Host OS: ${CMAKE_HOST_SYSTEM_NAME}")
message(STATUS "Host OS Version: ${CMAKE_HOST_SYSTEM_VERSION}")
message(STATUS "Host System Processor: ${CMAKE_HOST_SYSTEM_PROCESSOR}")

# Architecture Name
set(HOST_ARCH "")
if (UNIX)
    execute_process(COMMAND uname -m OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE HOST_ARCH) # OUTPUT_STRIP_TRAILING_WHITESPACE : 改行を省く
    if(${HOST_ARCH} STREQUAL "")
        execute_process(COMMAND uname -p OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE HOST_ARCH)
    endif()
    if(${HOST_ARCH} STREQUAL "")
        message(FATAL_ERROR "Not found architecture symbol in Unix.")
    endif()
else() # Windows
    set(HOST_ARCH $ENV{PROCESSOR_ARCHITECTURE})
    if(${HOST_ARCH} STREQUAL "")
        message(FATAL_ERROR "Not found architecture symbol in Windows.")
    endif()
endif()

message(STATUS "Host Architecture: ${HOST_ARCH}")

if (NOT UNIX)
    message(FATAL_ERROR "You must perform compiling objective-c(++) on Apple or Linux platform.")
endif()

# System version
if (LINUX)
    message(STATUS "Platform: Linux ${CMAKE_SYSTEM_VERSION}")
elseif(APPLE)
    message(STATUS "Platform: macOS ${CMAKE_SYSTEM_VERSION}")
endif()

# Only Apple for apple silicon(arm64) M*
if(APPLE)
    set(OSX_ARCHITECTURE "")
    if(${HOST_ARCH} MATCHES "arm64")
        list(APPEND OSX_ARCHITECTURE "AppleSilicon")
    elseif(${HOST_ARCH} MATCHES "x86_64")
        list(APPEND OSX_ARCHITECTURE "Intel(Rosetta2)")
    else()
        message(FATAL_ERROR "Not match architecture. Arch must arm64 or x86_64 in macOS. Given is ${ARCH}")
    endif()
    message(STATUS "Your macOS cpu architecture is ${HOST_ARCH} ${OSX_ARCHITECTURE}!")
endif()
message(STATUS "Host arch: ${HOST_ARCH}")
message(STATUS "CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}") # コンパイル対象のプロセッサ
message(STATUS "CMAKE_HOST_SYSTEM_PROCESSOR: ${CMAKE_HOST_SYSTEM_PROCESSOR}") # 実行しているプロセッサ

# Generator
# https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html
set(HOST_GENERATOR ${CMAKE_GENERATOR})
message(STATUS "Generator: ${CMAKE_GENERATOR}")


###############################################################################
# Target PC Info
###############################################################################
# Target
message(STATUS "Target OS: ${CMAKE_SYSTEM_NAME}")
message(STATUS "Target OS Version: ${CMAKE_SYSTEM_VERSION}")
message(STATUS "Target System Processor: ${CMAKE_SYSTEM_PROCESSOR}")

###############################################################################
# Top-level Project Name
###############################################################################
project(LearnObjectiveC LANGUAGES OBJC OBJCXX C CXX VERSION 0.1.0)

# Enable Objective-C, Objective-C++
enable_language(OBJC)
enable_language(OBJCXX)


###############################################################################
# Subdirectory
###############################################################################
add_subdirectory(HelloWorld)
# add_subdirectory(SimpleGui)
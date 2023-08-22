cmake_minimum_required(VERSION 3.16.0) # Objective-C(++) >= CMake 3.16.0

include(../is_objcxx_test_case.cmake)

# CMakeの場合, ${CMAKE_ROOT}/Modules/MacOSXBundleInfo.plist.inに
# info.plistのテンプレートがあるので, これをコピーして使用する.

# MacOSXBundleInfo.plistのテンプレート
# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
# <dict>
#     <key>CFBundleDevelopmentRegion</key>
#     <string>English</string>
#     <key>CFBundleExecutable</key>
#     <string>${MACOSX_BUNDLE_EXECUTABLE_NAME}</string>
#     <key>CFBundleGetInfoString</key>
#     <string>${MACOSX_BUNDLE_INFO_STRING}</string>
#     <key>CFBundleIconFile</key>
#     <string>${MACOSX_BUNDLE_ICON_FILE}</string>
#     <key>CFBundleIdentifier</key>
#     <string>${MACOSX_BUNDLE_GUI_IDENTIFIER}</string>
#     <key>CFBundleInfoDictionaryVersion</key>
#     <string>6.0</string>
#     <key>CFBundleLongVersionString</key>
#     <string>${MACOSX_BUNDLE_LONG_VERSION_STRING}</string>
#     <key>CFBundleName</key>
#     <string>${MACOSX_BUNDLE_BUNDLE_NAME}</string>
#     <key>CFBundlePackageType</key>
#     <string>APPL</string>
#     <key>CFBundleShortVersionString</key>
#     <string>${MACOSX_BUNDLE_SHORT_VERSION_STRING}</string>
#     <key>CFBundleSignature</key>
#     <string>????</string>
#     <key>CFBundleVersion</key>
#     <string>${MACOSX_BUNDLE_BUNDLE_VERSION}</string>
#     <key>CSResourcesFileMapped</key>
#     <true/>
#     <key>LSRequiresCarbon</key>
#     <true/>
#     <key>NSHumanReadableCopyright</key>
#     <string>${MACOSX_BUNDLE_COPYRIGHT}</string>
# </dict>
# </plist>
file(COPY ${CMAKE_ROOT}/Modules/MacOSXBundleInfo.plist.in DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})

get_filename_component(DIRNAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
set(APP_VERSION 1.0)

# info.plistの変数を設定
set(MACOSX_BUNDLE_EXECUTABLE_NAME ${DIRNAME}) # CFBundleExecutable
set(MACOSX_BUNDLE_INFO_STRING ${DIRNAME}) # CFBundleGetInfoString
set(MACOSX_BUNDLE_ICON_FILE "") # CFBundleIconFile
set(MACOSX_BUNDLE_GUI_IDENTIFIER "com.shinichi.inoue.${DIRNAME}") # CFBundleIdentifier
set(MACOSX_BUNDLE_LONG_VERSION_STRING "${DIRENAME} Version ${APP_VERSION}") # CFBundleLongVersionString
set(MACOSX_BUNDLE_BUNDLE_NAME ${DIRNAME}) # CFBundleName
set(MACOSX_BUNDLE_SHORT_VERSION_STRING ${APP_VERSION}) # CFBundleShortVersionString
set(MACOSX_BUNDLE_BUNDLE_VERSION ${APP_VERSION}) # CFBundleVersion
set(MACOSX_BUNDLE_COPYRIGHT "Copyright 2023.") # NSHumanReadableCopyright

# 設定を更新してカレントフォルタのinfo.plistに設定する.
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/MacOSXBundleInfo.plist.in 
               ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist NEWLINE_STYLE LF) # Unix

set(BUILD_HEADERS "")
set(BUILD_SOURCES "")

# Objective-C
file(GLOB BUILD_OBJC_HEADERS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ./*.h)
file(GLOB BUILD_OBJC_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ./*.m)
list(APPEND BUILD_HEADERS ${BUILD_OBJC_HEADERS})
list(APPEND BUILD_SOURCES ${BUILD_OBJC_SOURCES})

# Objective-C++
file(GLOB BUILD_OBJCXX_HEADERS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ./*.h)
file(GLOB BUILD_OBJCXX_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ./*.mm)
list(APPEND BUILD_HEADERS ${BUILD_OBJCXX_HEADERS})
list(APPEND BUILD_SOURCES ${BUILD_OBJCXX_SOURCES})

# C++
file(GLOB BUILD_CXX_HEADERS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ./*.hpp)
file(GLOB BUILD_CXX_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ./*.cpp)
list(APPEND BUILD_HEADERS ${BUILD_CXX_HEADERS})
list(APPEND BUILD_SOURCES ${BUILD_CXX_SOURCES})

message(STATUS "BUILD_HEADERS: ${BUILD_HEADERS}")
message(STATUS "BUILD_SOURCES: ${BUILD_SOURCES}")

set(STORYBOARD_XIB "")
set(STORYBOARD_NIB "")

# ${BUILD_HEADERS} ${BUILD_SOURCES} ${STORYBOARD_XIB} ${STORYBOARD_NIB} ${APPLE_BUNDLE_PLIST} ${BUILD_EXE_SOURCE}
is_objcxx_test_case("${BUILD_HEADERS}" "${BUILD_SOURCES}" "${STORYBOARD_XIB}" "${STORYBOARD_NIB}" ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist main_wrap_cpp.m)
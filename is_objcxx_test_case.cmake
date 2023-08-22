cmake_minimum_required(VERSION 3.16.0) # Objective-C(++) >= CMake 3.16.0

function(is_objcxx_test_case BUILD_HEADERS BUILD_SOURCES STORYBOARD_XIB STORYBOARD_NIB APPLE_BUNDLE_PLIST BUILD_EXE_SOURCE)

    # Target
    get_filename_component(BUILD_TARGET ${BUILD_EXE_SOURCE} NAME_WE)

    # Project (Objective-C, Objective-CXX)
    project(${BUILD_TARGET} LANGUAGES OBJC OBJCXX C CXX VERSION 0.1.0)

    # Exe
    if(APPLE)
        add_executable(${BUILD_TARGET} MACOSX_BUNDLE ${BUILD_EXE_SOURCE} ${STORYBOARD_XIB} ${STORYBOARD_NIB})
    else() # Linux
        add_executable(${$BUILD_TARGET} ${BUILD_EXE_SOURCE} ${STORYBOARD_XIB} ${STORYBOARD_NIB})
    endif()

    # storyboard xib
    if(${STORYBOARD_XIB})
        set_source_files_properties(${STORYBOARD_XIB} PROPERTIES
            MACOSX_PACKAGE_LOCATION Resources
        )
    endif()

    # storyboard nib
    if (${STORYBOARD_NIB})
        set_source_files_properties(${SOTRYBOARD_NIB} PROPERTIES
            MACOSX_PACKAGE_LOCATION Resources
        )
    endif()

    # Headers & Sources
    target_sources(${BUILD_TARGET} PRIVATE ${BUILD_HEADERS} PRIVATE ${BUILD_SOURCES})

    # Include Directory
    target_include_directories(${BUILD_TARGET} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    target_include_directories(${BUILD_TARGET} PRIVATE ${CMAKE_SOURCE_DIR}) # Top level layer

    # Apple frameworks
    # find_library(FOUNDATION Foundation)
    # find_library(COCOA Cocoa)
    # find_library(APPKIT Appkit)
    # find_library(COREDATA CoreData)
    # target_link_libraries(${BUILD_TARGET}
    #     ${FOUNDATION}
    #     ${COCOA}
    #     ${APPKIT}
    #     ${COREDATA}
    # )
    target_link_libraries(${BUILD_TARGET}
        "-framework Foundation"
        "-framework Cocoa"
        "-framework AppKit"
        "-framework CoreData"
    )

    # Apple PLIST
    message(STATUS "APPLE_BUNDLE_PLIST: ${APPLE_BUNDLE_PLIST}")
    if(${APPLE_BUNDLE_PLIST} MATCHES "^.*\.plist$")
        set_target_properties(${BUILD_TARGET} PROPERTIES
            MACOSX_BUNDLE_INFO_PLIST ${APPLE_BUNDLE_PLIST})
    else()
        message(FATAL_ERROR "You must include info.plist for apple application program.")
    endif()

    # Library postfix
    set(CMAKE_RELEASE_POSTFIX "")
    set(CMAKE_DEBUG_POSTFIX d)
    set(CMAKE_MINSIZEREL_POSTFIX s)
    set(CMAKE_RELWITHDEBINFO_POSTFIX rd)

    # Policy
    if(POLICY CMP0025)
        cmake_policy(SET CMP0025 NEW) # AppleClang
    endif()

    if(POLICY CMP0115)
        cmake_policy(SET CMP0115 NEW) # explicit source symbol
    endif()

    ################# 
    # Configuration #
    #################
    # Difinitions
    target_compile_definitions(${BUILD_TARGET} PRIVATE
        # GNU, Clang, AppleClang for C
        $<$<AND:$<OR:$<C_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>>,$<OR:$<CONFIG:Release>,$<CONFIG:MinSizeRel>>>:NDEBUG>
        # GNU, Clang, AppleClang for CXX
        $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>,$<OR:$<CONFIG:Release>,$<CONFIG:MinSizeRel>>>:NDEBUG>
        # GNU, Clang, AppleClang for OBJC
        $<$<AND:$<OR:$<OBJC_COMPILER_ID:GNU>,$<OBJC_COMPILER_ID:Clang>,$<OBJC_COMPILER_ID:AppleClang>>,$<OR:$<CONFIG:Release>,$<CONFIG:MinSizeRel>>>:NDEBUG>
        # GNU, Clang, AppleClang for OBJCXX
        $<$<AND:$<OR:$<OBJCXX_COMPILER_ID:GNU>,$<OBJCXX_COMPILER_ID:Clang>,$<OBJCXX_COMPILER_ID:AppleClang>>,$<OR:$<CONFIG:Release>,$<CONFIG:MinSizeRel>>>:NDEBUG>
    )

    # Features
    target_compile_features(${BUILD_TARGET} PRIVATE 
        cxx_std_20 # C++20
    )
    set_property(TARGET ${BUILD_TARGET} PROPERTY OBJCXX_STANDARD 20) # Objective-C++ 20

    # Options
    target_compile_options(${BUILD_TARGET} PRIVATE
        # GNU, Clang, AppleClang for C
        $<$<OR:$<C_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>>:-Wall>
        $<$<AND:$<OR:$<C_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>>,$<CONFIG:Release>>:-O3>
        $<$<AND:$<OR:$<C_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>>,$<CONFIG:Debug>>:-O0 -g>
        $<$<AND:$<OR:$<C_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>>,$<CONFIG:MinSizeRel>>:-Os>
        $<$<AND:$<OR:$<C_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>>,$<CONFIG:RelWithDebgInfo>>:-O2 -g>

        # GNU, Clang, AppleClang for CXX
        $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>:-Wall>
        $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>,$<CONFIG:Release>>:-O3>
        $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>,$<CONFIG:Debug>>:-O0 -g>
        $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>,$<CONFIG:MinSizeRel>>:-Os>
        $<$<AND:$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>,$<CONFIG:RelWithDebgInfo>>:-O2 -g>

        # GNU, Clang, AppleClang for OBJC
        $<$<OR:$<OBJC_COMPILER_ID:GNU>,$<OBJC_COMPILER_ID:Clang>,$<OBJC_COMPILER_ID:AppleClang>>:-Wall>
        $<$<AND:$<OR:$<OBJC_COMPILER_ID:GNU>,$<OBJC_COMPILER_ID:Clang>,$<OBJC_COMPILER_ID:AppleClang>>,$<CONFIG:Release>>:-O3>
        $<$<AND:$<OR:$<OBJC_COMPILER_ID:GNU>,$<OBJC_COMPILER_ID:Clang>,$<OBJC_COMPILER_ID:AppleClang>>,$<CONFIG:Debug>>:-O0 -g>
        $<$<AND:$<OR:$<OBJC_COMPILER_ID:GNU>,$<OBJC_COMPILER_ID:Clang>,$<OBJC_COMPILER_ID:AppleClang>>,$<CONFIG:MinSizeRel>>:-Os>
        $<$<AND:$<OR:$<OBJC_COMPILER_ID:GNU>,$<OBJC_COMPILER_ID:Clang>,$<OBJC_COMPILER_ID:AppleClang>>,$<CONFIG:RelWithDebgInfo>>:-O2 -g>

        # GNU, Clang, AppleClang for OBJCXX
        $<$<OR:$<OBJCXX_COMPILER_ID:GNU>,$<OBJCXX_COMPILER_ID:Clang>,$<OBJCXX_COMPILER_ID:AppleClang>>:-Wall>
        $<$<AND:$<OR:$<OBJCXX_COMPILER_ID:GNU>,$<OBJCXX_COMPILER_ID:Clang>,$<OBJCXX_COMPILER_ID:AppleClang>>,$<CONFIG:Release>>:-O3>
        $<$<AND:$<OR:$<OBJCXX_COMPILER_ID:GNU>,$<OBJCXX_COMPILER_ID:Clang>,$<OBJCXX_COMPILER_ID:AppleClang>>,$<CONFIG:Debug>>:-O0 -g>
        $<$<AND:$<OR:$<OBJCXX_COMPILER_ID:GNU>,$<OBJCXX_COMPILER_ID:Clang>,$<OBJCXX_COMPILER_ID:AppleClang>>,$<CONFIG:MinSizeRel>>:-Os>
        $<$<AND:$<OR:$<OBJCXX_COMPILER_ID:GNU>,$<OBJCXX_COMPILER_ID:Clang>,$<OBJCXX_COMPILER_ID:AppleClang>>,$<CONFIG:RelWithDebgInfo>>:-O2 -g>
    )

    # Options for Suppression of Warning
    target_compile_options(${BUILD_TARGET} PRIVATE
        # GNU C
        $<$<C_COMPILER_ID:GNU>: >
        # GNU CXX
        $<$<CXX_COMPILER_ID:GNU>: >
        # Clang or AppleClang C
        $<$<OR:$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>>: >
        # Clang or AppleClang CXX
        $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>: >
    )

    # Output Preprocessor(*.ii) & Assembler(*.s)
    if(ON)
        # message(STATUS "Output preprocessed files....")
        target_compile_options(${BUILD_TARGET} PRIVATE
            # GNU, Clang, AppleClang for C
            $<$<C_COMPILER_ID:GNU>:-save-temps=obj>
            $<$<C_COMPILER_ID:Clang>:-save-temps=obj>
            $<$<C_COMPILER_ID:AppleClang>:-save-temps=obj>

            # GNU, Clang, AppleClang for CXX
            $<$<CXX_COMPILER_ID:GNU>:-save-temps=obj>
            $<$<CXX_COMPILER_ID:Clang>:-save-temps=obj>
            $<$<CXX_COMPILER_ID:AppleClang>:-save-temps=obj>

            # GNU, Clang, AppleClang for OBJC
            $<$<OBJC_COMPILER_ID:GNU>:-save-temps=obj>
            $<$<OBJC_COMPILER_ID:Clang>:-save-temps=obj>
            $<$<OBJC_COMPILER_ID:AppleClang>:-save-temps=obj>

            # GNU, Clang, AppleClang for OBJCXX
            $<$<OBJCXX_COMPILER_ID:GNU>:-save-temps=obj>
            $<$<OBJCXX_COMPILER_ID:Clang>:-save-temps=obj>
            $<$<OBJCXX_COMPILER_ID:AppleClang>:-save-temps=obj>
        )
    endif()

    # OpenMP
    if(ON)
        if(NOT APPLE)
            find_package(OpenMP REQUIRED)
            target_compile_options(${BUILD_TARGET} PRIVATE
                # GNU FOR C, CXX
                $<$<OR:$<C_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>>:-fopenmp>
                $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:-fopenmp>
                # GNU FOR OBJC, OBJCXX
                $<$<OR:$<OBJC_COMPILER_ID:GNU>,$<OBJC_COMPILER_ID:Clang>>:-fopenmp>
                $<$<OR:$<OBJCXX_COMPILER_ID:GNU>,$<OBJCXX_COMPILER_ID:Clang>>:-fopenmp>
            )
        else()
            # macOSのOpenMPはGeneratorExpressionに対応していないバグがある.
            # macOSのAppleClangの場合CMakeのfildpakageスクリプトの動作にバグがありそうなので, Homebrewでインストールして直接指定.
            # https://zv-louis.hatenablog.com/entry/2018/12/23/141327
            execute_process(COMMAND brew --prefix libomp OUTPUT_VARIABLE OPENMP_HOME OUTPUT_STRIP_TRAILING_WHITESPACE)
            if(${OPENMP_HOME} STREQUAL "")
                message(FATAL_ERROR "Not found OpenMP. Please `brew install libomp`")
            endif()
            # message(STATUS "OpenMP root path: ${OPENMP_HOME}") # 非表示
            set(OpenMP_INCLUDE_DIRS "${OpenMP_HOME}/include/")
            set(OpenMP_LIBRARY "${OpenMP_HOME}/lib/")
            # C, CXX
            set(OpenMP_C_LIB_NAMES "libomp")
            set(OpenMP_CXX_LIB_NAMES "libomp")
            # OBJC, OBJCXX
            set(OpenMP_OBJC_LIB_NAMES "libomp")
            set(OpenMP_OBJCXX_LIB_NAMES "libomp")
            target_compile_options(${BUILD_TARGET} PRIVATE
                # AppleClang for C, CXX
                $<$<C_COMPILER_ID:AppleClang>:-Xpreprocessor -fopenmp> # AppleClang with XCode
                $<$<CXX_COMPILER_ID:AppleClang>:-Xpreprocessor -fopenmp> # AppleClang with XCode
                # AppleClang for OBJC, OBJCXX
                $<$<OBJC_COMPILER_ID:AppleClang>:-Xpreprocessor -fopenmp> # AppleClang with XCode
                $<$<OBJCXX_COMPILER_ID:AppleClang>:-Xpreprocessor -fopenmp> # AppleClang with XCode
            )
        endif()
        target_include_directories(${BUILD_TARGET} PRIVATE ${OpenMP_INCLUDE_DIRS})
        target_link_directories(${BUILD_TARGET} PRIVATE ${OpenMP_LIBRARY})
        target_link_libraries(${BUILD_TARGET} PRIVATE ${OpenMP_LIBRARIES})
    endif()

    ##############
    # Properties #
    ##############
    if(UNIX OR APPLE)
        # Makefileの詳細情報を出力
        set(CMAKE_VERBOSE_MAKEFILE ON)
    endif()

    

endfunction()
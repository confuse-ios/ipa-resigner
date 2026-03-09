cmake_minimum_required(VERSION 3.16)

project(BundleSpyDylib VERSION 1.3 LANGUAGES C OBJCXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(FISHHOOK_DIR "${CMAKE_SOURCE_DIR}/../fishhook")

set(DYLIB_SOURCES
    BundleSpyDylib.mm
    BundleSpyDylib.h
    ${FISHHOOK_DIR}/fishhook.c
    ${FISHHOOK_DIR}/fishhook.h
)

add_library(BundleSpyDylib SHARED ${DYLIB_SOURCES})

target_include_directories(BundleSpyDylib PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${FISHHOOK_DIR}
)

if(APPLE)
    # 为 iOS 平台构建
    if(IOS)
        set_target_properties(BundleSpyDylib PROPERTIES
            PREFIX ""
            SUFFIX ".dylib"
            FRAMEWORK FALSE
            MACOSX_BUNDLE FALSE
            XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2"  # iPhone and iPad
            XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "13.0"
        )
        
        target_compile_options(BundleSpyDylib PRIVATE
            -fvisibility=hidden
            -dynamiclib
            -flat_namespace
            -undefined suppress
            -arch arm64
        )
    else()
        # 为 macOS 平台构建
        set_target_properties(BundleSpyDylib PROPERTIES
            PREFIX ""
            SUFFIX ".dylib"
            FRAMEWORK FALSE
            MACOSX_BUNDLE FALSE
        )
        
        target_compile_options(BundleSpyDylib PRIVATE
            -fvisibility=hidden
            -dynamiclib
            -flat_namespace
            -undefined suppress
        )
    endif()
    
    target_link_libraries(BundleSpyDylib PRIVATE
        "-framework Foundation"
        "-framework CoreFoundation"
    )
endif()

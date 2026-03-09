#!/bin/bash

# 为 iOS 平台构建 BundleSpyDylib
echo "Building BundleSpyDylib for iOS..."

# 确保在正确的目录中
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 清理旧的构建目录
rm -rf build_ios
mkdir -p build_ios
cd build_ios

# 使用 iOS 工具链构建
cmake .. -G "Xcode" -DCMAKE_TOOLCHAIN_FILE="/Applications/Xcode16.3.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/CMake/ios.toolchain.cmake" -DPLATFORM=OS64 -DARCHS="arm64"

if [ $? -eq 0 ]; then
    echo "CMake configuration successful"
    # 构建项目
    xcodebuild -project BundleSpyDylib.xcodeproj -target BundleSpyDylib -configuration Release -sdk iphoneos
    
    if [ $? -eq 0 ]; then
        echo "Build successful!"
        echo "iOS dylib created at: build_ios/Release-iphoneos/BundleSpyDylib.dylib"
    else
        echo "Build failed"
    fi
else
    echo "CMake configuration failed"
fi

cd ..
echo "Build process completed"

#!/bin/bash

# 为 iOS 平台构建 BundleSpyDylib
echo "Building BundleSpyDylib for iOS using clang..."

# 确保在正确的目录中
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 清理旧的构建产物
rm -f BundleSpyDylib.dylib

# 获取 iOS SDK 路径
IOS_SDK_PATH=$(xcrun --sdk iphoneos --show-sdk-path)

if [ -z "$IOS_SDK_PATH" ]; then
    echo "Error: iOS SDK not found"
    exit 1
fi

echo "Using iOS SDK path: $IOS_SDK_PATH"

# fishhook 目录
FISHHOOK_DIR="$SCRIPT_DIR/../fishhook"

# 构建 dylib（使用 fishhook）
clang -dynamiclib \
    -arch arm64 \
    -isysroot "$IOS_SDK_PATH" \
    -miphoneos-version-min=13.0 \
    -I"$FISHHOOK_DIR" \
    -framework Foundation \
    -framework CoreFoundation \
    -o BundleSpyDylib.dylib \
    BundleSpyDylib.mm \
    "$FISHHOOK_DIR/fishhook.c"

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "iOS dylib created at: $SCRIPT_DIR/BundleSpyDylib.dylib"
    
    # 验证构建产物
    file BundleSpyDylib.dylib
    lipo -info BundleSpyDylib.dylib
    
    # 检查符号
    echo ""
    echo "Checking symbols:"
    nm -g BundleSpyDylib.dylib | head -20
else
    echo "Build failed"
fi

echo "Build process completed"

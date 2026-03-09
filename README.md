# IPA Resigner Tool

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS-orange.svg)]()
[![Qt](https://img.shields.io/badge/Qt-6.10-green.svg)]()

A powerful macOS-based IPA resigning tool built with Qt, supporting certificate management, configuration management, and dynamic library injection.

## Features

- **Certificate Management**: View and manage iOS signing certificates
- **Configuration Profiles**: Save and manage multiple signing configurations
- **Dynamic Library Injection**: Inject custom dylib into IPA packages
- **Multi-language Support**: Chinese and English interface (auto-detects system language)

## Download

Download the latest release from the [Releases](https://github.com/confuse-ios/ipa-resigner/releases) page:

- `小蟹iOS-重签名工具.zip` - Compressed package

## Installation

1. Download and extract the ZIP file
2. Double-click the DMG file
3. Drag the app to the Applications folder
4. Launch from Launchpad or Applications

## Usage

### 1. Configure Signing

1. Click "签名配置" (Signing Config) button
2. Click "添加" (Add) to create a new configuration
3. Select your certificate and provisioning profile
4. Click "保存" (Save)

### 2. Select IPA File

1. Click "选择IPA文件" (Select IPA File)
2. Choose the IPA file to resign
3. The app will automatically analyze IPA information

### 3. Start Resigning

1. Select a signing configuration
2. Optionally enable dynamic library injection
3. Click "开始重签名" (Start Resigning)
4. Wait for the process to complete

## System Requirements

- macOS 10.15 or later
- Xcode command line tools (for code signing)

## Troubleshooting

### App Cannot Open

If you see "Cannot verify developer" message:
1. Go to System Settings > Privacy & Security
2. Click "Open Anyway"
3. Try opening the app again

### Certificate Selection Failed

- Ensure certificates are installed in Keychain
- Make sure the certificate is not expired
- Check certificate permissions

## Language

The app automatically detects your system language:
- If your system is in Chinese, the interface will be in Chinese
- Otherwise, the interface will be in English

---

For Chinese documentation, please see: [README_zh_CN.md](README_zh_CN.md)

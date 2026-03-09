# 小蟹iOS-重签名工具使用教程
# Usage Guide for 小蟹iOS-Resigner Tool

## 简介 / Introduction

小蟹iOS-重签名工具是一款基于 Qt 开发的 IPA 重签名工具，支持证书管理、配置管理和动态库注入等功能。

The 小蟹iOS-Resigner Tool is a Qt-based IPA resigning tool that supports certificate management, configuration management, and dynamic library injection.

## 下载与安装 / Download and Installation

### 使用 DMG 安装包 / Method 1: Using DMG Installer

1. 从 GitHub 仓库下载 `小蟹iOS-重签名工具.zip` 文件
2. 解压 ZIP 文件，得到 `小蟹iOS-重签名工具.dmg`
3. 双击 DMG 文件，将应用拖到 Applications 文件夹
4. 在 Launchpad 或 Applications 文件夹中找到并打开应用

1. Download the `小蟹iOS-重签名工具.zip` file from the GitHub repository
2. Extract the ZIP file to get `小蟹iOS-重签名工具.dmg`
3. Double-click the DMG file and drag the app to the Applications folder
4. Find and open the app in Launchpad or Applications folder

## 使用方法 / Usage

### 1. 配置签名信息 / 1. Configure Signing Information

1. 点击「签名配置」按钮
2. 点击「添加」按钮创建新的签名配置
3. 填写配置名称
4. 选择证书（可点击浏览按钮查看所有有效证书）
5. 选择 provisioning profile
6. 点击「保存」按钮

1. Click the "签名配置" (Signing Config) button
2. Click the "添加" (Add) button to create a new signing configuration
3. Enter a configuration name
4. Select a certificate (click the browse button to view all valid certificates)
5. Select a provisioning profile
6. Click the "保存" (Save) button

### 2. 选择 IPA 文件 / 2. Select IPA File

1. 点击「选择 IPA」按钮
2. 在文件选择对话框中选择要重签名的 IPA 文件
3. 应用会自动分析 IPA 信息

1. Click the "选择 IPA" (Select IPA) button
2. Select the IPA file to resign in the file selection dialog
3. The app will automatically analyze the IPA information

### 3. 选择签名配置 / 3. Select Signing Configuration

1. 在「签名配置」下拉菜单中选择一个配置
2. 可以点击「刷新」按钮更新可用的签名配置

1. Select a configuration from the "签名配置" (Signing Configuration) dropdown menu
2. Click the "刷新" (Refresh) button to update available signing configurations

### 4. 可选：动态库注入 / 4. Optional: Dynamic Library Injection

1. 勾选「动态库注入」选项
2. 点击「选择 dylib」按钮选择要注入的动态库
3. 选择注入方法（BundleSpyDylib 或 自定义 dylib）

1. Check the "动态库注入" (Dynamic Library Injection) option
2. Click the "选择 dylib" (Select dylib) button to select the dynamic library to inject
3. Select the injection method (BundleSpyDylib or Custom dylib)

### 5. 开始重签名 / 5. Start Resigning

1. 点击「开始」按钮
2. 等待重签名过程完成
3. 完成后会显示保存位置

1. Click the "开始" (Start) button
2. Wait for the resigning process to complete
3. The save location will be displayed upon completion

## 常见问题 / Common Issues

### 1. 应用无法打开 / 1. App Cannot Open

- **问题**：首次运行时出现 "无法打开应用，因为开发者无法验证" 的提示
- **解决方案**：
  1. 进入「系统设置 > 隐私与安全性」
  2. 找到并点击「仍要打开」按钮
  3. 再次尝试打开应用

- **Issue**: "Cannot open app because the developer cannot be verified" message when first running
- **Solution**:
  1. Go to "System Settings > Privacy & Security"
  2. Find and click the "Open Anyway" button
  3. Try opening the app again

### 2. 证书选择失败 / 2. Certificate Selection Failure

- **问题**：无法选择证书或证书显示为灰色
- **解决方案**：
  1. 确保证书已安装在钥匙串中
  2. 确保证书未过期（过期证书不会显示）
  3. 检查证书权限是否正确

- **Issue**: Cannot select certificate or certificate appears grayed out
- **Solution**:
  1. Ensure the certificate is installed in Keychain
  2. Ensure the certificate is not expired (expired certificates won't be displayed)
  3. Check if the certificate permissions are correct

### 3. 重签名失败 / 3. Resigning Failure

- **问题**：重签名过程中出现错误
- **解决方案**：
  1. 检查 IPA 文件是否损坏
  2. 确保签名配置正确（证书和 provisioning profile 匹配）
  3. 检查网络连接（某些情况下需要验证证书）
  4. 查看日志输出了解具体错误信息

- **Issue**: Error during resigning process
- **Solution**:
  1. Check if the IPA file is corrupted
  2. Ensure the signing configuration is correct (certificate and provisioning profile match)
  3. Check network connection (certificate verification may be required in some cases)
  4. View log output for specific error information

## 高级功能 / Advanced Features

### 证书管理 / Certificate Management

- 点击签名配置中的「浏览」按钮可以查看所有有效证书
- 支持按名称搜索证书
- 显示证书的有效期和状态

- Click the "浏览" (Browse) button in signing configuration to view all valid certificates
- Support certificate search by name
- Display certificate validity period and status

### 动态库注入 / Dynamic Library Injection

- **BundleSpyDylib**：内置的动态库，用于监控应用行为
- **自定义 dylib**：使用自己的动态库进行注入

- **BundleSpyDylib**: Built-in dynamic library for monitoring app behavior
- **Custom dylib**: Use your own dynamic library for injection

## 系统要求 / System Requirements

- macOS 10.15 或更高版本
- Qt 6.10.2 运行时（已包含在 DMG 中）
- Xcode 命令行工具（用于代码签名）

- macOS 10.15 or later
- Qt 6.10.2 runtime (included in the DMG)
- Xcode command line tools (for code signing)

## 联系方式 / Contact

如果遇到问题或有建议，请在 GitHub 仓库提交 issue。

If you encounter issues or have suggestions, please submit an issue on the GitHub repository.

---

**版本**: 0.1
**更新日期**: 2026-03-09
**开发者**: 小蟹科技

**Version**: 0.1
**Update Date**: 2026-03-09
**Developer**: 小蟹科技

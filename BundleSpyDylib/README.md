# BundleSpyDylib

这是一个用于拦截和伪装Bundle ID的动态库，可以注入到iOS应用中。

## 功能

- 拦截 `NSBundle mainBundle` 调用
- 拦截 `bundleIdentifier` 方法调用
- 支持伪装原始的Bundle ID
- 通过UserDefaults配置伪装的Bundle ID

## 编译

在macOS环境下编译：

```bash
cd BundleSpyDylib
mkdir build && cd build
cmake ..
make
```

## 使用方法

### 1. 使用insert_dylib注入

```bash
insert_dylib --all-yes @executable_path/Frameworks/BundleSpyDylib.dylib YourApp.app/YourApp
```

### 2. 配置伪装的Bundle ID

在注入前，可以通过以下方式设置伪装的Bundle ID：

```bash
defaults write com.example.YourApp FakeBundleId "com.fake.bundle.id"
```

或者在代码中调用：

```objective-c
setFakeBundleId(@"com.fake.bundle.id");
```

### 3. 获取原始和伪装的Bundle ID

```objective-c
NSString* originalId = getOriginalBundleId();
NSString* fakeId = getFakeBundleId();
```

## 技术细节

- 使用Objective-C Runtime API进行方法hook
- 通过`method_setImplementation`替换方法实现
- 支持动态设置和获取Bundle ID
- 自动加载和清理

## 注意事项

- 仅用于合法的逆向工程和安全研究
- 请遵守相关法律法规
- 不得用于非法用途

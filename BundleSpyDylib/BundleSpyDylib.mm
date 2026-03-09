#include "BundleSpyDylib.h"
#include "fishhook.h"
#include <dlfcn.h>
#include <objc/runtime.h>
#include <objc/message.h>
#include <CoreFoundation/CoreFoundation.h>
#include <stdio.h>
#include <string.h>

static NSString* g_originalBundleId = nil;
static NSString* g_fakeBundleId = nil;
static BOOL g_hooksInstalled = NO;
static NSBundle* g_cachedMainBundle = nil;
static CFBundleRef g_cachedMainCFBundle = NULL;

mainBundle_original mainBundle_original_func = NULL;
bundleIdentifier_original bundleIdentifier_original_func = NULL;

static CFStringRef (*original_CFBundleGetIdentifier)(CFBundleRef bundle) = NULL;

NSBundle* hooked_mainBundle(id self, SEL _cmd) {
    if (mainBundle_original_func == NULL) {
        return nil;
    }
    
    NSBundle* bundle = mainBundle_original_func(self, _cmd);
    
    if (bundle != nil && g_cachedMainBundle == nil) {
        g_cachedMainBundle = bundle;
    }
    
    return bundle;
}

NSString* hooked_bundleIdentifier(id self, SEL _cmd) {
    if (bundleIdentifier_original_func == NULL) {
        return nil;
    }
    
    NSString* originalId = bundleIdentifier_original_func(self, _cmd);
    
    if (originalId == nil) {
        return nil;
    }
    
    // 只对主 bundle 进行 hook
    if (g_cachedMainBundle != nil && self != g_cachedMainBundle) {
        return originalId;
    }
    
    if (g_originalBundleId == nil) {
        g_originalBundleId = [originalId copy];
        printf("[BundleSpy] Original Bundle ID (from ObjC): %s\n", [originalId UTF8String]);
    }
    
    if (g_fakeBundleId != nil) {
        printf("[BundleSpy] Returning fake Bundle ID (from ObjC): %s (original: %s)\n", 
               [g_fakeBundleId UTF8String], [originalId UTF8String]);
        return g_fakeBundleId;
    }
    
    return originalId;
}

void setFakeBundleId(NSString* fakeId) {
    if (fakeId == nil || [fakeId length] == 0) {
        return;
    }
    
    if (g_fakeBundleId != nil) {
        [g_fakeBundleId release];
    }
    g_fakeBundleId = [fakeId copy];
    printf("[BundleSpy] Fake Bundle ID set to: %s\n", [fakeId UTF8String]);
}

NSString* getOriginalBundleId(void) {
    return g_originalBundleId;
}

NSString* getFakeBundleId(void) {
    return g_fakeBundleId;
}

static CFStringRef hooked_CFBundleGetIdentifier(CFBundleRef bundle) {
    if (original_CFBundleGetIdentifier == NULL || bundle == NULL) {
        return NULL;
    }
    
    CFStringRef originalId = original_CFBundleGetIdentifier(bundle);
    
    if (originalId == NULL) {
        return NULL;
    }
    
    // 只对主 bundle 进行 hook（使用缓存的引用避免递归调用 CFBundleGetMainBundle）
    if (g_cachedMainCFBundle != NULL && bundle != g_cachedMainCFBundle) {
        return originalId;
    }
    
    // 如果还没有缓存，比较 bundle 的 executable URL
    if (g_cachedMainCFBundle == NULL) {
        CFURLRef mainURL = CFBundleCopyExecutableURL(bundle);
        if (mainURL != NULL) {
            // 这是第一个被查询的 bundle，假设是主 bundle
            g_cachedMainCFBundle = bundle;
            CFRelease(mainURL);
        } else {
            return originalId;
        }
    }
    
    const char* originalIdStr = CFStringGetCStringPtr(originalId, kCFStringEncodingUTF8);
    char buffer[256] = {0};
    if (originalIdStr == NULL) {
        if (CFStringGetCString(originalId, buffer, sizeof(buffer), kCFStringEncodingUTF8)) {
            originalIdStr = buffer;
        }
    }
    
    if (g_originalBundleId == nil && originalIdStr != NULL) {
        g_originalBundleId = [[NSString stringWithUTF8String:originalIdStr] copy];
        printf("[BundleSpy] Original Bundle ID (from CF): %s\n", originalIdStr);
    }
    
    if (g_fakeBundleId != nil) {
        printf("[BundleSpy] Returning fake Bundle ID (from CF): %s (original: %s)\n", 
               [g_fakeBundleId UTF8String], originalIdStr ?: "(null)");
        return (__bridge CFStringRef)g_fakeBundleId;
    }
    
    return originalId;
}

static void loadFakeBundleIdFromConfig(void) {
    // 直接从 Info.plist 字典读取，避免调用可能被 hook 的函数
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    if (mainBundle != NULL) {
        CFTypeRef fakeIdRef = CFBundleGetValueForInfoDictionaryKey(
            mainBundle, CFSTR("IPAResignFakeBundleId"));
        
        if (fakeIdRef != NULL && CFGetTypeID(fakeIdRef) == CFStringGetTypeID()) {
            const char* fakeIdStr = CFStringGetCStringPtr((CFStringRef)fakeIdRef, kCFStringEncodingUTF8);
            if (fakeIdStr != NULL) {
                NSString* fakeId = [NSString stringWithUTF8String:fakeIdStr];
                if ([fakeId length] > 0) {
                    setFakeBundleId(fakeId);
                    printf("[BundleSpy] Loaded fake Bundle ID from Info.plist: %s\n", fakeIdStr);
                }
            }
        }
    }
}

static void install_cf_hooks(void) {
    printf("[BundleSpy] Installing CF hooks using fishhook...\n");
    
    struct rebinding rebindings[] = {
        {
            "CFBundleGetIdentifier",
            (void*)hooked_CFBundleGetIdentifier,
            (void**)&original_CFBundleGetIdentifier
        }
    };
    
    int result = rebind_symbols(rebindings, sizeof(rebindings) / sizeof(rebindings[0]));
    
    if (result == 0) {
        printf("[BundleSpy] CF hooks installed successfully\n");
    } else {
        printf("[BundleSpy] Failed to install CF hooks, error: %d\n", result);
    }
}

void install_hooks(void) {
    if (g_hooksInstalled) {
        printf("[BundleSpy] Hooks already installed\n");
        return;
    }
    
    printf("[BundleSpy] Installing ObjC hooks...\n");
    
    Class nsBundleClass = objc_getClass("NSBundle");
    if (nsBundleClass == nil) {
        printf("[BundleSpy] Failed to get NSBundle class\n");
        return;
    }
    
    SEL mainBundleSel = @selector(mainBundle);
    SEL bundleIdentifierSel = @selector(bundleIdentifier);
    
    Method mainBundleMethod = class_getClassMethod(nsBundleClass, mainBundleSel);
    Method bundleIdentifierMethod = class_getInstanceMethod(nsBundleClass, bundleIdentifierSel);
    
    if (mainBundleMethod == nil) {
        printf("[BundleSpy] Failed to get mainBundle method\n");
        return;
    }
    
    if (bundleIdentifierMethod == nil) {
        printf("[BundleSpy] Failed to get bundleIdentifier method\n");
        return;
    }
    
    mainBundle_original_func = (mainBundle_original)method_getImplementation(mainBundleMethod);
    bundleIdentifier_original_func = (bundleIdentifier_original)method_getImplementation(bundleIdentifierMethod);
    
    if (mainBundle_original_func == NULL || bundleIdentifier_original_func == NULL) {
        printf("[BundleSpy] Failed to get original implementations\n");
        return;
    }
    
    method_setImplementation(mainBundleMethod, (IMP)hooked_mainBundle);
    method_setImplementation(bundleIdentifierMethod, (IMP)hooked_bundleIdentifier);
    
    printf("[BundleSpy] ObjC hooks installed successfully\n");
    
    install_cf_hooks();
    
    g_hooksInstalled = YES;
}

__attribute__((constructor))
static void initialize(void) {
    printf("[BundleSpy] BundleSpyDylib loaded\n");
    printf("[BundleSpy] Version: 1.8 (stable)\n");
    
    // 先加载配置，再安装 hooks
    loadFakeBundleIdFromConfig();
    install_hooks();
}

__attribute__((destructor))
static void cleanup(void) {
    printf("[BundleSpy] BundleSpyDylib unloading\n");
    
    if (g_originalBundleId != nil) {
        [g_originalBundleId release];
        g_originalBundleId = nil;
    }
    
    if (g_fakeBundleId != nil) {
        [g_fakeBundleId release];
        g_fakeBundleId = nil;
    }
    
    g_cachedMainBundle = nil;
    g_cachedMainCFBundle = NULL;
}

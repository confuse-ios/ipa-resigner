#ifndef BUNDLESPYDYLIB_H
#define BUNDLESPYDYLIB_H

#include <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef NSBundle* (*mainBundle_original)(id self, SEL _cmd);
typedef NSString* (*bundleIdentifier_original)(id self, SEL _cmd);

extern mainBundle_original mainBundle_original_func;
extern bundleIdentifier_original bundleIdentifier_original_func;

NSBundle* hooked_mainBundle(id self, SEL _cmd);
NSString* hooked_bundleIdentifier(id self, SEL _cmd);

void install_hooks(void);

void setFakeBundleId(NSString* fakeId);
NSString* getOriginalBundleId(void);
NSString* getFakeBundleId(void);

#ifdef __cplusplus
}
#endif

#endif

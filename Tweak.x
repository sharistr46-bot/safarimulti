// Tweak.x — SafariMulti
// Provides per-profile WKWebsiteDataStore for Safari only.
// SPDX-License-Identifier: MIT

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

static NSString * const kProfilePath =
    @"/var/jb/var/mobile/Library/Preferences/com.zorrogo.safarimulti.activeProfile.plist";

// Read currently active profile UUID. Returns nil if no override is set.
static NSUUID * _Nullable currentProfileUUID(void) {
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:kProfilePath];
    NSString *uuidStr = plist[@"identifier"];
    if (![uuidStr isKindOfClass:[NSString class]] || uuidStr.length == 0) {
        return nil;
    }
    return [[NSUUID alloc] initWithUUIDString:uuidStr];
}

%hook WKWebViewConfiguration

- (WKWebsiteDataStore *)websiteDataStore {
    NSUUID *profile = currentProfileUUID();
    if (profile == nil) {
        return %orig;
    }
    if (@available(iOS 17.0, *)) {
        return [WKWebsiteDataStore dataStoreForIdentifier:profile];
    }
    // iOS 15/16: dataStoreForIdentifier: not available. Stay on default.
    return %orig;
}

%end

%ctor {
    @autoreleasepool {
        NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
        if (![bundleId isEqualToString:@"com.apple.mobilesafari"]) {
            return;
        }
        %init;
    }
}

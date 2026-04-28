# Architecture

## Design goals

1. **Single hook, single target** — minimize attack surface and audit complexity.
2. **No license logic in the dylib** — the tweak does only data isolation; license is handled in the companion app and on the server.
3. **No data leaves the device** from the dylib — no network code, no analytics, no telemetry.
4. **Reproducible builds** — anyone can rebuild from source and verify SHA256 against published releases.

## Component layout

```
┌──────────────────────────────────┐
│ SafariMulti.app (companion)      │
│ - User UI for profile management │
│ - License verification (talks to │
│   license.zorrogo.com)           │
│ - Writes activeProfile.plist     │
└──────────────────────────────────┘
                 │
                 │ writes
                 ▼
   /var/jb/var/mobile/Library/Preferences/
   com.zorrogo.safarimulti.activeProfile.plist
                 │
                 │ reads
                 ▼
┌──────────────────────────────────┐
│ safarimultid.dylib               │
│ - Filter: com.apple.mobilesafari │
│ - Hook: WKWebViewConfiguration.  │
│   websiteDataStore (getter only) │
│ - No network, no other hooks     │
└──────────────────────────────────┘
                 │
                 │ injected into
                 ▼
            Mobile Safari
```

## The single hook

```objc
%hook WKWebViewConfiguration
- (WKWebsiteDataStore *)websiteDataStore {
    NSUUID *profile = currentProfileUUID();
    if (profile == nil) return %orig;
    if (@available(iOS 17.0, *)) {
        return [WKWebsiteDataStore dataStoreForIdentifier:profile];
    }
    return %orig;
}
%end
```

That is the entirety of the runtime modification SafariMulti makes to Safari.

## Why `WKWebsiteDataStore.dataStoreForIdentifier:`?

This is a **public Apple API** introduced in iOS 17 specifically for the multi-profile use case. Each identifier produces a fully isolated data store: cookies, localStorage, IndexedDB, sessionStorage, cache, WebSQL — Apple does the heavy lifting.

Using a public API means:
- No private framework dependencies
- No need to swizzle deep WebKit internals
- Behavior is documented and stable across iOS minor versions
- Future iOS upgrades that change WebKit internals do not break us

## What we explicitly do not do

- ❌ Do not hook any networking API (`NSURLSession`, `CFNetwork`, BSD socket layer)
- ❌ Do not access keychain (`Security` framework)
- ❌ Do not access photos, contacts, location, motion, microphone
- ❌ Do not poll the pasteboard
- ❌ Do not enumerate other applications
- ❌ Do not collect device fingerprints (UDID, IMEI, MAC, etc.)
- ❌ Do not establish persistence outside of standard MobileSubstrate filter

## iOS 15 / 16 compatibility

`dataStoreForIdentifier:` is iOS 17+. On iOS 15/16 the hook is a no-op (returns the default store). A future v19.1 may add an iOS 15/16 fallback using `nonPersistentDataStore` + a userland-managed cookie persistence layer; that path approximately doubles the code size and surface area, so it ships separately rather than being bundled now.

## Threats considered

See `threat-model.md`.

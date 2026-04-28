# SafariMulti

Per-profile `WKWebsiteDataStore` isolation for Mobile Safari on jailbroken iOS.

## What it does

- Adds support for multiple, fully-isolated browser profiles in Safari
- Each profile has its own cookies, localStorage, IndexedDB, sessionStorage, and cache
- Switch between profiles via the companion `SafariMulti.app`
- All data stays on your device

## What it does NOT do

- ❌ Does NOT modify any app other than Safari
- ❌ Does NOT bypass any app's license, VIP status, or subscription
- ❌ Does NOT read keychain, contacts, photos, location, or clipboard
- ❌ Does NOT enumerate other installed apps
- ❌ Does NOT connect to any third-party server (only `license.zorrogo.com` for license verification)

## Requirements

- iOS 17.0 or later
- Rootless jailbreak (Dopamine recommended)
- MobileSubstrate / Substitute / ElleKit

## Install

### Sileo source

```
https://repo.zorrogo.com
```

### From source

See [BUILD.md](BUILD.md).

## Security

- Source is fully open under the MIT License
- Each release ships with SHA256, undefined-symbol dump, strings dump, and dylib dependency graph (see GitHub Releases)
- Independent third-party audit: see `assets/security/` once published
- Vulnerability disclosure: see [SECURITY.md](SECURITY.md)
- Privacy policy: see [PRIVACY.md](PRIVACY.md)

## Why open source

We previously shipped a closed-source product (zorro v18) that became a supply-chain incident. We've chosen to rebuild as fully open source with deterministic builds and third-party audits as a permanent commitment to user trust.

See `docs/v18-advisory.md` for the public post-mortem.

## License

MIT — see [LICENSE](LICENSE).

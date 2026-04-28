# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [19.0.0] - TBD

### Added
- Initial release of the rewritten, open-source SafariMulti tweak.
- Single hook on `WKWebViewConfiguration.websiteDataStore` for per-profile isolation on iOS 17+.
- Public CI audit pipeline (`.github/workflows/audit.yml`).
- Reproducible build artifacts: SHA256, undefined-symbol dump, strings dump, dylib dependency graph.

### Removed (compared to deprecated v18)
- All third-party app filters (`com.amazon.AmazonJP`, etc.) — this version targets Safari only.
- All references to Shadowrocket, VIP, license bypass, or any unrelated bundle identifiers.
- All non-`zorrogo.com` server endpoints.
- All Objective-C name obfuscation — code is fully readable.
- All anti-debug, anti-hook, anti-tamper measures.

### Security
- See `docs/v18-advisory.md` for the v18 supply-chain incident post-mortem and rationale for the rewrite.

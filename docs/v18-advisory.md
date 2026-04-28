# Security Advisory: zorro v18 (deprecated)

**Status:** DEPRECATED — do not install. Uninstall if installed.
**Affected versions:** v18.0.1 and any earlier v18.x build distributed via "zorro 授权官方源".
**Disclosure date:** [DATE]

## Summary

During an internal audit of the v18 binary, the following indicators of compromise were identified:

- Hardcoded reference to a third-party domain (`appleunc.tgkmu.top`) outside of zorrogo team's control.
- Hardcoded URL with `.con` typo (`gozorro.con/license.html`) suggesting either a typosquat or a fallback channel inserted without team knowledge.
- The MobileSubstrate filter included `com.amazon.AmazonJP`, which is outside the publicly stated scope of the product (Safari profile management).
- Hardcoded references to `com.liguangming.Shadowrocket` in the main binary, also outside the stated scope.

We commissioned a third-party forensic analysis to determine the full extent of these findings. The full report is published at `assets/security/v18-forensic-2026.pdf` once available.

## Impact

If you used v18, the following may have been exposed during normal use:
- Cookies and session data of websites you accessed in Safari while v18 was installed.
- Account session data of the Amazon Japan iOS app, if installed alongside v18.

We have **no evidence** that the v19 codebase or zorrogo infrastructure (`license.zorrogo.com`, `app.zorrogo.com`) was compromised. The incident was scoped to the v18 deb package as distributed.

## Recommended actions for v18 users

1. Uninstall v18 immediately via Sileo: search for "zorro" → uninstall.
2. If you used Safari with v18 installed, change passwords for accounts you logged into during that period.
3. If you used Amazon Japan with v18 installed, sign out of all sessions in your Amazon account and review recent activity.
4. Install v19 (open source, MIT license) when available: https://github.com/zorrogo/safarimulti

## Compensation for v18 paid users

- All v18 paid license holders automatically receive a free perpetual v19 license.
- Subscription users receive an additional 6 months added to their term.
- Contact `support@zorrogo.com` for additional remediation requests.

## What changed in v19

v19 is a complete rewrite, not a patched v18:

- **Open source under MIT** — all code reviewable on GitHub.
- **Single hook on Safari only** — filter is locked to `com.apple.mobilesafari` and CI prevents adding more.
- **No license logic in the dylib** — moved to companion app + server.
- **No third-party SDKs.**
- **Reproducible builds** — anyone can rebuild and compare against released SHA256.
- **CI security audit** — every commit scanned for forbidden TLDs, sensitive APIs, and out-of-scope filters.

## Timeline

| Date | Event |
|------|-------|
| [DATE] | Internal audit started, IOCs identified |
| [DATE] | v18 marked deprecated on Sileo source |
| [DATE] | This advisory published |
| [DATE] | Third-party forensic engagement signed |
| [DATE] | v19 first beta |
| [DATE] | v19 stable |
| [DATE] | Forensic report published |
| [DATE] | v18 fully removed from Sileo source |

## Contact

- Security: `security@zorrogo.com`
- Support / refunds: `support@zorrogo.com`
- Press: `press@zorrogo.com`

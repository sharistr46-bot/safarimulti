# Security Policy

## Reporting a Vulnerability

Email: **security@zorrogo.com**

PGP key: [link to public key file when available]

Please include:
- Affected version
- Steps to reproduce
- Expected vs observed behavior
- Any proof-of-concept (in the safest form possible)

We aim to:
- Acknowledge within 3 business days
- Provide a status update within 14 days
- Release a fix within 90 days for high-severity issues

## Safe Harbor

We will not pursue legal action against researchers who:

- Make a good-faith effort to avoid privacy violations, data destruction, and service disruption
- Report through `security@zorrogo.com` and give us reasonable time to respond before public disclosure
- Do not exploit findings beyond what is necessary to demonstrate the issue

## Supported Versions

| Version | Supported |
|---------|-----------|
| 19.x    | ✅ |
| 18.x    | ❌ DEPRECATED — see `docs/v18-advisory.md` |

## Scope

In scope:
- `safarimultid.dylib` (the tweak binary)
- `SafariMulti.app` (companion app, when published)
- `license.zorrogo.com` and related infrastructure

Out of scope:
- Apple Safari itself, iOS, or other Apple infrastructure
- Other jailbreaks or third-party tweaks
- Social engineering attacks against zorrogo team members

## Hall of Fame

We acknowledge researchers who have reported issues here once we receive valid reports.

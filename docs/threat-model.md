# Threat Model

## Assets

| Asset | Owner | Where it lives |
|-------|-------|----------------|
| Per-profile browser data (cookies, storage) | User | Device only, in WebKit's per-`identifier` data store |
| Active profile selection | User | `~/Library/Preferences/com.zorrogo.safarimulti.activeProfile.plist` |
| License key | User | Companion app (Keychain) |
| License capabilities | Server-issued, short-lived JWT | Companion app (Keychain) |
| Server private signing key | zorrogo team | `license.zorrogo.com` HSM / KMS |

## Adversaries

### A1 — Curious user
**Goal:** see what the tweak does on their own device.
**Mitigation:** code is open-source. Treated as a feature, not a threat.

### A2 — Malicious tweak in the same jailbreak
**Goal:** read SafariMulti's profile data from outside Safari's sandbox.
**Mitigation:** WebKit's `WKWebsiteDataStore` per-identifier directories live under Safari's container. A peer tweak can already access them on a jailbroken device — this is a baseline jailbreak property, not a SafariMulti-specific risk. We document this clearly.

### A3 — Network attacker on the wire
**Goal:** intercept license verification, steal license keys.
**Mitigation:** TLS 1.3 to `license.zorrogo.com` with certificate pinning in the companion app. License keys never leave the device unencrypted.

### A4 — Compromised license server
**Goal:** issue fraudulent capabilities, or read license-key database.
**Mitigation (in scope):** server-side license keys are stored as `argon2id(key + per-row salt)`, never in plaintext. JWT signing keys live in HSM/KMS, not on the application server. Compromise containment via short JWT TTL (15 min).

### A5 — Supply chain attack on the build pipeline
**Goal:** inject malicious code into a release, e.g. like the v18 incident.
**Mitigation:**
- All builds run in GitHub Actions (auditable runner image).
- Build artifacts include nm/strings/otool dumps; CI fails if any IOC pattern matches.
- Releases are signed with a key held only by the release manager.
- Reproducible builds — community can rebuild and compare hashes.
- No third-party SDKs in the dylib.

### A6 — Future maintainer adds a forbidden hook
**Goal:** silently expand scope (e.g. add another bundle id to the filter, hook a sensitive API).
**Mitigation:** `ci/audit.sh` is enforced on every PR. A change that adds a third-party bundle id, links a forbidden API, or introduces a non-allowed domain breaks the build before review.

### A7 — Device theft / forensics
**Goal:** access SafariMulti profile data on a stolen device.
**Mitigation:** out of scope for SafariMulti — covered by iOS device passcode and Data Protection. We do not weaken that baseline.

## Out of scope

- Compromised iOS itself (Apple's responsibility)
- Compromised jailbreak (Dopamine team's responsibility)
- Other tweaks installed by the user (user's responsibility)
- Apple service-side compromise (Apple's responsibility)

## Disclosure

Any threat that turns out to apply but isn't listed here: open a SECURITY advisory and we'll add it.

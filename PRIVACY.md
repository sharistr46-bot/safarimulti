# Privacy Policy — SafariMulti

Effective: [DATE]

## Summary

- All Safari profile data (cookies, localStorage, IndexedDB, etc.) stays **on your device**
- We never collect, transmit, or store: browsing history, cookies, form data, passwords, URLs visited
- The only data sent to our servers is what is required for license verification

## Data Stored Locally

The following remains on your device and is never transmitted:

- Profile names you create
- Profile UUIDs
- Cookies, localStorage, IndexedDB, sessionStorage, cache (per profile)
- App preferences

## Data Sent to `license.zorrogo.com`

When verifying your license, the following is sent over HTTPS (with certificate pinning):

| Field | Purpose | Retention |
|-------|---------|-----------|
| Apple DeviceCheck token | Server-validated device binding | Per session |
| `sha256(IDFV + server_pepper)` | Device hash for license binding | Until you uninstall |
| License key (you provide) | Authorization | Until license expires |
| App version | Compatibility | Aggregated, anonymized |
| Error reports (opt-in) | Bug fixing | 30 days |

We do **not** collect:

- Your IP address (beyond what is needed for the TLS connection itself)
- Your real device identifier (UDID, IMEI, serial, MAC address — none of these are accessed)
- Your browsing data of any kind
- Your geolocation
- Lists of other installed apps

## Third Parties

We use no third-party analytics, ads, trackers, or SDKs.

## Your Rights

- Request deletion of your license records: email `privacy@zorrogo.com`
- Export what we hold about you (will be a single JSON in seconds)
- Opt out of optional error reporting at any time in the app

## Changes

Material changes will be announced via:
- This file in the public repo (Git history is your audit trail)
- A notice in the app on first launch after the change

# Build Instructions

## Prerequisites

- macOS or Linux (build host) — Windows works via WSL2
- [Theos](https://theos.dev) installed and `$THEOS` environment variable set
- iOS 17 SDK (any Xcode 15+)
- A jailbroken iOS 17+ device for testing

## Quick Build

```bash
git clone https://github.com/zorrogo/safarimulti.git
cd safarimulti
make package FINALPACKAGE=1
```

The resulting `.deb` is in `packages/`.

## Install on Device

```bash
make package install FINALPACKAGE=1
```

(Requires `THEOS_DEVICE_IP` set, or run via Sileo on the device.)

## Reproducible Builds

We aim for byte-reproducible release builds. To verify a release matches what's in this repo:

```bash
git checkout v19.X.Y
make package FINALPACKAGE=1
shasum -a 256 packages/*.deb
# Compare with the SHA256 in the GitHub Release notes
```

If they don't match, please open an issue.

## Run CI Audit Locally

Before submitting a PR, run:

```bash
chmod +x ci/audit.sh
./ci/audit.sh ./.theos/obj/debug/safarimultid.dylib ./safarimultid.plist
```

All checks must pass.

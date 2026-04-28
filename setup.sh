#!/bin/bash
# One-shot bootstrap for SafariMulti development environment.
# Run this once after cloning.
set -e

# Pre-flight checks
if [ -z "$THEOS" ]; then
    echo "ERROR: THEOS environment variable not set."
    echo "Install Theos first: https://theos.dev/docs/installation"
    exit 1
fi

if [ ! -d "$THEOS" ]; then
    echo "ERROR: \$THEOS points to '$THEOS' which does not exist."
    exit 1
fi

# Ensure CI scripts are executable
chmod +x ci/*.sh

# Sanity build
echo "Running sanity build..."
make clean
make

# Run audit on debug build
echo ""
echo "Running CI audit on debug build..."
./ci/audit.sh ./.theos/obj/debug/safarimultid.dylib ./safarimultid.plist

echo ""
echo "================================================================"
echo "Setup complete."
echo ""
echo "Next steps:"
echo "  - Edit Tweak.x for changes"
echo "  - 'make package FINALPACKAGE=1' for release build"
echo "  - 'make package install FINALPACKAGE=1' to deploy to device"
echo "    (set THEOS_DEVICE_IP first)"
echo "  - Tag a release on GitHub to trigger automated artifact generation"
echo "================================================================"

#!/bin/bash
# Generate transparency artifacts for a release.
# Usage: ./ci/release_artifacts.sh <version>  (e.g. 19.0.0)
set -e

VERSION="${1:?usage: release_artifacts.sh <version>}"
DYLIB=$(find .theos -name 'safarimultid.dylib' -not -path '*.unsigned*' 2>/dev/null | head -1)
DEB=$(ls packages/*.deb 2>/dev/null | head -1)
PLIST="./safarimultid.plist"
OUT="./release/v${VERSION}"

if [ -z "$DYLIB" ] || [ ! -f "$DYLIB" ]; then
    echo "ERROR: dylib not found. Run 'make package FINALPACKAGE=1' first."
    exit 2
fi
echo "Using dylib: $DYLIB"
echo "Using deb:   ${DEB:-<not found>}"

mkdir -p "$OUT"

cp "$DYLIB" "$OUT/"
cp "$PLIST" "$OUT/"
[ -f "$DEB" ] && cp "$DEB" "$OUT/"

cd "$OUT"

# Hashes
shasum -a 256 * > SHA256.txt
shasum -a 512 * > SHA512.txt

# Symbol dumps (transparency)
nm -u safarimultid.dylib > symbols-undefined.txt || true
nm safarimultid.dylib 2>/dev/null | grep -E ' [TtSsBbDd] ' > symbols-defined.txt || true

# Strings (transparency)
strings -a -n 6 safarimultid.dylib > strings.txt

# Dylib dependency graph (transparency)
otool -L safarimultid.dylib > dylib-deps.txt
otool -lv safarimultid.dylib > load-commands.txt

# Build manifest
cat > MANIFEST.txt <<EOF
SafariMulti Release v${VERSION}
Build date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Git commit: $(git rev-parse HEAD 2>/dev/null || echo unknown)
Git tag:    $(git describe --tags --exact-match 2>/dev/null || echo unknown)

Files:
$(ls -la *.dylib *.plist *.deb 2>/dev/null)

Reproducibility:
  To verify this release: 'git checkout v${VERSION} && make package FINALPACKAGE=1'
  Then compare SHA256 of resulting .deb with SHA256.txt above.
EOF

echo "Release artifacts ready in $OUT/"
ls -la

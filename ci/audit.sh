#!/bin/bash
# SafariMulti CI audit — runs on every PR and release tag.
# Fails the build if any IOC is detected.
#
# Usage: ./ci/audit.sh [path-to-dylib] [path-to-plist]
set -e

DYLIB="${1:-./.theos/obj/debug/safarimultid.dylib}"
PLIST="${2:-./safarimultid.plist}"
FAIL=0

if [ ! -f "$DYLIB" ]; then
    echo "ERROR: dylib not found at $DYLIB"
    exit 2
fi
if [ ! -f "$PLIST" ]; then
    echo "ERROR: plist not found at $PLIST"
    exit 2
fi

echo "================================================================"
echo "SafariMulti CI Audit"
echo "Target: $DYLIB"
echo "Filter: $PLIST"
echo "================================================================"

# 1. Domain / URL blacklist (suspicious TLDs)
echo ""
echo "[1/8] Suspicious TLD scan..."
BAD_TLD='\.(top|xyz|gq|tk|ml|pw|click|live|info|cn-)([^a-z0-9]|$)'
if strings -a -n 4 "$DYLIB" | grep -E "$BAD_TLD"; then
    echo "  FAIL: Found suspicious TLD"
    FAIL=1
else
    echo "  OK"
fi

# 2. Plaintext HTTP (non-localhost)
echo ""
echo "[2/8] Plaintext HTTP scan..."
if strings -a -n 4 "$DYLIB" | grep -E '^http://' | grep -vE 'localhost|127\.0\.0\.1'; then
    echo "  FAIL: Plaintext HTTP URL detected"
    FAIL=1
else
    echo "  OK"
fi

# 3. Forbidden keywords
echo ""
echo "[3/8] Forbidden keyword scan..."
KW='shadowrocket|surge|quantumult|loon|stash|crack|bypass|patch.*license|vip[^a-z]|license.*bypass'
if strings -a -n 4 "$DYLIB" | grep -iE "$KW"; then
    echo "  FAIL: Forbidden keyword detected"
    FAIL=1
else
    echo "  OK"
fi

# 4. Domain allowlist enforcement
echo ""
echo "[4/8] Domain allowlist..."
ALLOWED='zorrogo\.com$|apple\.com$|^localhost$|^127\.0\.0\.1$'
# 排除 reverse-DNS bundle ID 命名（com.x.y / org.x.y / etc）和文件扩展名
BUNDLE_ID_PREFIX='^(com|org|net|io|cn|uk|jp|de|fr|us|au|ca|cc|tv|me|ai|app|dev)\.'
DENY=$(strings -a -n 4 "$DYLIB" \
        | grep -oE '[a-z0-9][a-z0-9.-]+\.[a-z]{2,}' \
        | grep -vE '\.(framework|dylib|app|plist|json)$' \
        | grep -vE "$BUNDLE_ID_PREFIX" \
        | sort -u \
        | grep -vE "$ALLOWED" || true)
if [ -n "$DENY" ]; then
    echo "  FAIL: Unallowed domains:"
    echo "$DENY" | sed 's/^/    /'
    FAIL=1
else
    echo "  OK"
fi

# 5. Sensitive API blacklist (must not be linked)
echo ""
echo "[5/8] Sensitive API scan..."
SENS=(
    SecItemCopyMatching SecItemAdd SecItemUpdate SecItemDelete
    SecKeychainFindItem
    ABAddressBookCopyArrayOfAllPeople
    CNContactStore
    PHPhotoLibrary AVCaptureSession
    CLLocationManager CMMotionManager
    proc_listallpids LSApplicationProxy LSApplicationWorkspace
    MGCopyAnswer
)
HIT=0
for s in "${SENS[@]}"; do
    if nm -u "$DYLIB" 2>/dev/null | grep -q "_${s}"; then
        echo "  FAIL: Sensitive API linked: $s"
        HIT=1
    fi
done
if [ $HIT -eq 0 ]; then echo "  OK"; else FAIL=1; fi

# 6. Filter plist whitelist (exact match)
echo ""
echo "[6/8] Plist filter scan..."
FILTER=$(plutil -extract Filter.Bundles xml1 -o - "$PLIST" 2>/dev/null \
         | grep -oE '<string>[^<]+</string>' \
         | sed 's/<[^>]*>//g')
EXPECTED="com.apple.mobilesafari"
if [ "$FILTER" != "$EXPECTED" ]; then
    echo "  FAIL: filter is '$FILTER', must be exactly '$EXPECTED'"
    FAIL=1
else
    echo "  OK"
fi

# 7. CryptID must be 0 (no FairPlay encryption in jailbreak deb)
echo ""
echo "[7/8] CryptID scan..."
if otool -l "$DYLIB" 2>/dev/null | grep -A 5 LC_ENCRYPTION_INFO | grep -q 'cryptid 1'; then
    echo "  FAIL: cryptid set (should be 0 for jailbreak deb)"
    FAIL=1
else
    echo "  OK"
fi

# 8. RWX segments (executable + writable simultaneously)
echo ""
echo "[8/8] RWX segment scan..."
if otool -l "$DYLIB" 2>/dev/null \
   | awk '/segname/{seg=$2} /maxprot/{print seg, $0}' \
   | grep -E 'maxprot 0x0*7'; then
    echo "  FAIL: RWX segment present"
    FAIL=1
else
    echo "  OK"
fi

echo ""
echo "================================================================"
if [ $FAIL -eq 0 ]; then
    echo "RESULT: GREEN — all 8 checks passed"
    exit 0
else
    echo "RESULT: RED — see failures above. DO NOT RELEASE."
    exit 1
fi

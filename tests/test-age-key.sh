#!/bin/bash
# test-age-key.sh - Assert that the age key was correctly set up

set -euo pipefail

TARGET_HOME="${TEST_HOME:-$HOME}"
KEY_FILE="$TARGET_HOME/.config/chezmoi/key.txt"
PASS=0
FAIL=0

echo "=== Testing age key setup ==="

# Check key exists
if [ -f "$KEY_FILE" ]; then
  echo "  ✅ age key exists at $KEY_FILE"
  PASS=$((PASS + 1))
else
  echo "  ❌ age key NOT found at $KEY_FILE"
  FAIL=$((FAIL + 1))
  echo ""
  echo "Results: $PASS passed, $FAIL failed"
  exit 1
fi

# Check permissions are 600
PERMS=$(stat -c "%a" "$KEY_FILE")
if [ "$PERMS" = "600" ]; then
  echo "  ✅ age key permissions are 600"
  PASS=$((PASS + 1))
else
  echo "  ❌ age key permissions are $PERMS (expected 600)"
  FAIL=$((FAIL + 1))
fi

# Check key format is valid (should start with AGE-SECRET-KEY or have a public key comment)
if grep -qE "^(AGE-SECRET-KEY-|# public key:)" "$KEY_FILE"; then
  echo "  ✅ age key format is valid"
  PASS=$((PASS + 1))
else
  echo "  ❌ age key format is invalid"
  FAIL=$((FAIL + 1))
fi

# Check if key came from Bitwarden fixture (optional, non-fatal)
if grep -q "AGE-SECRET-KEY-1FAKEKEY" "$KEY_FILE"; then
  echo "  ✅ age key was retrieved from Bitwarden fixture"
  PASS=$((PASS + 1))
else
  echo "  ⚠️  age key was freshly generated (not from fixture)"
  echo "      This may indicate 'bw get notes chezmoi-age-key' failed silently."
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1

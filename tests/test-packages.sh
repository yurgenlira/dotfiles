#!/bin/bash
# test-packages.sh - Assert that required packages are installed

set -euo pipefail

PASS=0
FAIL=0

check_pkg() {
  if dpkg -l "$1" 2>/dev/null | grep -q "^ii"; then
    echo "  ✅ $1"
    PASS=$((PASS + 1))
  else
    echo "  ❌ $1 (NOT INSTALLED)"
    FAIL=$((FAIL + 1))
  fi
}

check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "  ✅ $1 (command found)"
    PASS=$((PASS + 1))
  else
    echo "  ❌ $1 (command NOT found)"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Testing packages are installed ==="
check_pkg curl
check_pkg git
check_pkg htop
check_pkg jq
check_pkg age

echo ""
echo "=== Testing commands are available ==="
check_cmd git
check_cmd curl
check_cmd jq
check_cmd age-keygen

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1

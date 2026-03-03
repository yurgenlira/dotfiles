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

check_snap() {
  if snap list "$1" >/dev/null 2>&1; then
    echo "  ✅ $1 (snap)"
    PASS=$((PASS + 1))
  else
    echo "  ❌ $1 (snap NOT found)"
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
check_pkg age
check_pkg antigravity
check_pkg curl
check_pkg git
check_pkg gnome-browser-connector
check_pkg google-chrome-stable
check_pkg htop
check_pkg jq
check_pkg nano
check_pkg plocate
check_pkg python3-psutil
check_pkg terraform

if [ "${SKIP_GUI_TESTS:-false}" != "true" ]; then
    echo ""
    echo "=== Testing snap packages are installed ==="
    check_snap aws-cli
fi

echo ""
echo "=== Testing commands are available ==="
check_cmd age-keygen
check_cmd antigravity
if [ "${SKIP_GUI_TESTS:-false}" != "true" ]; then
    check_cmd aws
fi
check_cmd bw
check_cmd curl
check_cmd git
check_cmd htop
check_cmd jq
check_cmd locate
check_cmd nano
check_cmd terraform

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1


 

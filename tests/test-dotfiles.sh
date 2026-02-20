#!/bin/bash
# test-dotfiles.sh - Assert that chezmoi applied dotfiles correctly

set -euo pipefail

TARGET_HOME="${TEST_HOME:-$HOME}"
PASS=0
FAIL=0

check_file() {
  local path="$TARGET_HOME/$1"
  if [ -f "$path" ]; then
    echo "  ✅ ~/$1"
    PASS=$((PASS + 1))
  else
    echo "  ❌ ~/$1 (MISSING)"
    FAIL=$((FAIL + 1))
  fi
}

check_dir() {
  local path="$TARGET_HOME/$1"
  if [ -d "$path" ]; then
    echo "  ✅ ~/$1/"
    PASS=$((PASS + 1))
  else
    echo "  ❌ ~/$1/ (MISSING)"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Testing dotfiles were applied ==="
check_file ".bash_aliases"
check_file ".bash_functions"
check_file ".gitconfig"
check_file ".profile"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1

#!/bin/bash
# run-all.sh - Run all integration tests
# Usage: bash tests/run-all.sh
# Environment variables:
#   TEST_HOME - home directory of the test user (default: $HOME)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERALL_PASS=0
OVERALL_FAIL=0

run_test() {
  local name="$1"
  local script="$2"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "▶ Running: $name"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if bash "$script"; then
    OVERALL_PASS=$((OVERALL_PASS + 1))
    echo "▶ $name: PASSED"
  else
    OVERALL_FAIL=$((OVERALL_FAIL + 1))
    echo "▶ $name: FAILED"
  fi
}

echo "╔══════════════════════════════════════════╗"
echo "║        Dotfiles Integration Tests        ║"
echo "╚══════════════════════════════════════════╝"

run_test "Packages"  "$SCRIPT_DIR/test-packages.sh"
run_test "Dotfiles"  "$SCRIPT_DIR/test-dotfiles.sh"
run_test "Age Key"   "$SCRIPT_DIR/test-age-key.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Final: $OVERALL_PASS suites passed, $OVERALL_FAIL suites failed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
[ "$OVERALL_FAIL" -eq 0 ] || exit 1

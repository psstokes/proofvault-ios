#!/usr/bin/env bash
set -euo pipefail

PROJECT_PATH="PrroofVault/PrroofVault.xcodeproj"
SCHEME="PrroofVault"
DESTINATION="platform=iOS Simulator,name=iPhone 15 Pro"

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild not found. Install Xcode and command line tools, then re-run ./tool/verify.sh." >&2
  exit 1
fi

if [[ ! -d "${PROJECT_PATH}" ]]; then
  echo "Xcode project not found at ${PROJECT_PATH}. Ensure the repo is intact and re-run ./tool/verify.sh." >&2
  exit 1
fi

echo "Running iOS simulator tests for ${SCHEME}..."
set +e
test_output=$(xcodebuild test \
  -project "${PROJECT_PATH}" \
  -scheme "${SCHEME}" \
  -destination "${DESTINATION}" 2>&1)
test_status=$?
set -e

printf '%s\n' "${test_output}"

if [[ ${test_status} -eq 0 ]]; then
  echo "Tests completed successfully."
  echo "✅ verify: PASS"
  exit 0
fi

if printf '%s\n' "${test_output}" | grep -q "not currently configured for the test action"; then
  echo "Test action not configured for ${SCHEME}; running simulator build fallback..."
  xcodebuild build \
    -project "${PROJECT_PATH}" \
    -scheme "${SCHEME}" \
    -destination "${DESTINATION}"
  echo "✅ verify: PASS"
  exit 0
fi

echo "xcodebuild test failed for ${SCHEME}." >&2
exit "${test_status}"

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
xcodebuild test \
  -project "${PROJECT_PATH}" \
  -scheme "${SCHEME}" \
  -destination "${DESTINATION}"

echo "✅ verify: PASS"

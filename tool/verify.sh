#!/usr/bin/env bash
set -euo pipefail

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild not found. Install Xcode and command line tools, then re-run ./tool/verify.sh." >&2
  exit 1
fi

echo "Running iOS simulator test build..."
xcodebuild test \
  -scheme "ProofVault" \
  -destination "platform=iOS Simulator,name=iPhone 15 Pro"

echo "✅ verify: PASS"

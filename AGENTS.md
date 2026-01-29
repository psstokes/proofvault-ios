# How Codex should work in this repo

## Purpose
This file defines how Codex should operate in the ProofVault repo.

## Non-negotiables (Project Laws)
- Pipeline-first: every future change must be verifiable.
- Premium UI craft standard (calm, typography-led, whitespace, subtle motion).
- Plain-language copy law: what it says → why it matters → what to do next.
- Privacy-by-design: offline-first, data minimisation.
- Stability anchors: CPE 1.0 and NCP 1.0.
- No scope creep in v0.1.

## Working rules
- Full-file rewrites only if an existing file must be edited; keep rewrites minimal.
- Minimal diff: change only what is required for the task.
- Always run verification before finishing: `./tool/verify.sh`.

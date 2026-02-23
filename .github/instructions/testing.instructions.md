---
applyTo: "**/*test*,**/test/**,**/integration_test/**"
---

# Testing Guide (Client)

Follows the [cross-repo testing strategy](../../.github/instructions/testing.instructions.md) — see that doc for tier definitions (unit / integration / e2e), conventions, and rationale. This doc covers client-specific details only.

## Stack

- **Framework**: `flutter test` (Dart test runner), Playwright Test (web E2E + axe-core a11y)
- **Language**: Dart, TypeScript (Playwright specs)
- **Unit/widget tests**: `test/` directory
- **Integration tests**: `integration_test/` (Flutter, not in CI), `e2e/scripts/` (Playwright, CI via `e2e-tests.yml`)

## Current State

- **Unit tests**: Dart tests in `test/` and `test/pangea/` — model parsing, schema validation, data transforms
- **Integration tests**: Two kinds, both integration-tier (only use Matrix auth, an internal service):
  - **Playwright** (`e2e/scripts/`): Automated specs against Flutter web on staging. Login flow and axe-core WCAG 2.1 AA accessibility audits pass. More flow coverage in progress. Runs in CI post-deploy, nightly, and on manual dispatch. ⚠️ **Not yet merged** — infrastructure is in draft [PR #5665](https://github.com/pangeachat/client/pull/5665). See [authoring-playwright-and-axe-tests.instructions.md](authoring-playwright-and-axe-tests.instructions.md) for conventions and [run-playwright-and-axe-local.instructions.md](run-playwright-and-axe-local.instructions.md) for local setup.
  - **Flutter** (`integration_test/app_test.dart`): Exists but not run in CI.
- **E2E tests**: None. No tests currently call third-party paid APIs (LLMs, Google TTS/STT, etc.)

## CI

- `flutter test` runs on every PR via `integrate.yaml` — discovers all tests in `test/`
- `e2e-tests.yml` runs Playwright specs against staging in three modes: **smoke** (login only, manual), **diff** (post-deploy, tests matching changed files via `trigger-map.json`), **full** (nightly 6am UTC + manual). Failures on post-deploy runs comment on the triggering PR.

## Commands

```bash
# Unit/widget tests (Dart)
flutter test                           # Run all
flutter test test/pangea/              # Run only Pangea tests
flutter test --name "test description" # Run a specific test by name

# Playwright integration tests (web)
npm install && npx playwright install chromium           # One-time setup
npx playwright test --config e2e/playwright.config.ts    # Run all (login + a11y)
npx playwright test e2e/scripts/login.spec.ts --config e2e/playwright.config.ts  # Single spec
BASE_URL=https://app.staging.pangea.chat npx playwright test --config e2e/playwright.config.ts  # Against staging
```

## Manual Testing

- **Device testing**: `flutter run` on physical device or emulator for full app flows
- **Playwright MCP**: Interactive browser exploration of the Flutter web build via Playwright MCP tools. Uses accessibility snapshots (`browser_snapshot`) to interact with Flutter's CanvasKit-rendered UI. Useful for authoring new specs and debugging semantics gaps. See [playwright-testing.instructions.md](playwright-testing.instructions.md) for the MCP interaction guide (login flow, navigation, accessibility enabling, tips)

## Future Work

_(No linked issues yet.)_

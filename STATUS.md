# Status

## 2026-07-28

### Completed

- **Web Push notifications** (PR #11) — self-hosted Sygnal push gateway; works on iPhone PWA (pushkey = p256dh).
- **Unverified-device badge** (PR #10) — replaced snack bar with a badge on the settings gear.
- **Exact dashboard palette** (PR #9) — pinned Schellout preset to the exact dashboard colors, following vermillion theme match (PR #8).
- **Settings UX** (PRs #6, #7) — settings gear in navigation rail and Cmd+, shortcut.
- **Web deploy tooling** (PRs #4, #5) — deploy script with guard against missing prepare-web artifacts.
- **Fork setup** (PRs #1–#3) — rebranded as Schellout Chat, Flutter 3.44.7 via fvm, macOS build without upstream signing, named theme presets, keep-alive on window close.

### In progress

- Nothing actively in flight; recent PRs are merged.

### Blockers

- None.

### Next steps

- Verify push notification reliability over time on iPhone PWA (background delivery, re-subscription after key rotation).
- Consider macOS/desktop native notification support to match web push.
- Keep fork synced with upstream (last upstream merge: krille/follow-up-26-07).

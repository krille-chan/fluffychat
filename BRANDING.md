# Schellout Chat — fork divergence inventory

Fork of [krille-chan/fluffychat](https://github.com/krille-chan/fluffychat) (AGPL-3.0-or-later).
This file lists every file that diverges from upstream. When merging upstream
(`git fetch upstream && git merge upstream/main`), conflicts should only appear here.

## Modified upstream files

| File | Divergence |
|---|---|
| `.gitignore` | added `.fvm/` |
| `lib/config/setting_keys.dart` | defaults: `applicationName` → Schellout Chat, `defaultHomeserver` → matrix.schellout.com, `colorSchemeSeedInt` → `0xFF6A3DE8` |
| `lib/config/app_config.dart` | `sourceCodeUrl`, `supportUrl`, `newIssueUrl` → this fork |
| `macos/Runner/Configs/AppInfo.xcconfig` | `PRODUCT_NAME` → Schellout Chat; `PRODUCT_BUNDLE_IDENTIFIER` → `com.schellout.chat` (Apple refuses registering upstream's ID to another team); copyright keeps FluffyChat attribution |
| `macos/Runner.xcodeproj/project.pbxproj` | `PRODUCT_NAME`/`CFBundleDisplayName` → Schellout Chat; `DEVELOPMENT_TEAM` → ZK3SQCHLR5 (keychain entitlements require real dev signing; ad-hoc fails) |
| `macos/Runner/Base.lproj/MainMenu.xib` | literal `APP_NAME` placeholders → Schellout Chat |
| `web/index.html` | title/meta → Schellout Chat |
| `web/manifest.json` | PWA name/short_name/theme_color/description |
| `macos/.../AppIcon.appiconset/*.png` | placeholder "S" icon (binary swap, same filenames) |
| `web/favicon.png`, `web/icons/*.png` | placeholder "S" icon |
| `assets/logo/mini/logo_mini.png`, `logo_mono_mini.png` | placeholder "S" icon (in-app logo: About/intro/login/lock screens) |

## New files (never conflict)

- `.fvmrc` — pins Flutter per upstream `.tool_versions.yaml`
- `web/config.json` — web runtime config (name, homeserver, seed color)
- `BRANDING.md` — this file

## Deliberately NOT changed

- `pubspec.yaml` `name: fluffychat` (every import is `package:fluffychat/...`)
- Bundle IDs (`im.fluffychat.*`), URL schemes, push notification IDs
- l10n `.arb` strings
- `chat.fluffy.*` shared-preference storage keys

## Upstream merge routine

1. `git fetch upstream && git merge upstream/main` (on a branch, at upstream release tags)
2. Resolve conflicts using the table above
3. `flutter pub get && flutter analyze`
4. `flutter build macos --debug && flutter build web`
5. Manual check: Enter-to-send, theme presets, app name in menu bar

Check the relevant `.github/instructions/` doc before and after coding. If it doesn't exist, create it with the user first. Follow [instructions-authoring.instructions.md](../../.github/instructions/instructions-authoring.instructions.md) for doc standards.

# client - Flutter/Dart Language Learning Chat App

## Tech Stack
- **Framework**: Flutter (SDK ≥3.0), Dart
- **Base**: Fork of FluffyChat (package name `fluffychat`)
- **Protocol**: Matrix Client-Server API via `matrix` Dart SDK
- **Subscriptions**: RevenueCat
- **Backend**: 2-step-choreographer (FastAPI) via `PApiUrls`
- **Error Tracking**: Sentry
- **Routing**: GoRouter

## Quick Reference

### Project Structure
- `lib/pages/`, `lib/widgets/`, `lib/utils/`, `lib/config/` — FluffyChat base code
- `lib/pangea/` — **All Pangea language-learning code** (~30 feature modules)
- `pangea_packages/` — Shared isolate packages
- Pangea modifications in FluffyChat files marked with `// #Pangea` ... `// Pangea#`

### Key Files
- **Entry point**: `lib/main.dart`
- **Root state**: `lib/widgets/matrix.dart` (`MatrixState`)
- **Pangea controller**: `lib/pangea/common/controllers/pangea_controller.dart`
- **Routes**: `lib/config/routes.dart`
- **API URLs**: `lib/pangea/common/network/urls.dart`
- **HTTP client**: `lib/pangea/common/network/requests.dart`
- **Environment**: `lib/pangea/common/config/environment.dart` (reads `.env` / `config.sample.json`)
- **Event types**: `lib/pangea/events/constants/pangea_event_types.dart`
- **Choreographer**: `lib/pangea/choreographer/choreographer.dart`

### Conventions
- Package imports use `package:fluffychat/...`
- Feature modules follow pattern: `models/`, `repo/` (API calls), `widgets/`, `utils/`, `constants/`
- API repo files pair with request/response models (e.g., `igc_repo.dart` + `igc_request_model.dart` + `igc_response_model.dart`)
- Controllers extend `ChangeNotifier` or use `BaseController<T>` (stream-based)


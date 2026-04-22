# DSL Messaging System

A system for rendering structured UI dynamically from Matrix events using a Domain Specific Language (DSL).

---

## Overview

Instead of treating messages as plain text, events can carry a `com.jaino.dsl` payload which is:

1. Parsed into a `DSLMessage`
2. Resolved via `DSLRegistry`
3. Rendered by a `DSLHandler`
4. Returned as a Flutter `Widget`

---

## Architecture

```
Matrix Event
   ↓
EventDSLRuntime (extension)
   ↓
DSLMessage (parsed)
   ↓
DSLRegistry (handler lookup)
   ↓
DSLHandler (render logic)
   ↓
DSLRenderResult (UI output)
   ↓
Flutter Widget
```

---

## DSL Event Format

Each Matrix event may include a `com.jaino.dsl` field:

```json
{
  "msgtype": "m.text",
  "body": "Fallback text",
  "com.jaino.dsl": {
    "v": 1,
    "type": "menu",
    "data": {
      "title": "Pizza Menu"
    }
  }
}
```

| Field  | Type     | Required | Description              |
|--------|----------|----------|--------------------------|
| `v`    | `int`    | ✅        | DSL schema version       |
| `type` | `String` | ✅        | Handler type identifier  |
| `data` | `Map`    | ✅        | Payload for rendering    |

---

## Core Components

### DSLMessage

Represents parsed DSL data.

**Responsibilities:**
- Validate structure
- Provide typed access to data

```dart
final title = msg.get<String>('title');
```

> Throws on invalid structure. Safely wrapped by the extension so the UI won't crash.

---

### DSLHandler

Abstract class defining the rendering contract.

```dart
abstract class DSLHandler {
  String get type;
  int get version;

  bool canHandle(DSLMessage msg);

  DSLRenderResult render(Event event, DSLMessage msg);
}
```

**Responsibilities:**
- Match `type` and `version`
- Convert DSL data into a UI widget

---

### DSLRegistry

Central registry for all handlers.

**Registering a handler:**
```dart
DSLRegistry.instance.register(MyHandler());
```

**Resolving a handler:**
```dart
DSLRegistry.instance.tryResolve(msg);
```

**Behavior:**
- Prevents duplicate `(type + version)` registrations
- Supports both safe and strict resolution modes

---

### DSLRenderResult

The output of a handler render call.

```dart
class DSLRenderResult {
  final Widget widget;
  final DSLAction? action;
  final Map<String, dynamic>? payload;
}
```

| Field     | Description                          |
|-----------|--------------------------------------|
| `widget`  | The final UI widget to render        |
| `action`  | Optional interaction intent          |
| `payload` | Additional data to pass with action  |

---

### DSLAction

Defines possible UI interaction types.

```dart
enum DSLAction {
  openMenu,
  openInvoice,
  openCart,
  openPayment,
  none,
}
```

Used for navigation, flows, or external triggers.

---

### EventDSLRuntime (Extension)

Adds DSL support directly to Matrix `Event` objects.

| API                      | Description                              |
|--------------------------|------------------------------------------|
| `event.hasDSL`           | Check whether the event contains DSL     |
| `event.dsl`              | Parse and return the `DSLMessage`        |
| `event.buildDSLWidget()` | Build the widget safely (no throws)      |
| `event.renderDSL()`      | Get the full `DSLRenderResult`           |

> Never throws. Returns fallback UI on failure.

---

## Rendering Flow

```dart
final dslWidget = event.buildDSLWidget();

if (dslWidget != null) {
  return dslWidget;
}

return Text(event.body ?? '');
```

---

## Adding a New DSL Type

### Step 1 — Create a Handler

```dart
class MenuHandler extends DSLHandler {
  @override
  String get type => 'menu';

  @override
  int get version => 1;

  @override
  DSLRenderResult render(Event event, DSLMessage msg) {
    final title = msg.get<String>('title') ?? '';

    return DSLRenderResult(
      widget: Text(title),
    );
  }
}
```

### Step 2 — Register the Handler

```dart
DSLRegistry.instance.register(MenuHandler());
```

### Step 3 — Send a DSL Message

```json
{
  "com.jaino.dsl": {
    "v": 1,
    "type": "menu",
    "data": {
      "title": "My Menu"
    }
  }
}
```

---

## Error Handling

| Scenario              | Behavior                         |
|-----------------------|----------------------------------|
| Invalid DSL format    | Silently ignored                 |
| No handler found      | `"Unsupported DSL message"`      |
| Render failure        | `"Failed to render DSL"`         |
| Missing fields        | Handled gracefully via `get<T>()` |

---

## Versioning

Versioning is **strict**. A handler only matches when both conditions are met:

```
type == msg.type && version == msg.version
```

**Rule:** Never modify an existing version. Always create a new handler for a new version.

```
type: menu
  v1 → MenuHandlerV1
  v2 → MenuHandlerV2
```

---

## Limitations

- No async rendering (by design)
- No built-in state management
- No built-in navigation handling
- UI must be fully defined within the handler

---

## Design Principles

| Principle            | Description                                          |
|----------------------|------------------------------------------------------|
| ✅ Safe by default    | No crashes in the UI layer                           |
| ✅ Explicit rendering | Handlers return actual, concrete widgets             |
| ✅ Version controlled | Prevents breaking messages from older schema versions |
| ✅ Extensible         | Add new types without touching core logic            |

---

## Debugging

```dart
DSLRegistry.instance.dumpRegistered();
```

Useful when:
- A handler is not being found
- A version mismatch is suspected
- A handler was not registered (the classic mistake)

---

## Recommended Next Steps

- [ ] Implement real handlers (`menu`, `invoice`, etc.)
- [ ] Add a centralized action handling layer
- [ ] Standardize DSL payload schemas
- [ ] Add structured logging
- [ ] Introduce analytics (optional)
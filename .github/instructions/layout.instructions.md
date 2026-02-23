# Client Layout System

Applies to: `lib/config/themes.dart`, `lib/widgets/layouts/**`, `lib/pangea/spaces/space_navigation_column.dart`, `lib/widgets/navigation_rail.dart`, `lib/config/routes.dart`

## Overview

The app uses a responsive two-column layout inherited from FluffyChat. On wide screens (desktop/tablet landscape), both columns are visible simultaneously. On narrow screens (mobile), only one column shows at a time and GoRouter handles full-screen navigation between them.

---

## Breakpoints

All breakpoint logic lives in [`FluffyThemes`](../../lib/config/themes.dart):

| Mode | Condition | Result |
|------|-----------|--------|
| **Column mode** (two-column) | `width > columnWidth * 2 + navRailWidth` = **~833px** | Nav rail + left column + right column all visible |
| **Single-column** (mobile) | `width ≤ 833px` | One screen at a time; nav rail may or may not show depending on route |
| **Three-column** | `width > columnWidth * 3.5` = **~1330px** | Used sparingly (chat search panel, toolbar positioning) |

Constants:
- `columnWidth` = **380px** — width of the left column (chat list, analytics, settings)
- `navRailWidth` = **72px** (Pangea override; upstream FluffyChat uses 80px)

---

## Layout Structure

### Wide Screen (column mode)

```
┌─────────┬──────────────────┬──────────────────────────────┐
│ Nav Rail │   Left Column    │        Right Column          │
│  (72px)  │    (380px)       │     (remaining width)        │
│          │                  │                              │
│ [Avatar] │  Chat list       │  Chat / Settings detail /    │
│ [Chats]  │  or Analytics    │  Room / Empty page           │
│ [Space1] │  or Settings     │                              │
│ [Space2] │  or Course bear  │                              │
│ [Course] │                  │                              │
│ [Gear]   │                  │                              │
└─────────┴──────────────────┴──────────────────────────────┘
```

### Narrow Screen (mobile)

```
┌──────────────────────────────┐
│ [Nav Rail]  (smaller, 64px)  │  ← shown on some screens
├──────────────────────────────┤
│                              │
│   Full-screen view           │
│   (chat list OR chat OR      │
│    settings OR analytics)    │
│                              │
└──────────────────────────────┘
```

On mobile, the nav rail visibility is conditional — it shows on "root" screens (chat list, analytics, settings, course finder) but hides when you're inside a chat room, a specific space, or certain creation flows (`newcourse`, `:construct`). This logic is in [`TwoColumnLayout.build()`](../../lib/widgets/layouts/two_column_layout.dart).

---

## Key Components

### [`TwoColumnLayout`](../../lib/widgets/layouts/two_column_layout.dart)

The GoRouter `ShellRoute` builder wraps **all** authenticated routes in `TwoColumnLayout`. This widget is always rendered — it's not conditionally swapped out. It uses a `Stack` with `Positioned.fill`:

- **`SpaceNavigationColumn`** is positioned on the left (nav rail + optional left column)
- **`sideView`** (the GoRouter child) fills the remaining space to the right

The `columnWidth` calculation determines the left inset:
- Column mode: `navRailWidth + 1 + columnWidth + 1` ≈ **454px**
- Mobile with rail: `navRailWidth + 1` ≈ **73px**
- Mobile without rail: **0px** (sideView fills the entire screen)

### [`SpaceNavigationColumn`](../../lib/pangea/spaces/space_navigation_column.dart)

A `StatefulWidget` that composes:

1. **Left column content** (`_MainView`) — only rendered in column mode. Shows different content based on the current route path:
   - Default / no special path → `ChatList` (with `activeChat` and `activeSpace` params)
   - Path contains `analytics` → `ConstructAnalyticsView` or `LevelAnalyticsDetailsContent` or `ActivityArchive`
   - Path contains `settings` → `Settings`
   - Path contains `course` → decorative bear image (placeholder)

2. **`SpacesNavigationRail`** — the narrow icon column. Shows when `showNavRail` is true.

The column has hover-expand behavior (desktop): hovering for 200ms expands the rail to show labels next to icons (~250px wide), collapsing when the mouse leaves.

### [`SpacesNavigationRail`](../../lib/widgets/navigation_rail.dart)

The vertical icon strip. Items top-to-bottom:

1. **User avatar** → navigates to analytics
2. **Chat icon** → navigates to `/rooms` (all chats)
3. **Space icons** — one per joined space, rendered with `MapClipper` shape. Tapping navigates to the space's chat list view
4. **Course finder icon** → navigates to `/rooms/course`
5. **Settings gear** → navigates to `/rooms/settings`

All navigation uses `context.go()` (GoRouter declarative navigation).

### [`MaxWidthBody`](../../lib/widgets/layouts/max_width_body.dart)

A utility wrapper that constrains content to a max width (default 600px) and centers it on wide screens. Used by settings pages, forms, and other non-chat content to prevent stretching. On narrow screens, the child fills the available width with no extra padding.

---

## Routing & Column Interaction

All authenticated routes live under a single `ShellRoute` that renders `TwoColumnLayout`. The GoRouter child (the page being navigated to) always appears in the **right column** on wide screens, or as the **full screen** on mobile.

Key routing patterns:

- **`/rooms`** — In column mode, left column shows `ChatList`, right shows `EmptyPage` (bear image). On mobile, shows `ChatList` full-screen.
- **`/rooms/:roomid`** — In column mode, left column shows `ChatList` with `activeChat` highlighted, right shows `ChatPage`. On mobile, shows `ChatPage` full-screen (back button returns to chat list).
- **`/rooms/spaces/:spaceid`** — Similar pattern with the space's details in the right column.
- **`/rooms/analytics`** — In column mode, left column shows analytics view, right shows `EmptyAnalyticsPage`. On mobile, shows analytics full-screen.
- **`/rooms/settings`** — In column mode, left column shows `Settings`, right shows settings sub-page or empty.

The left column content is determined by `_MainView` reading `GoRouterState.fullPath`, not by the route tree itself. This means the left column "reacts" to route changes but isn't directly part of the GoRouter page stack.

---

## Mobile-Specific Behavior

On mobile (single-column):
- The nav rail shows a **smaller** icon size (64px width vs 72px)
- The nav rail **hides** when inside a room or during certain flows (determined by `TwoColumnLayout`'s `showNavRail` logic)
- Navigation between "list" and "detail" views uses GoRouter's standard push/pop, appearing as full-screen transitions
- `PopScope` in `ChatListView` handles Android back button: if inside a space, goes back to all chats; if in search mode, cancels search
- App bar height is **56px** on mobile vs **72px** in column mode
- Snackbars are standard floating (not width-constrained) on mobile

---

## Theme Adaptations

`FluffyThemes.buildTheme()` adapts several theme properties based on `isColumnMode`:
- **App bar**: taller (72px vs 56px), with shadow on desktop
- **Snackbar**: width-constrained to `columnWidth * 1.5` (570px) on desktop, unconstrained on mobile
- **Actions padding**: extra horizontal padding on desktop app bars

---

## Future Work

_(No linked issues yet.)_

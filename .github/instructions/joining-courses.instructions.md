---
applyTo: "lib/pangea/join_codes/**,lib/pangea/chat_list/**,lib/pangea/course_creation/**,lib/pangea/spaces/**,lib/pages/chat_list/**,lib/utils/url_launcher.dart,lib/config/routes.dart"
---

# Joining Courses — Client Design

How users join courses (Matrix spaces) through three routes: class link, class code, and knock-accept.

- **Synapse module cleanup**: [synapse-pangea-chat PR #21](https://github.com/pangeachat/synapse-pangea-chat/pull/21)
- **Course plans**: [course-plans.instructions.md](course-plans.instructions.md)

---

## Join Routes Overview

| Route            | Entry Point          | Mechanism                                                  | User Interaction                  |
| ---------------- | -------------------- | ---------------------------------------------------------- | --------------------------------- |
| **Class link**   | Deep link URL        | Extracts class code from URL → knock_with_code → join      | None after click (auto-join)      |
| **Class code**   | Manual text input    | knock_with_code → join                                     | Enter code only                   |
| **Knock-accept** | "Ask to Join" button | Matrix knock → admin approves → invite → client auto-joins | Knock button; then wait for admin |

All three routes converge on the user becoming a `Membership.join` member of the course space. Child rooms (announcements, introductions, activity chats) are joined separately afterward.

---

## Route 1 — Class Link

**URL format**: `https://pangea.chat/#/join_with_link?classcode=XYZ`

1. User clicks link → GoRouter navigates to `/join_with_link`
2. Class code is saved to local storage (`SpaceCodeRepo`)
3. Redirect to `/home`
4. On home load, `joinCachedSpaceCode()` fires the knock_with_code + join flow (same as Route 2)

**Pre-login persistence**: If not logged in, the code persists on disk. After account creation, `joinCachedSpaceCode()` auto-joins.

**matrix.to links**: Standard Matrix links (`https://matrix.to/#/...`) go through a separate path. For knock-only rooms, this shows the public room bottom sheet with a code field and "Ask to Join" button.

---

## Route 2 — Class Code

Three UI entry points (onboarding, in-app code page, public room bottom sheet) all converge on `SpaceCodeController.joinSpaceWithCode()`:

1. Save code as `recentCode` (used for invite dedup in Route 3)
2. `POST /_synapse/client/pangea/v1/knock_with_code` — Pangea-custom Synapse endpoint that validates the access code and invites the user
3. Response contains `{ roomIds, alreadyJoined, rateLimited }`
4. `joinRoomById(spaceId)` → wait for sync → navigate to space

This is NOT a standard Matrix knock — the Synapse module handles the invite directly.

---

## Route 3 — Knock-Accept

### User knocks

User finds the course in one of three places:

- **Public course preview** — linked from `matrix.to` or direct room ID navigation. Shows a "Join" button that becomes a knock if the room's join rule is `knock`.
- **Public room bottom sheet** — search results for public rooms. For knock rooms, shows a code field and an "Ask to Join" button side by side. TODO: change to "Knock" for consistency.
- **Public room dialog** — a simpler variant of the bottom sheet used in some navigation paths. Button label changes to "Knock" for knock-rule rooms.

User taps the knock button → standard Matrix `knockRoom()` call → confirmation dialog ("You have knocked") → wait for admin.

### Admin approves

Admin notices the knock in one of three places:

- **Notification badge** on the space icon in the navigation bar. TODO: need to add this.
- **Chat list** for that space — the knocking user appears as a pending entry. TODO: make this a bit more attention-grabbing.
- **Member list** (room participants page) — knocking users are sorted below joined members, labeled "Knocking."

Admin taps the knocking user → popup menu shows "Approve" (only visible for `Membership.knock`) → `room.invite(userId)`.

**Analytics room knocks** follow the same mechanism — admins request access to a student's analytics room by knocking, and the student's client auto-accepts when the invite arrives.

---

## Invite Handling

When an invite arrives via `/sync`, the sync listener routes it by room type:

| Room type                      | Action                                            |
| ------------------------------ | ------------------------------------------------- |
| **Space**                      | Evaluate priority rules (below)                   |
| **Analytics room**             | Auto-join immediately                             |
| **Previously knocked room**    | Auto-join immediately                             |
| **Other**                      | No sync-time action; handled when user taps it    |

### Space invite priority

When a space invite arrives, the client evaluates in order:

1. **Child of joined parent** → auto-join (no prompt)
2. **Code just inputted** → skip (Route 2 is handling it)
3. **Previously knocked** → auto-join (no prompt)
4. **Otherwise** → show accept/decline dialog

### KnockTracker

The server-side `auto_accept_invite` module was removed because it crashed Synapse ([PR #21](https://github.com/pangeachat/synapse-pangea-chat/pull/21)). Auto-accept now lives client-side via [`KnockTracker`](../../lib/pangea/join_codes/knock_tracker.dart).

Matrix `/sync` invites use `StrippedStateEvent`, which lacks `unsigned` / `prev_content` — so the client can't tell from the invite alone whether it previously knocked. `KnockTracker` solves this by recording each knocked room ID in Matrix account data (`org.pangea.knocked_rooms`). When an invite arrives for a tracked room, the client auto-joins and clears the record.

Account data is used so the state survives reinstall, logout, and syncs across devices. Only the user can initiate a knock, so an invite for a tracked room is always a legitimate approval. Applies to both spaces and non-space rooms.

### All auto-join cases

Every case where `room.join()` is called without explicit user confirmation:

| Condition                                                | Trigger                           |
| -------------------------------------------------------- | --------------------------------- |
| Navigating to an invited room's chat view                | Building the widget               |
| Invited space is a child of a joined parent              | Space invite via sync             |
| Tapping a left space in the list                         | User tap                          |
| Analytics room invite                                    | Always auto-joined                |
| Default chats in a course (announcements, introductions) | Viewing the course                |
| knock_with_code succeeded                                | Code entry flow                   |
| User previously knocked on the room                      | Invite received for a prior knock |

---

## Future Work


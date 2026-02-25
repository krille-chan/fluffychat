---
applyTo: "lib/pangea/**,lib/pages/**,lib/widgets/**"
---

# Playwright Testing — Flutter Web Client

How to interact with the Pangea Chat Flutter web app using the Playwright MCP tools.

## Critical: Flutter Web Uses CanvasKit

Flutter web renders to a `<canvas>` element, not DOM nodes. Standard Playwright selectors (`page.getByText()`, `page.locator()`) **will not find Flutter widgets**. You must:

1. **Enable accessibility** — Click the "Enable accessibility" button that Flutter overlays on the page. This activates the semantics tree, which exposes widget labels to Playwright's accessibility snapshot.
2. **Use `browser_snapshot`** — After enabling accessibility, use `browser_snapshot` to see the semantic tree. This returns ARIA labels and roles that map to Flutter widget `Semantics` / `Tooltip` / button labels.
3. **Use `browser_click` with `ref`** — Click elements by their `ref` from the snapshot, not by CSS selectors.
4. **Use `browser_type` with `ref`** — Type into text fields by their `ref` from the snapshot.
5. **Use `browser_take_screenshot`** — When the semantic tree is insufficient (e.g. visual layout issues, canvas rendering bugs), take a screenshot to see what's actually on screen.

### Enable Accessibility (First Step After Navigation)

Flutter's "Enable accessibility" button is placed **off-screen** by default and is often unreachable via normal click due to scroll/viewport issues. **Use `browser_run_code` to force-enable it via JavaScript:**

```js
async (page) => {
  // Flutter places the semantics placeholder off-screen. Force-click it via JS.
  await page.evaluate(() => {
    const btn = document.querySelector('flt-semantics-placeholder')
      || document.querySelector('[aria-label="Enable accessibility"]');
    if (btn) btn.click();
  });
}
```

Then wait 2–3 seconds and take a snapshot — you should now see Flutter widget labels.

**Do not** try to find and click the button via `browser_snapshot` + `browser_click` — the button is intentionally positioned outside the viewport and Playwright cannot scroll to it reliably.

## Login Flow

### Prerequisites

- Flutter web app running locally (e.g. `flutter run -d chrome` on some port)
- Staging test credentials from `client/.env` (see [matrix-auth.instructions.md](matrix-auth.instructions.md))

### Step-by-Step Login

1. **Navigate** to the app URL (e.g. `http://localhost:<port>`)
2. **Enable accessibility** (see above)
3. **Snapshot** — you should see "Start" and "Login to my account" buttons
4. **Click "Login to my account"** → navigates to `/home/login`
5. **Snapshot** — you should see "Sign in with Apple", "Sign in with Google", "Email" options
6. **Click "Email"** → navigates to `/home/login/email`
7. **Snapshot** — you should see "Username or Email" and "Password" text fields, and a "Login" button
8. **Type** the username (just the localpart, e.g. `wykuji`, not the full `@wykuji:staging.pangea.chat`) into the username field
9. **Type** the password into the password field
10. **Click "Login"** button
11. **Wait** 5–10 seconds for sync to complete
12. **Snapshot** — you should now be on the chat list (`/rooms`)

### Navigate to a Room

After login, navigate to a specific room by URL:

```
http://localhost:<port>/#/rooms/<room_id>
```

Or find the room in the chat list via snapshot and click it.

## Route Map

| Route | What You'll See |
|---|---|
| `/#/home` | Landing page: logo, "Start", "Login to my account" |
| `/#/home/login` | Login options: Apple, Google, Email |
| `/#/home/login/email` | Username + Password form |
| `/#/rooms` | Chat list (requires auth) |
| `/#/rooms/<room_id>` | Chat room with message input |

## Interacting With Chat

Once in a room:

1. **Snapshot** to find the text input field and other UI elements
2. **Type** a message into the input field
3. **Wait** for writing assistance to trigger (debounce ~1.5s after typing stops)
4. **Snapshot** to see the assistance ring, highlighted text, and any span cards
5. **Click** highlighted text to open the span card
6. **Screenshot** to visually inspect the ring segments, highlight colors, and span card layout

### What to Look For

| Element | Semantic Label / Visual Cue |
|---|---|
| Text input | Input field in the bottom bar |
| Assistance ring | Pangea logo icon with colored ring segments |
| Send button | Right-most button in input bar |
| Span card | Overlay popup with category title, bot face, choices |
| Highlighted text | Background color behind matched text in the input |

## Tips

- **Snapshots are better than screenshots** for finding interactive elements and their `ref` IDs.
- **Screenshots are better than snapshots** for verifying visual styling (colors, layout, animations).
- **Wait between actions** — Flutter web can be slow, especially during initial load and sync. Use `browser_wait_for` with 2–5 second delays after navigation or login.
- **Hash routing** — all Flutter routes use `/#/` prefix. Direct navigation works.
- **Session is ephemeral** — the Playwright browser doesn't share the user's Chrome session. You must log in each time.

## Limitations

- SSO login (Apple/Google) cannot be automated — use email/password login only.
- CanvasKit rendering means pixel-level visual assertions are screenshot-based, not DOM-based.
- Some widgets may not have semantic labels — file a bug if a key interaction point is invisible to the accessibility snapshot.
- Animations (ring spin, card transitions) won't appear in snapshots — use screenshots or video for those.

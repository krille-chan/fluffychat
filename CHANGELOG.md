## v1.19.0
FluffyChat v1.19.0 features an improved design for message bubbles and a lot of fixes under the hood.

- build: Update matrix dart sdk (Krille)
- build: Update to flutter 3.19.5 (krille-chan)
- chore: Add missing command hints (krille-chan)
- chore: Add pagekey to custom page builder (Krille)
- chore: Adjust design of typing indicator (Krille)
- chore: Adjust ticker of notifications for Android (Krille)
- chore: Calc blurhash in other thread (Krille)
- chore: Mark muted unread rooms with bold text (krille-chan)
- chore: More minimal matrix pill (Krille)
- chore: Try out CupertinoPage instead of custom transition in router (krille-chan)
- ci: add a license compliance check (lauren n. liberda)
- design: Connect bubbles from same sender (krille-chan)
- design: Display images in correct ratio in timeline (krille-chan)
- design: Make appbar in material you design for mobile mode (krille-chan)
- design: New sticker picker next to emoji picker (krille-chan)
- design: Nicer QR Code design (krille-chan)
- design: Nicer reactions design with size animations (Krille)
- feat: Add insert content via gboard (krille-chan)
- feat: Reply with one button in desktop (krille-chan)
- fix: Do not sync in background mode (krille-chan)
- fix: FluffyChat should assume m.change_password capabilitiy is supported if not present per spec (krille-chan)
- fix: never use root navigator for bottom sheets (The one with the braid)
- fix: Remove pantalaimon message with normal error message (krille-chan)
- fix: Search in spaces view (krille-chan)
- fix: Set read marker on web (Krille)
- fix: Point to correct path for auth.html so completing sso login flow no longer 404s (Gavin Mogan)
- refactor: Better logic for removing outdated notifications (Krille)
- refactor: Enhance logic when to mark room as read (krille-chan)
- refactor: Remove old aliases workaround (Krille)
- refactor: Sticker widget code (Krille)
- refactor: Use dart blurhash (Krille)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Interlingua) (Software In Interlingua)

## v1.18.0
- feat: Add speed button for audioplayer (krille-chan)
- feat: enhanced send video functionality by adding toggle send original (Mubeen Rizvi)
- feat: add dialog to hide presence list with long-press (Marcus Hoffmann)
- feat: Add notification shortcuts to android (krille-chan)
- feat: make showing user presence info optional (Marcus Hoffmann)
- feat: Open chat on shortcut click on android (krille-chan)
- fix: BuildContext crash when joining room (krille-chan)
- fix: Export session (krille-chan)
- fix: Notifications open sometimes automatically on android (krille-chan)
- fix: Open room after join (krille-chan)
- fix: Open room by notification happened multiple times (krille-chan)
- fix: Open room links with event id (krille-chan)
- fix: properly initialize hideUnimportantStateEvents setting (Marcus Hoffmann)
- fix: Remove status msg not changeable from old cache (krille-chan)
- fix: use correct icons for chat pin/unpin (Marcus Hoffmann)
- fix: use correct icons for mark read/unread action (Marcus Hoffmann)
- build: Update Linux build files (krille-chan)
- build: Update to Flutter 3.19.1 (Krille)
- chore: Add more information to Person object in android notifications (krille-chan)
- chore: Thumbnail follow up for notifications (Krille)
- refactor: Better download UX with file picker for android and iOS (krille-chan)
- refactor: Use hashcode instead of string to id workaround for notifications (Krille)
- Added translation using Weblate (Belarusian) (kopatych)
- Added translation using Weblate (Interlingua) (Software In Interlingua)
- Translated using Weblate (Arabic) (Rex_sa)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Chinese (Simplified)) (Poesty Li)
- Translated using Weblate (Chinese (Simplified)) (大王叫我来巡山)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (German) (Benjamin Wagner)
- Translated using Weblate (Greek) (Benjamin Wagner)
- Translated using Weblate (Russian) (Benjamin Wagner)
- Translated using Weblate (Russian) (v1s7)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- Translated using Weblate (Ukrainian) (Сергій)

## v1.17.3
- feat: New account data based wallpaper feature (Krille)
- build: Update dependencies (Krille)
- build: Update flutter to 3.16.9 (Krille)
- build: Update matrix dart sdk to 0.25.7 (Krille)
- build: Update minor versions (Krille)
- chore: Adjust status msg design (krille-chan)
- chore: Improved error handling for recovery key (Krille)
- chore: Make stickers smaller (Krille)
- chore: Wait for device keys before ask bootstrap (Krille)
- fix: Missing null check in public room bottom sheet (Krille)
- fix: onDragDone crashes when no files found (Krille)
- fix: Render tg-forward html tags (Krille)
- fix: Use HapticFeedback.selectionClick() for long press on message (Krille)
- fix: whitespaces sometimes encoded in html message (Krille)
- fix: Share invite links of public rooms (Krille)

## v1.17.2
Another minor bugfix release which also implements private read receipts.

- feat: Implement private read receipts (krille-chan)
- feat: Join room by alias by tpying alias in searchbar (krille-chan)
- fix: Add cancel button to key request dialog (Krille)
- fix: Encode component for links correctly (Krille)
- fix: Forward arbitrary message content (krille-chan)
- fix: Open publicroombottomsheet by alias (krille-chan)
- docs: Add noto animated emojis link (krille-chan)
- docs: New website (krille-chan)
- build: Do not load emojis at initial start on web (krille-chan)
- build: Update flutter to 3.16.8 (krille-chan)
- build: Update sdk to 0.25.6 (Krille)
- chore: Add more explaining text for key verification (krille-chan)
- chore: Resort settings and add more description text (krille-chan)
- refactor: Dialog BuildContext (krille-chan)
- refactor: Use popupmenudivider instead of workaround (krille-chan)
- Translated using Weblate (Arabic) (Rex_sa)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Chinese (Simplified)) (Poesty Li)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (German) (nautilusx)
- Translated using Weblate (Russian) (v1s7)
- Translated using Weblate (Swedish) (Flat)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- Translated using Weblate (Ukrainian) (Сергій)

## v1.17.1
Minor bugfix release.

- build: Update matrix sdk 0.25.5 (Krille)
- build: Update to flutter 3.16.7 (Krille)
- chore: Remove vibration on iOS for long press (Krille)
- design: Better paddings in tablet mode (krille-chan)
- docs: Fix typo in readme (Krille)
- Fix dependency. missing yq when invoking setup-web. also ensure updated config.json copied in (Isaac Johnson)
- fix: text nodes with multiple links crash the timeline (Krille)
- fix: URL too long when reporting bug (Krille)
- fix: Wait for user device keys before start verification (Krille)

## v1.17.0
FluffyChat v1.17.0 refreshes the overall user experience, changes some design and fixes a lot of bugs. It also replaces the stories feature with matrix presences, introduces a new kind of database to store the messages locally and improves the performance and app stability.

- change: Remove wallpaper feature (krille-chan)
- design: Adjust login page design (krille-chan)
- design: Adjust new chat page design (Krille)
- design: Adjust reply design (krille-chan)
- design: New design for login page (krille-chan)
- feat: Add registration buttons for servers with public registration url (krille-chan)
- feat: Animate in new events in timeline (krille-chan)
- feat: Block users who sent invites (krille-chan)
- feat: Display migration notification (Krille)
- feat: Hovermenu for messages for mouse (krille-chan)
- feat: New change password page with server capabilities check (krille-chan)
- feat: Search for public spaces (krille-chan)
- feat: Try out FluffyBox 2 database (Krille)
- fix: Add 3pid email for password reset (krille-chan)
- fix: Audiomessage break app (Krille)
- fix: Cannot change send on enter on desktop (krille-chan)
- fix: Darktheme contrast fixes with primary color (krille-chan)
- fix: Join public rooms (krille-chan)
- fix: Make user admin (krille-chan)
- fix: New json url for homeserver list (krille-chan)
- fix: Open notification for invite crashes app (krille-chan)
- fix: Remove web background (Krille)
- fix: Some links not clickable in messages (Krille)
- fix: Update manual endpoints (Krille)
- fix: Web SSO (Krille)
- refactor: More stable scroll to event (krille-chan)
- refactor: Reinvite other part instead of reopen dm (Krille)
- refactor: Remove todo list feature (krille-chan)
- refactor: Remove unnecessary setState in ChatPage for better performance (krille-chan)
- refactor: Remove unused code (krille-chan)
- refactor: Remove unused localization strings and add ci check (krille-chan)
- refactor: Replace stories feature with presence status msg (Krille)
- refactor: Spaces UX improvements (krille-chan)
- Translated using Weblate (Arabic) (Rex_sa)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Chinese (Simplified)) (Poesty Li)
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (German) (Christian)
- Translated using Weblate (German) (nautilusx)
- Translated using Weblate (Hindi) (immodded)
- Translated using Weblate (Italian) (Claudio Maradonna)
- Translated using Weblate (Italian) (Timothy Redaelli)
- Translated using Weblate (Portuguese (Brazil)) (Hermógenes Oliveira)
- Translated using Weblate (Russian) (v1s7)
- Translated using Weblate (Spanish) (José Muñoz)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)

## v1.16.1
Test candidate for the new database.

## v1.16.0
- build: Set olm to 1.3.2 to fix android build (krille-chan)
- build: Update dependencies (krille-chan)
- build: Update flutter_olm (Krille)
- build: Update matrix dart sdk to 0.23.0 (Krille)
- build: Update Matrix Dart SDK to 0.24.0 (Krille)
- build: Update openssl crypto (Krille)
- build: Update to flutter 3.16.2 (krille-chan)
- build: Workaround for broken flutter secure storage on linux (krille-chan)
- chore: Add error report for incorrect recovery key (Krille)
- chore: Always show notification popup on android (krille-chan)
- chore: Do not ship unused emoji font for android and iOS (krille-chan)
- chore: Fetch cached presence (Krille)
- chore: Update pubspec.lock (Krille)
- chore: upgrade flutter to 3.16.0 (lauren n. liberda)
- docs: Fix links to GitHub (Jérémie Roquet)
- feat: Display presences in the app (krille-chan)
- feat: Enable experimental suport for dehydrated devices (Krille)
- feat: Improved UX design for new chat page (krille-chan)
- feat: New UX design for create group chat (krille-chan)
- fix: Block users (krille-chan)
- fix: Blurhash crashes on height 0 (krille-chan)
- fix: Do not hide push if app romm in foreground but is in background (krille-chan)
- fix: Do not scroll up on enter chat (Krille)
- fix: emoji import from ZIP file (The one with the braid)
- fix: Encryption dialog crashes in column mode (krille-chan)
- fix: Error widget spamming with dialogs (Krille)
- fix: fcm patch (lauren n. liberda)
- fix: Glitch in event info dialog (krille-chan)
- fix: message bubble position on desktop devices (The one with the braid)
- fix: navigating back from full screen video (Aryan Arora)
- fix: Only load first pinned event (krille-chan)
- fix: Userbottomsheet crash on some edge cases (krille-chan)
- fix: whatever happens with android native libraries since flutter 3.16 (lauren n. liberda)
- refactor: Check if app is in foreground on pushhelper (krille-chan)
- refactor: Event list (krille-chan)
- refactor: Migrate for Flutter 3.16.0 (Krille)
- refactor: Remove copy dialog before opening links (krille-chan)
- Translated using Weblate (Arabic) (Rex_sa)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Bengali) (Allan Nordhøy)
- Translated using Weblate (Bengali) (Anonymous)
- Translated using Weblate (Bengali) (Graeme Power)
- Translated using Weblate (Bengali) (Joaquim Homrighausen)
- Translated using Weblate (Bengali) (Raatty)
- Translated using Weblate (Bengali) (Sorunome)
- Translated using Weblate (Catalan) (Adolfo Jayme Barrientos)
- Translated using Weblate (Catalan) (Anonymous)
- Translated using Weblate (Catalan) (Auri B.P)
- Translated using Weblate (Catalan) (Joaquim Homrighausen)
- Translated using Weblate (Catalan) (Raatty)
- Translated using Weblate (Chinese (Simplified)) (Anonymous)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Chinese (Traditional)) (Anonymous)
- Translated using Weblate (Chinese (Traditional)) (Joaquim Homrighausen)
- Translated using Weblate (Chinese (Traditional)) (Raatty)
- Translated using Weblate (Chinese (Traditional)) (SuperSonic)
- Translated using Weblate (Croatian) (Anonymous)
- Translated using Weblate (Czech) (Anonymous)
- Translated using Weblate (Czech) (Tomkoid)
- Translated using Weblate (Esperanto) (Anonymous)
- Translated using Weblate (Esperanto) (Joaquim Homrighausen)
- Translated using Weblate (Esperanto) (Raatty)
- Translated using Weblate (Esperanto) (Tirifto)
- Translated using Weblate (Finnish) (Anonymous)
- Translated using Weblate (French) (Anonymous)
- Translated using Weblate (French) (Mæve Rey)
- Translated using Weblate (Galician) (Anonymous)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (German) (Bella)
- Translated using Weblate (German) (Christian)
- Translated using Weblate (Greek) (Anonymous)
- Translated using Weblate (Hebrew) (Anonymous)
- Translated using Weblate (Hebrew) (Joaquim Homrighausen)
- Translated using Weblate (Hebrew) (Raatty)
- Translated using Weblate (Hebrew) (Sorunome)
- Translated using Weblate (Hebrew) (y batvinik)
- Translated using Weblate (Hindi) (Anonymous)
- Translated using Weblate (Hungarian) (Anonymous)
- Translated using Weblate (Hungarian) (Joaquim Homrighausen)
- Translated using Weblate (Hungarian) (notramo)
- Translated using Weblate (Hungarian) (Raatty)
- Translated using Weblate (Indonesian) (Anonymous)
- Translated using Weblate (Irish) (Anonymous)
- Translated using Weblate (Irish) (Graeme Power)
- Translated using Weblate (Irish) (Joaquim Homrighausen)
- Translated using Weblate (Irish) (Raatty)
- Translated using Weblate (Italian) (Anonymous)
- Translated using Weblate (Italian) (J. Lavoie)
- Translated using Weblate (Italian) (Joaquim Homrighausen)
- Translated using Weblate (Italian) (Raatty)
- Translated using Weblate (Japanese) (Anonymous)
- Translated using Weblate (Japanese) (cPidx)
- Translated using Weblate (Korean) (Anonymous)
- Translated using Weblate (Korean) (Kim Tae Kyeong)
- Translated using Weblate (Korean) (Raatty)
- Translated using Weblate (Latvian) (Anonymous)
- Translated using Weblate (Lithuanian) (Anonymous)
- Translated using Weblate (Lithuanian) (Mind)
- Translated using Weblate (Norwegian Bokmål) (Allan Nordhøy)
- Translated using Weblate (Norwegian Bokmål) (Anonymous)
- Translated using Weblate (Norwegian Bokmål) (Joaquim Homrighausen)
- Translated using Weblate (Norwegian Bokmål) (Raatty)
- Translated using Weblate (Occidental) (Anonymous)
- Translated using Weblate (Occidental) (OIS)
- Translated using Weblate (Persian) (Anonymous)
- Translated using Weblate (Polish) (Anonymous)
- Translated using Weblate (Portuguese (Brazil)) (Anonymous)
- Translated using Weblate (Portuguese (Portugal)) (Anonymous)
- Translated using Weblate (Portuguese (Portugal)) (Joaquim Homrighausen)
- Translated using Weblate (Portuguese (Portugal)) (Raatty)
- Translated using Weblate (Portuguese (Portugal)) (Tmpod)
- Translated using Weblate (Portuguese) (Allan Nordhøy)
- Translated using Weblate (Portuguese) (Anonymous)
- Translated using Weblate (Portuguese) (Christian)
- Translated using Weblate (Portuguese) (Graeme Power)
- Translated using Weblate (Portuguese) (Joaquim Homrighausen)
- Translated using Weblate (Portuguese) (Raatty)
- Translated using Weblate (Portuguese) (Sorunome)
- Translated using Weblate (Romanian) (Anonymous)
- Translated using Weblate (Russian) (Anonymous)
- Translated using Weblate (Serbian) (Anonymous)
- Translated using Weblate (Serbian) (Joaquim Homrighausen)
- Translated using Weblate (Serbian) (Raatty)
- Translated using Weblate (Serbian) (Слободан Симић(Slobodan Simić))
- Translated using Weblate (Slovak) (Allan Nordhøy)
- Translated using Weblate (Slovak) (Anonymous)
- Translated using Weblate (Slovak) (Graeme Power)
- Translated using Weblate (Slovak) (Joaquim Homrighausen)
- Translated using Weblate (Slovak) (Raatty)
- Translated using Weblate (Slovenian) (Anonymous)
- Translated using Weblate (Slovenian) (Joaquim Homrighausen)
- Translated using Weblate (Slovenian) (Raatty)
- Translated using Weblate (Spanish) (Anonymous)
- Translated using Weblate (Spanish) (Joaquim Homrighausen)
- Translated using Weblate (Spanish) (José Muñoz)
- Translated using Weblate (Spanish) (Mæve Rey)
- Translated using Weblate (Spanish) (programmerpony)
- Translated using Weblate (Spanish) (Raatty)
- Translated using Weblate (Swedish) (Anonymous)
- Translated using Weblate (Swedish) (Dennis)
- Translated using Weblate (Swedish) (Fredrik Lindqvist)
- Translated using Weblate (Swedish) (paintwithblue)
- Translated using Weblate (Tamil) (Anonymous)
- Translated using Weblate (Tamil) (Graeme Power)
- Translated using Weblate (Tamil) (Joaquim Homrighausen)
- Translated using Weblate (Tamil) (Raatty)
- Translated using Weblate (Tamil) (Sorunome)
- Translated using Weblate (Thai) (Anonymous)
- Translated using Weblate (Tibetan) (Anonymous)
- Translated using Weblate (Turkish) (Anonymous)
- Translated using Weblate (Turkish) (Yourredyknowwhoitisss)
- Translated using Weblate (Vietnamese) (Allan Nordhøy)
- Translated using Weblate (Vietnamese) (Anonymous)
- Translated using Weblate (Vietnamese) (Christian)
- Translated using Weblate (Vietnamese) (Graeme Power)
- Translated using Weblate (Vietnamese) (Joaquim Homrighausen)
- Translated using Weblate (Vietnamese) (Raatty)
- Translated using Weblate (Vietnamese) (Sorunome)

## v1.15.1
- feat: Make all text in chat selectable on desktop (krille-chan)
- chore: Add border to images in timeline (krille-chan)
- chore: added android audio sharing intent (Aryan Arora)
- fix: Dockerfile: install jq in the builder image (David Douard)
- fix: Cannot pin messages of other users (Krille)
- fix: Emojipicker flickering because noRecent (krille-chan)
- fix: LoadProfileBottomSheet accessing disposed outerContext (Aryan Arora)
- fix: More stable scroll up to event (krille-chan)
- fix: Properly capitalize Linux window title (kramo)
- fix: Remove failed to sent events (krille-chan)
- fix: Routing glitch when using SSO on desktop (krille-chan)
- fix: SSO with no identity providers (krille-chan)
- refactor: Do not init client in background mode on Android (krille-chan)
- refactor: Store and fix missing persistence of some values (krille-chan)
- Translated using Weblate (Arabic) (Rex_sa)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Czech) (Vojtěch Fošnár)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Finnish) (Aminda Suomalainen)
- Translated using Weblate (German) (Haui)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)

## v1.15.0
- feat: Add experimental todo list for rooms (krille-chan)
- feat: better scroll to last read message handling (krille-chan)
- build: Add appid suffix to android debug builds (krille-chan)
- build: Download canvaskit on build for flutter web (krille-chan)
- build: Update to Flutter 3.13.9 (krille-chan)
- chore: Add descriptions in the areYouSure dialogs for better UX (krille-chan)
- chore: Adjust bitrate for smaller voice messages (krille-chan)
- chore: Change way how to seek in audioplayer (Krille)
- chore: Limit image file and video picker until we have a background service (krille-chan)
- chore: Minor design fixes (Krille)
- design: Make incoming messages color more light (krille-chan)
- design: Make key verification an adaptive dialog (krille-chan)
- design: Make own chat bubble primary color for better contrast (krille-chan)
- fix: Create chat dialog crashes sometimes and power level textfield does not validate input (krille-chan)
- fix: Remove uncompatible dependencies connectivity_plus and wakelock (Krille)
- fix: Use correct localization for redactedBy (krille-chan)
- fix: noFCM warning dialog (krille-chan)
- fix: render tg-forward as blockquote style (krille-chan)
- fix: Archive does not update its state
- refactor: Change audio codec to opus where supported to have better compatibility with Element (Krille)
- refactor: Make file dialog adaptive and adjust design (krille-chan)
- refactor: Preload notification sound on web (Krille)
- refactor: Remove unused config (krille-chan)
- refactor: Remove unused config params (krille-chan)
- refactor: Update FutureLoadingDialog (krille-chan)
- refactor: use locally hosted canvaskit instead of calling google (root)
- Translated using Weblate (Arabic) (Rex_sa)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (German) (Christian)
- Translated using Weblate (German) (Ettore Atalan)
- Translated using Weblate (Hungarian) (H Tamás)
- Translated using Weblate (Polish) (Tomasz W)
- Translated using Weblate (Russian) (v1s7)
- Translated using Weblate (Slovak) (Jozef Gaal)
- Translated using Weblate (Thai) (Amy/Atius)

## v1.14.5
- Hotfix iOS crashes on start
- Hotfix cannot reset applock

## v1.14.4
Minor bugfix release. Please note that because of a Flutter update FluffyChat is no longer
compatible with iOS 11.

- Translated using Weblate (Spanish) (José Muñoz)
- Translated using Weblate (Spanish) (Yotta Mxt)
- build: Add custom iOS notification sound (Krille)
- build: Set minimum iOS version to 12
- design: Hide Navigationbar labels (krille-chan)
- design: New notification sound (krille-chan)
- fix: Flutter warnings because of applock animation (krille-chan)
- fix: UIA requests with navigator (krille-chan)
- fix: open story from push notification (Krille-chan)
- refactor: Only preload client for GUI start (krille-chan)

## v1.14.3
- hotfix app lock still displayed even when account is logged out
- Update to Flutter 3.13.6

## v1.14.2
- hotfix for broken applock screen

## v1.14.1
- fix: Routing bug when adding second account via password login

## v1.14.0
Release with a lot of bugfixes and refactorings under the hood. FluffyChat now uses go_router instead of vrouter, works with the newest Flutter SDK and supports "reason" field for redactions. For Android there is a new "background-fetch mode" for Push Notifications which should make notifications in background faster and more reliable and reduce battery-usage.

- feat: Background fetch mode on Android (krille-chan)
- feat: Improved mouse support for selecting events (krille-chan)
- feat: Write and display reason for redacting a message (krille-chan)
- build: Add curl to build packages (krille-chan)
- build: Re-add handywindow linux code lines (Krille)
- build: Update Matrix dart sdk to 0.22.3 (Krille)
- build: Update targetSdkVersion to 33 (Android 13) (Krille)
- build: Update to Flutter 3.13.1 (Krille)
- change: Remove widgets feature (Krille)
- chore: Add tailwind.css to gitignore (Krille)
- chore: Display username in userbottomsheet (krille-chan)
- chore: Make appbar buttons correct size (krille-chan)
- chore: Update file picker (krille-chan)
- ci: Build snap on snapcraft again and only promote from ci (krille-chan)
- ci: Test if app builds for iOS (krille-chan)
- design: Add scale animation hover effects on navrail and story buttons (Krille)
- design: Big redesign of three column mode to advanced two column mode (krille-chan)
- design: Chat list design adjustments (Krille)
- design: Display last story as tiny message bubble in chat list (krille-chan)
- design: Improve invite chat UX (krille-chan)
- design: Move chatbackup in adaptive bottom sheet (krille-chan)
- design: New three column layout for wide screens (krille-chan)
- design: Nicer user bottom sheet (krille-chan)
- design: Redesign style page (Krille)
- docs: Update readme (Krille)
- feat/ChatListItem: small changes (gilice)
- fix: Bootstrap on first try fails sometimes (krille-chan)
- fix: Cancel search on back button tap on android (Krille)
- fix: Do not allow empty search server (krille-chan)
- fix: First story appears to be unencrypted sometimes (krille-chan)
- fix: Remove mpv and zenity to fix linux snap builds (krille-chan)
- fix: Unable to send files from snap version (krille-chan)
- refactor: Change group description to chat description (krille-chan)
- refactor: Make router static (Krille)
- refactor: Migrate from pathsegment routing (Krille)
- refactor: Migrate routes to go router (krille-chan)
- refactor: Remove bubble size slider (Krille)
- refactor: Replace vrouter with gorouter (Krille)
- refactor: Space routes to normal room routes (Krille)
- refactor: Update badge (krille-chan)
- refactor: Update html build files (krille-chan)
- Added translation using Weblate (Toki Pona) (Sollee)
- Deleted translation using Weblate (Toki Pona) (Christian)
- Translated using Weblate (Arabic) (Rex_sa)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Chinese (Simplified)) (Poesty Li)
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (Czech) (Flibble)
- Translated using Weblate (Czech) (Matyáš Caras)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (German) (Christian)
- Translated using Weblate (German) (nautilusx)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Japanese) (Christian)
- Translated using Weblate (Russian) (DarkCoder15)
- Translated using Weblate (Russian) (v1s7)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- Translated using Weblate (Ukrainian) (Skrripy)

## v1.13.0
- feat: option to not send typing notifications (Bnyro)
- feat: small performance tweaks for Message (gilice)
- feat: New onboarding screen with SSO as first class feature
- feat: Import/Export emoji packs from/to zip file
- fix: Set iOS badge (Krille)
- refactor: Switch the dev hosting platform from GitLab to GitHub
- design: New more compact chat bubble design and other design tweaks
- design: Login now shows SSO more prominent and deprecates in-app registration in favor of SSO registration
- Translated using Weblate (Arabic) (Rex_sa)
- Translated using Weblate (Chinese (Simplified)) (Poesty Li)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (German) (nautilusx)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)

## v1.12.0
- Added translation using Weblate (Toki Pona) (Mæve Rey)
- Translated using Weblate (Arabic) (Rex_sa)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Polish) (lauren n. liberda)
- Translated using Weblate (Romanian) (Riley)
- Translated using Weblate (Russian) (DarkCoder15)
- Translated using Weblate (Spanish) (José Muñoz)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- build: Remove dependency overwrite for ffi (Krille)
- build: Update dependencies (Krille)
- builds: Change minsdkversion of Android from 16 to 19 (Krille)
- builds: Do not allow failure for linux x86 (Krille)
- builds: Do not use verbose mode on building linux (Krille)
- builds: Linux with flutter 3.10 (Krille)
- builds: Remove workaround for building linux arm64 (Krille)
- builds: Update file_picker to 5.3.0 (Krille)
- builds: Update flutter table html (Krille)
- builds: Update flutter_html (Krille)
- builds: migrate to dart 3.0/flutter 3.10 (lauren n. liberda)
- chore: Add missing blockquote style (Krille)
- chore: Allow failure in build linux for now (Krille)
- chore: Ask for storage persistence (Krille)
- chore: Clean unused translations (Malin Errenst)
- chore: Enhance room pills (Krille)
- chore: Minor code clean up (Krille)
- chore: Update flutter webrtc (Krille)
- chore: Upgrade to Flutter 3.10.1 (Malin Errenst)
- chore: change release curl calls to use --fail-with-body (Tim Flink)
- chore: update macOS icons and add build script (TheOneWithTheBraid)
- design: Replace anime images with neutral cupertino icons (Krille)
- feat: Add toggle to mute notifications from chat groups (fbievan)
- feat: Allow ruby tags in html (Krille)
- feat: Display progress value for initial sync (Krille)
- feat: Implement new error reporting tool when critical features break like playing audio or video messages or opening a chat (Krille)
- feat: clean up macOS build metadata (TheOneWithTheBraid)
- feat: set display information correctly (TheOneWithTheBraid)
- feat: update macOS build files (TheOneWithTheBraid)
- feat: update macOS build information for macOS Ventura (TheOneWithTheBraid)
- fix "Unhandled Exception: VRouter.of(context) was called with a context which does not contain a VRouter." (Lauren N. Liberda)
- fix: Broken arb file (Krille)
- fix: Do not unnecessary request all members in public rooms (Krille)
- fix: Remove wrong rendered linebreak in html (Krille)
- fix: Scroll down button (Krille)
- fix: Scroll up and scroll down buttons in chat list (Krille)
- fix: Scrolldown button (Krille)
- fix: Too long file name cause a render overflow (Skying)
- fix: Try to reload timeline on IOException (Krille)
- fix: User pills (Krille)
- fix: broken CI artifact uploads (TheOneWithTheBraid)
- fix: custom emote placeholder (TheOneWithTheBraid)
- fix: path of libolm (TheOneWithTheBraid)
- fix: Quick account switching (JHansen)
- fix: read reciepts (JHansen)
- perf: Use valuenotifier to not rebuild chatlist (Krille)
- refactor: Reimplement flutter matrix html locally (Krille)
- refactor: Update Roboto and Noto Emoji (The one with the Braid)
- refactor: Use AnimatedSize for FAB (Krille)
- refactor: Use DateTime for weekday localization (Malin Errenst)

## v1.11.2
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (Polish) (Eryk Michalak)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- feat: Permission dialog before open link in browser (Krille)
- fix: Chats do not load (Krille)

## v1.11.1 - 2023-04-20
- fix: Download files on web and iOS with correct mimetype

## v1.11.0 - 2023-04-14
- feat: Add visual read marker (Krille)
- feat: Jump to last read event (Krille)
- feat: Use fragmented timeline to jump to event (Krille)
- feat: change to flutterwebauth2 (ShootingStarDragons)
- fix: Join public room (Krille)
- fix: Set fcm priority to max on android (Krille)
- refactor: CI scripts and old workarounds for build scripts (Krille)
- refactor: Client in ChatPage (Krille)
- refactor: Not nullable room in ChatPage (Krille)
- refactor: Switch to file_picker package and get rid of some dependency overrides (Krille)
- refactor: Use correct Matrix instance (Krille)
- style: Make emptypage logo bigger (Krille)
- style: Minor adjustments for modal bottom sheets (Krille)
- style: Move chats to top (Krille)
- style: Use SliverList for chatlist (Krille)
- refactor: Container -> SizedBox.shrink() (noob_tea)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (French) (Anne Onyme 017)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Persian) (Parsa)
- Translated using Weblate (Persian) (Siavash)
- Translated using Weblate (Polish) (Luna)
- Translated using Weblate (Swedish) (Kristoffer Grundström)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)

## v1.10.0 - 2023-02-25
- Added translation using Weblate (Thai) (Wphaoka)
- Added translation using Weblate (Tibetan) (Nathan Freitas)
- Default hardcoded message when l10n is not available (fabienli)
- Fix: The stable repo fingerprint (TODO the qr-code should be updated) (machiav3lli)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (French) (Anne Onyme 017)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Japanese) (Suguru Hirahara)
- Translated using Weblate (Persian) (Farooq Karimi Zadeh)
- Translated using Weblate (Swedish) (Joaquim Homrighausen)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- chore: Disable stable for web until script is fixed (Krille)
- chore: Display warning when logout without backup (Krille)
- chore: Downgrade flutter CI version (Krille)
- chore: Follow up audioplayer on linux (Krille)
- chore: Follow up chat encryption desgin (Krille)
- chore: Follow up fix audioplayer on android (Christian Pauly)
- chore: Follow up formatting (Christian Pauly)
- chore: Follow up formatting (Krille)
- chore: Follow up remove hero animation (Krille)
- chore: Follow up secrity settings design (Krille)
- chore: Follow up settings page (Krille)
- chore: Follow up settings page design (Christian Pauly)
- chore: Follow up style adjustments (Krille)
- chore: Lookup l10n in pushhelper if null (Krille)
- chore: Update matrix package to 0.17.0 (Krille)
- chore: Update to Flutter 3.7.1 (Krille)
- docs/qr-stable.svg: update the QR code (Aminda Suomalainen)
- feat: Enable audioplayer for web and linux (Christian Pauly)
- fix: Display error when user tries to send too large file (Christian Pauly)
- refactor: Do only instantiate AudioPlayer() object when in use (Christian Pauly)
- refactor: Remove syncstatus verbose logs (Christian Pauly)
- refactor: Store cached files in tmp directory so OS will clear file cache from time to time (Krille)
- style: Adjust key verification dialog (Christian Pauly)
- style: Bootstrap design adjustments (Christian Pauly)
- style: Encryption page adjustments (Christian Pauly)
- style: Enhance user device settings design (Krille)
- style: Enhanced chat details design (Krille)
- style: Give chat list list tiles rounded corners (Krille)
- style: Link underline color (Christian Pauly)
- style: Make adaptive bottom sheets scrollable by default (Krille)
- style: Make invite page more pretty (Krille)
- style: New settings design (Krille)
- style: Nicer chips in encryption settings and icons showing device status (Krille)
- style: Use emojis on web as well (Christian Pauly)
- style: Use robotomono to display device keys (Christian Pauly)
- utils/url_launcher: force opening http(s) links in external browser (Marcus Hoffmann)

## v1.9.0 - 2023-01-29
- Translated using Weblate (Czech) (Michal Bedáň)
- Translated using Weblate (Czech) (grreby)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Galician) (josé m)
- Translated using Weblate (German) (Christian)
- Translated using Weblate (German) (Vri 🌈)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Korean) (Youngbin Han)
- Translated using Weblate (Polish) (Wiktor)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- chore: Change invite link textfield label (Krille)
- chore: Remove unused dependency (Krille)
- chore: Remove unused translations (Krille)
- chore: Update Matrix SDK and refactor (Krille)
- chore: Update dependencies (Krille)
- chore: Update flutter_map (Krille)
- chore: add integration tests (TheOneWithTheBraid)
- chore: add integration tests for spaces (TheOneWithTheBraid)
- design: More clear chat background and rounded popup menu (Krille)
- design: Nicer navigationrail (Krille)
- design: Upgrade to Flutter 3.7
- feat: Bring back disabling the header bar on Linux desktop (q234rty)
- feat: Nicer design for abandonded DM rooms (Christian Pauly)
- fix: Archive (Krille)
- fix: Shared preferences package for flutter 3.7 (Christian Pauly)
- fix: permission of web builds (TheOneWithTheBraid)
- fix: Notification Settings (Krille)
- refactor: Migrate to Flutter 3.7.0 (Christian Pauly)
- refactor: Same animations everywhere in app (Krille)
- refactor: Stories header with futurebuilder (Krille)
- refactor: disable some redundant tests (TheOneWithTheBraid)
- style: Animate in out search results (Krille)
- style: New modal bottom sheets (Krille)
- style: Redesign public room bottomsheets (Krille)

## v1.8.0 2022-12-30
- Added translation using Weblate (Yue (yue_HK)) (Raatty)
- Translated using Weblate (Chinese (Simplified)) (Mike Evans)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (French) (Anne Onyme 017)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- design: New encryption page (Krille Fear)
- feat: Add audio message support to linux (Krille Fear)
- feat: Use Android system accent color (Krille Fear)
- feat: include olm to Windows builds (TheOneWithTheBraid)
- feat: Store drafts (Krille)
- fix: Android push notification follow-up (TheOneWithTheBraid)
- fix: Content banner (Krille Fear)
- fix: Correct redacted by username (Krille Fear)
- fix: Do not setup push on every app resume (Krille Fear)
- fix: Encryption button is orange in public rooms (Krille Fear)
- fix: File event design (Krille Fear)
- fix: Hide google services warning after marked (Krille Fear)
- fix: Improve story page appearance (Reinhart Previano Koentjoro)
- fix: Libhandy windows (Krille Fear)
- fix: Monochromatic icon rendering for Android 13+ (Reinhart Previano Koentjoro)
- fix: homeserver error text not visible in app bar (TheOneWithTheBraid)
- fix: minor issues in room list (TheOneWithTheBraid)

## v1.7.2 2022-12-19
Update dependencies and translations.

## v1.7.1 2022-11-23
Minor bugfix release to retrigger build for FlatPak and Android. Fixes some style bugs and updates some translations

## v1.7.0 2022-11-17
FluffyChat 1.7.0 features a new way to work with spaces via a bottom navigation bar. A lot of work has also been done under the hood to make the app faster and more stable. The main color has slightly changed and the design got some finetuning.

- chore: Add keys to roomlist and stories header (Christian Pauly)
- chore: Add unread badge to navigation rail and adjust design (Christian Pauly)
- chore: Adjust colors (Christian Pauly)
- chore: Better design chat list items (Christian Pauly)
- chore: Better load first client (Christian Pauly)
- design: Hide unimportant state events instead of folding (Christian Pauly)
- design: Improve login design (Krille Fear)
- design: Nicer display notification short texts (Christian Pauly)
- feat: background and terminated calls [android] (td)
- feat: New navigation design (Christian Pauly)
- fix: Hide password at login page (Krille Fear)
- fix: Import session on iOS (Christian Pauly)
- fix: incorrect setState inside setState in ChatListController (td)
- fix: Password not obscure for a second when submitting login textfield (Christian Pauly)
- fix: Popup menu without elevation (Christian Pauly)
- fix: Push error message (Christian Pauly)
- fix: Remove emoji picker workaround (Christian Pauly)
- fix: Set theme after start app (Christian Pauly)
- fix: Settings profile picture (Christian Pauly)
- fix: Share files (Christian Pauly)
- fix: UIA request handler (Christian Pauly)
- fix: Update emoji picker for web and desktop (Christian Pauly)
- improved (most) icons/image scaling, including avatar scaling (Mg138)
- Mention Element instead of Riot (Has been renamed about a year ago) (jooooscha)
- refactor: Chat list body code (Christian Pauly)
- refactor: Minor chatlist refactoring (Christian Pauly)
- refactor: No longer need selected of chat list tile (Christian Pauly)
- refactor: Remove unused dependencies (Krille Fear)
- Added translation using Weblate (Hindi) (Hemish)
- Added translation using Weblate (Occidental) (OIS)
- Translated using Weblate (Basque) (xabirequejo)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Chinese (Simplified)) (Raatty)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (English) (Raatty)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Estonian) (Raatty)
- Translated using Weblate (Finnish) (Aminda Suomalainen)
- Translated using Weblate (Finnish) (Raatty)
- Translated using Weblate (French) (Anne Onyme 017)
- Translated using Weblate (Galician) (Xosé M)
- Translated using Weblate (German) (Jana)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Lithuanian) (Anonimas)
- Translated using Weblate (Occidental) (OIS)
- Translated using Weblate (Persian) (Anastázius Darián)
- Translated using Weblate (Persian) (Anastázius Kaejatídarján)
- Translated using Weblate (Persian) (Seyedmahdi Moosavyan)
- Translated using Weblate (Russian) (Nikita Epifanov)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Turkish) (Raatty)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- Translated using Weblate (Ukrainian) (Raatty)

## v1.6.4 - 2022-09-08
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Galician) (Xosé M)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Slovak) (Marek Ľach)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- chore: Adjust bubble color in dark mode (Christian Pauly)
- chore: Update matrix sdk (Christian Pauly)
- chore: Update to flutter 3.3.0 (Christian Pauly)
- feat: Automatic key requests and better key error dialog (Christian Pauly)
- fix: Styling and notification settings (Christian Pauly)
- fix: add missing command localizations (Christian Pauly)

## v1.6.3 - 2022-08-25
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Finnish) (Aminda Suomalainen)
- Translated using Weblate (Russian) (Sergey Shavin)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- chore: Migrate back to flutter hive collections (Christian Pauly)
- chore: Update provider package and remove dep override (Christian Pauly)
- fix: Do not display push events for unknown event types (Christian Pauly)
- refactor: App widget (Christian Pauly)

## v1.6.0 - 2022-07-31
FluffyChat 1.6.0 features a lot of bug fixes and improvements. The code base has been
simplified and the drawer on the chat list page got a come-back. Some new features like
the space hierarchy and session dump have been implemented.

- feat: Added monochrome entry for themed icon support in Android 13 (James Reilly)
- feat: Display timeline of messages in android notification (Christian Pauly)
- feat: Emoji related fixes (TheOneWithTheBraid)
- feat: Implement deleting pushers in app (Christian Pauly)
- feat: New material 3 design (Christian Pauly)
- feat: Redesign bootsstrap and offer secure storage support (Christian Pauly)
- feat: Send multiple images at once (Christian Pauly)
- feat: implement session dump (TheOneWithTheBraid)
- feat: implement space hierarchy (TheOneWithTheBraid)
- feat: introduce extended integration tests (TheOneWithTheBraid)
- feat: libhandy integration (TheOneWithTheBraid)
- fix: Clearing push triggered when only one room got seen (Christian Pauly)
- fix: Dont display loading dialog when adding reaction (Christian Pauly)
- fix: Follow up for spaces hierarchy (TheOneWithTheBraid)
- fix: Missing null checks in chat details view (Christian Pauly)
- fix: Non FCM Android builds crash on start (Christian Pauly)
- fix: Permission chooser dialog on iOS (Christian Pauly)
- fix: Set avatar on only single action available (Christian Pauly)
- fix: Sharing on iOS and iPad (Christian Pauly)
- fix: Unread bubble is invisible in dark mode (Christian Pauly)
- fix: appimage builds (TheOneWithTheBraid)
- fix: only use custom http client on android (Jayesh Nirve)
- fix: pass isrg cert to http client (Jayesh Nirve)
- refactor: Chat view (Christian Pauly)
- refactor: Encryption button (Christian Pauly)
- refactor: Remove duplicated imports (Christian Pauly)
- refactor: Remove legacy store (Christian Pauly)
- refactor: Remove presence status feature (Christian Pauly)
- refactor: Simplify MxcImage and replace CachedNetworkImage (Christian Pauly)
- refactor: Switch to Hive Collections DB (Christian Pauly)
- refactor: move start chat FAB to implementation file (TheOneWithTheBraid)
- Translated using Weblate (Catalan) (Alfonso Montero López)
- Translated using Weblate (Catalan) (Auri B.P)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (English) (Raatty)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Finnish) (Aminda Suomalainen)
- Translated using Weblate (Galician) (Xosé M)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Persian) (Amir Hossein Maher)
- Translated using Weblate (Polish) (Przemysław Romanik)
- Translated using Weblate (Russian) (Nikita Epifanov)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- chore: Add border to avatars (Christian Pauly)
- chore: Add fancy hero animations (Christian Pauly)
- chore: Adjust appbar design (Christian Pauly)
- chore: Adjust design (Christian Pauly)
- chore: Adjust search bar design (Christian Pauly)
- chore: Always display header elevation in chat (Christian Pauly)
- chore: Design follow up fixes (Christian Pauly)
- chore: Design follow up fixes (Christian Pauly)
- chore: Disable integration tests without runners (Krille Fear)
- chore: Enhance invitiation UX (Christian Pauly)
- chore: Make push helper more fail safe (Christian Pauly)
- chore: Make push helper more stable (Christian Pauly)
- chore: Minor design improvements (Christian Pauly)
- chore: Pinned events design (Christian Pauly)
- chore: Remove permission handler dependency and increase compileSdkVersion (Christian Pauly)
- chore: Switch to flutter 3.0.5 (Krille Fear)
- chore: Update SDK (Christian Pauly)
- chore: remove snapping sheet (TheOneWithTheBraid)

## v1.5.0 - 2022-06-03
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- feat: Better sign up UX and allow signup without password (Christian Pauly)
- feat: Initial material you support (Christian Pauly)
- feat: include Synapse into integration test (TheOneWithTheBraid)
- fix: Broken dynamic color palette (Christian Pauly)
- fix: Build on iOS emulator (Christian Pauly)
- fix: Missing bottom padding in text only stories (Christian Pauly)
- fix: Send sticker without blocking the UI (Christian Pauly)
- fix: Sentry switch being broken (Sorunome)
- fix: add new Play patch (TheOneWithTheBraid)
- fix: handle matrix.to prefix when starting chat (TheOneWithTheBraid)
- fix: minor design bugs (TheOneWithTheBraid)
- fix: privacy in sign up (TheOneWithTheBraid)
- fix: properly set app title in embedder (TheOneWithTheBraid)
- fix: proprietory classes included into build (TheOneWithTheBraid)
- fix: remove proprietary classes from build (TheOneWithTheBraid)
- refactor: Sharing intent (Christian Pauly)
- refactor: Stories header (Christian Pauly)
- refactor: Update Matrix SDK (Christian Pauly)
- refactor: Upgrade to Flutter 3.0.0 (Christian Pauly)
- Translated using Weblate (Basque) (—X—)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (Czech) (Milan Korecky)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Galician) (Xosé M)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Lithuanian) (Mind)
- Translated using Weblate (Portuguese (Brazil)) (Hermógenes Oliveira)
- Translated using Weblate (Portuguese (Brazil)) (mmagian)
- Translated using Weblate (Russian) (Nikita Epifanov)
- Translated using Weblate (Turkish) (Oğuz Ersen)

## v1.4.0 - 2022-04-23
- design: Display icon for failed sent messages (Krille Fear)
- design: Display own stories at first place and combine with new stories button (Krille Fear)
- feat: Add "Show related DMs in spaces" settings (20kdc)
- feat: Better image sending experience (Krille Fear)
- feat: Display event timestamp if selected (Krille Fear)
- feat: Faster image resizing (Krille Fear)
- feat: Groups and Direct Chats virtual spaces option (20kdc)
- feat: New onboarding design (Krille Fear)
- feat: Onboarding with dynamic homeservers from joinmatrix.org (Krille Fear)
- feat: Play audio messages in stories (Krille Fear)
- feat: Use native imaging for much faster thumbnail calc on mobile (Krille Fear)
- feat: add Dockerfile for nginx/web builds (TheOneWithTheBraid)
- feat: allow to create widgets (TheOneWithTheBraid)
- feat: remove diacritics (henri2h)
- feat: irish language support (Graeme Power)
- feat: Enable screensharing on Mobile
- feat: support AppImage builds
- feat: Improve spaces design
- fix: Android theme is not auto updating when system theme changes (Krille Fear)
- fix: Chat view becomes gray for a second on sending reaction (Krille Fear)
- fix: Don't request new thumbnail resolution on every window resize (Samuel Mezger)
- fix: Dont display own failed-to-send events in stories (Krille Fear)
- fix: Hide markdown in chat list preview and local notifications (Krille Fear)
- fix: Hide pinned events if event is not accessable or loading (Krille Fear)
- fix: Image sending (Krille Fear)
- fix: Make audioplayer waveforms thinner and better clickable (Krille Fear)
- fix: Some story layout bugs (Krille Fear)
- fix: Widgets dialog crashes (Krille Fear)
- fix: login form supports switching fields via tab (Philip Molares)
- Added translation using Weblate (Lithuanian) (Mind)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Finnish) (Aminda Suomalainen)
- Translated using Weblate (French) (Anne Onyme 017)
- Translated using Weblate (Galician) (Xosé M)
- Translated using Weblate (German) (Krille)
- Translated using Weblate (German) (qwerty287)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Japanese) (Krille)
- Translated using Weblate (Lithuanian) (Mind)
- Translated using Weblate (Portuguese (Brazil)) (Hermógenes Oliveira)
- Translated using Weblate (Russian) (Arbo_Leet)
- Translated using Weblate (Russian) (Nikita Epifanov)
- Translated using Weblate (Russian) (alekseishaklov)
- Translated using Weblate (Swedish) (Joaquim Homrighausen)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- Update TRANSLATORS_GUIDE.md to have improved punctuation, capitalization (Scott Anecito)
- chore: Add initial integration tests (Krille Fear)
- refactor: New push (Krille Fear)

## v1.3.1 - 2022-03-20
- Allow app to be moved to external storage (Marcel)
- Translated using Weblate (Arabic) (Mads Louis)
- Translated using Weblate (Basque) (Sorunome)
- Translated using Weblate (Basque) (—X—)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Czech) (Sorunome)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (English) (Raatty)
- Translated using Weblate (French) (Anne Onyme 017)
- Translated using Weblate (Galician) (Xosé M)
- Translated using Weblate (German) (Maciej Krüger)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Irish) (Graeme Power)
- Translated using Weblate (Persian) (Anastázius Darián)
- Translated using Weblate (Russian) (Nikita Epifanov)
- Translated using Weblate (Swedish) (Joaquim Homrighausen)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- Update proguard rules to a more modern setup (MTRNord)
- chore: Minor story viewer fixes (Krille Fear)
- chore: Remove story line count and make answering to stories online (Krille Fear)
- chore: Update dependencies (Dependency Update Bot)
- design: Make pinned events use less vertical space (Krille Fear)
- feat: Extended stories (Krille Fear)
- feat: Restrict map zoom to tile server capabilities (Marcel)
- feat: implement keyboard shortcuts (TheOneWithTheBraid)
- fix: Build on macOS (Krille Fear)
- fix: Emojipicker issues (Krille Fear)
- fix: Hide redacted stories (Krille Fear)
- fix: Mark story as read (Krille Fear)
- fix: Open room from notification click produces errors (Krille Fear)
- fix: SSO on Android 12 (Krille Fear)
- fix: Send read receipts on all taps (Krille Fear)
- fix: make fluffy usable at 720 px wide (Raatty)
- fix: Add forgotten sendOnEnter (Krille Fear)
- refactor: Switch to just audio for playing sounds (Krille Fear)

## v1.3.0 - 2022-02-12
FluffyChat 1.3.0 makes it possible to report offensive users to server admins (not only messages). It fixes
the video player, improves Linux desktop notifications, and the stories design.

The button to create a new story is now in the app bar of the main page so that users who don't want to use
this feature no longer have a whole list item pinned at the top of the chat list.

FluffyChat 1.3.0 is the first release with full null safe dart code. While this is a huge change under the
hood, it should improve the stability and performance of the app. It also builds now with Flutter 2.10.

Thanks to all contributors and translators!! <3

- Translated using Weblate (Arabic) (abidin toumi)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (Czech) (Milan Korecky)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (French) (Anne Onyme 017)
- Translated using Weblate (Galician) (Xosé M)
- Translated using Weblate (German) (Krille)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Russian) (Nikita Epifanov)
- Translated using Weblate (Swedish) (Joaquim Homrighausen)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)
- chore: Add missing link (Krille Fear)
- chore: Hide FAB story buttons on focus (Krille Fear)
- chore: Set compileSdkVersion to 31 (Krille Fear)
- chore: Update SDK (Krille Fear)
- chore: Update dependencies (Dependency Update Bot)
- chore: Update privacy (Krille Fear)
- chore: Upgrade to Flutter 2.10 (Krille Fear)
- ci: Update olm download link (Krille Fear)
- design: Improve create story page design (Krille Fear)
- design: Improve story header design (Krille Fear)
- design: Use IconButton instead of listTile for first story (Krille Fear)
- feat: Add button to report offensive users to server admins (Krille Fear)
- feat: Open chat button from Linux notification (Krille Fear)
- feat: implement retreiving widgets (TheOneWithTheBraid)
- fix: Set image width and height (Krille Fear)
- fix: Videoplayer filenames (Krille Fear)
- fix: cast error in html messages (Jayesh Nirve)
- fix: linux snap notification avatar (Krille Fear)
- fix: suggestions menu and use empty map in html messages null return (Jayesh Nirve)
- refactor: Migrate to null safety (Krille Fear)

## v1.2.0 - 2022-01-27
FluffyChat 1.2.0 brings a new stories feature, a lot of bug fixes and improved
voice messages.

- change: Set client ID in invite action link (Krille Fear)
- design: Improved animations in chat view when changing account (The one with the Braid)
- design: Remove redundant voice message button (S1m)
- design: Use more adaptive elements (Krille Fear)
- feat: Add button to record a video on Android (S1m)
- feat: Add static + button to pick reaction (S1m)
- feat: Better in app video player (Krille Fear)
- feat: Enable compression and thumbnails for videos (Krille Fear)
- feat: Nicer file event design (Krille Fear)
- feat: Recording dialog with displaying amplitude (Krille Fear)
- feat: Remember homeserver on search page (Krille Fear)
- feat: Save files images and videos (Krille Fear)
- feat: Settings for stories (Krille Fear)
- feat: Share to story (Krille Fear)
- feat: Stories (Krille Fear)
- fix: Add missing routes (Krille Fear)
- fix: Better thumbnails (Krille Fear)
- fix: Do not setup UP if init from an UP action (S1m)
- fix: linux notifications (Raatty)
- fix: Play video without thumbnail if none (S1m)
- fix: Show message bubble on download only video attachments (Drews Clausen)
- fix: Show scrollDownButton only if selectedEvents is empty (S1m)
- fix: Snapcraft image (Krille Fear)
- fix: Snapcraft.yaml (Krille Fear)
- fix: Use system fonts except for desktop (Krille Fear)
- fix: Video playback on iOS (John Francis Sukamto)
- fix: Videoplayer (Krille Fear)
- followup: Improve stories (Krille Fear)
- Improve website SEO tagging (Marcel)
- Increase font size granularity (S1m)
- refactor: /command hints add tooltips, test for missing hints, script to generate glue code, hints for dm, create, clearcache, discardsession (Steef Hegeman)
- refactor: Make more files null safe (Krille Fear)
- refactor: Make style settings null safe (Krille Fear)
- systemNavigationBarColor ← appBar.backgroundColor (Steef Hegeman)
- Translated using Weblate (Chinese (Simplified)) (Eric)
- Translated using Weblate (Chinese (Simplified)) (Lynn Nakanishi Lin（林中西）)
- Translated using Weblate (Chinese (Traditional)) (Lynn Nakanishi Lin（林中西）)
- Translated using Weblate (Croatian) (Milo Ivir)
- Translated using Weblate (Czech) (Milan Korecky)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Finnish) (Aminda Suomalainen)
- Translated using Weblate (French) (Anne Onyme 017)
- Translated using Weblate (Galician) (Xosé M)
- Translated using Weblate (German) (Krille)
- Translated using Weblate (German) (Jana)
- Translated using Weblate (German) (TeemoCell)
- Translated using Weblate (Hebrew) (MusiCode1)
- Translated using Weblate (Hebrew) (y batvinik)
- Translated using Weblate (Hungarian) (Balázs Meskó)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Korean) (Kim Tae Kyeong)
- Translated using Weblate (Polish) (KSP Atlas)
- Translated using Weblate (Russian) (Nikita Epifanov)
- Translated using Weblate (Slovenian) (John Jazbec)
- Translated using Weblate (Spanish) (Valentino)
- Translated using Weblate (Turkish) (Oğuz Ersen)
- Translated using Weblate (Ukrainian) (Ihor Hordiichuk)

## v1.1.0 - 2021-12-08
- CI: Add candidate release pipeline (Krille Fear)
- Translated using Weblate (Dutch) (Jelv)
- Translated using Weblate (Estonian) (Priit Jõerüüt)
- Translated using Weblate (Finnish) (Mikaela Suomalainen)
- Translated using Weblate (Finnish) (Mikaela Suomalainen)
- Translated using Weblate (Indonesian) (Linerly)
- Translated using Weblate (Korean) (Kim Tae Kyeong)
- Translated using Weblate (Norwegian Bokmål) (Gigaa)
- Translated using Weblate (Norwegian Bokmål) (Raatty)
- change: Do not compress very small images (Krille Fear)
- chore: Update Matrix SDK (Krille Fear)
- design: Make not joined participants transparent in list (Krille Fear)
- docs: Fix screenshots on website (Krille Fear)
- fix: Update dependencies with flutter pub upgrade (Krille Fear)
- fix: Well known lookup at login (Krille Fear)
- refactor: Make most of the utils null safe (Krille Fear)
- refactor: Make send file dialog null safe (Krille Fear)
- refactor: Make user device list item null safe (Krille Fear)

## v1.0.0 - 2021-11-29
- design: Chat backup dialog as a banner
- design: Encrypted by design, all users valid is normal not green
- design: Move video call button to menu
- design: Display edit marker in new bubbles
- design: Floating input bar
- design: Minor color changes
- design: Move device ID to menu
- design: Place share button under qr code
- design: Redesign and simplify bootstrap
- design: Remove cupertino icons
- feat: Display typing indicators with gif
- feat: Fancy chat list loading animation
- feat: New database backend with FluffyBox
- feat: Make the main color editable for users
- feat: Move styles one settings level up
- feat: Multiple mute, pin and mark unread
- feat: New chat design
- feat: New chat details design
- feat: New Public room bottom sheet
- feat: New settings design
- feat: Nicer images, stickers and videos
- feat: nicer loading bar
- feat: Open im.fluffychat uris
- feat: Redesign multiaccounts and spaces
- feat: Redesign start page
- feat: Send reactions to multiple events
- feat: Speed up app start
- feat: Use SalomonBottomBar
- feat: Drag&Drop to send multiple files on desktop and web
- fix: Adjust color
- fix: Automatic key requests
- fix: Bootstrap loop
- fix: Chat background
- fix: Chat list flickering
- fix: Contrast in dark mode
- fix: Crash when there is no prev message
- fix: Do display error image widget
- fix: Do not display bottombar in selectmode
- fix: Dont enable encryption with bots
- fix: Dont loose selected events
- fix: Dont rerun server checks
- fix: download path for saving files
- fix: Hide FAB in new chat page if textfield has focus
- fix: Let bottom space bar scroll
- fix: Load spaces on app start
- fix: Only mark unread if actually marked
- fix: Public room design
- fix: Remove avatar from room
- fix: Remove broken docker job
- fix: Report sync status error
- fix: Self sign while bootstrap
- fix: Sender name prefix in DM rooms
- fix: Set room avatar
- fix: Various multiaccount fixes
- fix: Wrong version in snap packages

## v0.42.2 - 2021-11-04
Minor bugfix release which fixes signing up on matrix.org and make FluffyChats voice messages playable in Element.

- feat: Nicer registration form
- feat: Nicer audio message design and send duration
- fix: Signup on matrix.org
- fix: Mark voice messages with msc3245
- fix: Play response voice messages
- fix: Crash on logout

## v0.42.1 - 2021-10-26
Minor bugfix release.

- feat: Ignore users directly from bottom sheet
- fix: Open an existing direct chat via invite link/QR scanning
- fix: Small fix for uia request
- fix: Enable E2EE by default in all start chat cases
- update: Translations - Thanks to all translators <3
- design: Make homepicker page nicer

## v0.42.0 - 2021-10-14
This release fixes several bugs and makes E2EE enabled by default.

- feat: Enable E2EE by default for new rooms
- feat: Display all private rooms without encryption as red
- feat: New design for bootstrap
- feat: New design for emoji verification
- feat: Display own MXID in the settings
- feat: More finetuning for font sizes
- chore: Updated translations (Thanks to all translators!)
- fix: App crash on logout
- fix: Temporary disable sign-up for matrix.org (Currently gives "500: Internal Server Error" while FluffyChat **should** send the same requests like Element)
- fix: Implement Roboto font to fix font issues on Linux Desktop and mobile
- fix: QR Code scanning

## v0.41.3 - 2021-10-08
Minor bugfix release.

- fix: Last space is not visible
- chore: Google services disabled by default for F-Droid

## v0.41.1 - 2021-09-15
Minor bugfix release.

- fix: Start up time waits for first sync
- fix: Registration -> matrix.org responses with 500
- fix: Wellknown look up for multi accounts

And some other minor bugs.

## v0.41.0 - 2021-09-14
This release features a lot of bug fixes and the new multi account feature which also include account bundles.
- feat: Multiple accounts
- feat: New splash screen
- fix: Password reset
- fix: Dark text in cupertinodialogs
- fix: Voice messages on iOS
- fix: Emote settings
- chore: update flutter_matrix_html, Matrix Dart SDK and other libraries
- chore: Update to Flutter 2.5.1
- chore: Updated translations

## v0.40.1 - 2021-09-14
Minor bug fixes.

## v0.40.0 - 2021-09-13
This release contains a security fix. Red more about it here: https://matrix.org/blog/2021/09/13/vulnerability-disclosure-key-sharing

- New in-app registration
- Design improvements
- Minor fixes

## v0.39.0 - 2021-08-30
- Hotfix a bug which produces problems in downloading files and playing audios
- Hotfix a bug which breaks device management

## v0.39.0 - 2021-08-28
This release fixes a bug which makes it impossible to send images in unencrypted rooms. It also implements a complete new designed new chat page which now uses a QR code based workflow to start a new chat.

- feat: Dismiss keyboard on scroll in iOS
- feat: Implement QR code scanner
- feat: New design for new chat page
- feat: Use the stripped body for notifications and room previews
- feat: Send on enter configuration for mobile devices
- fix: Prefix of notification text
- fix: Display space as room if it contains unread events in timeline
- fix: missing null check
- fix: Open matrix.to urls
- fix: Padding and colors
- fix: Sharing invite link
- fix: Unread bubbles on iOS 
- fix: Sending images in unencrypted rooms

## v0.38.0 - 2021-08-22
This release adds more functionality for spaces, enhances the html viewer, adds a brand new video player and brings some improvements for voice messages. Thanks to everyone involved!

### All changes:

- change: Nicer design for selecting items
- change: Placeholder at username login field should be just username
- chore: cleanup no longer used translation strings
- chore: switch image_picker back to upstream
- chore: update flutter_matrix_html
- chore: Update matrix sdk to 0.3.1
- feat: Add option to not autoplay stickers and emotes
- feat: Add remove rooms to and from spaces
- feat: Add video player
- feat: Cupertino style record dialog
- feat: Display amplitude
- feat: Implement official emoji translations for emoji verification
- feat: Nicer displaying of verification requests in the timeline
- fix: Allow fallback to previous url if there is no homeserver on the mxid domain
- fix: Correctly size the unread bubble in the room list
- fix: Design of invite rooms
- fix: Disable autocorrect for the homeserver url field
- fix: Disable broken audioplayer for web
- fix: Display loading dialog on start DM
- fix: Dont add/remove DMs to space
- fix: Empty timelines crashing the room view
- fix: excessive CPU usage on Windows, as described in https://github.com/flutter/flutter/issues/78517#issuecomment-846436695
- fix: Joining room aliases not published into the room directory
- fix: Keep display alive while recording
- fix: Load space members to display DM rooms
- fix: Make translations use plural forms
- fix: Re-add login fixes with the new SDK
- fix: Reply with voice messages
- fix: Report content localizations
- fix: Requirements when to display report event button
- fix: too long file names
- fix: Try different directories on all kind of errors thrown for hive store
- fix: Use plural string in translation
- fix: use vrouter.toSegments
- fix: Wait for sync before enter a room a user has got invited
- fix: wallpaper on linux
- fix: Wrap login form into `AutofillGroup`

## v0.37.0 - 2021-08-06
- Implement location sharing
- Updated translations
- Improved spaces support
- Minor bug fixes

## v0.36.2 - 2021-08-03
Hotfix a routing problem on web and desktop

## v0.36.1 - 2021-08-03
- Hotfix uploading to many OTKs
- Implement initial spaces UI

## v0.36.0 - 2021-07-31
Minor design improvements and bug fixes.

### All changes:
* design: Make unread listtiles more visible
* design: Move pinned icon in title
* feat: Rate limit streams so that large accounts have a smoother UI
* feat: Display the room name in room pills
* feat: Increase the amount of suggestions for the input bar
* feat: Tapping on stickers shows the sticker body
* fix: Windows
* fix: Disable vrouter logs in release mode
* fix: No longer hide google services key file
* fix: Tests

## v0.35.0 - 2021-07-24
This release introduces stickers and a lot of minor bug fixes and improvements.

### All changes:
### Feature
* Add sticker picker [205d7e8]
* Also suggest username completions based on their slugs [3d980df]
* Nicer mentions [99bc819]
* Render stickers nicer [35523a5]
* Add download button to audio messages [bbb2f43]
* Android SSO in webview [befd8e1]

### Fixes
* Reset bootstrap on bad ssss [b78b654]
* Hide stickers button when there is not sticker pack [b71dd4b]
* Download files on iOS [a8201c4]
* Record voice messages on iOS [4c2e690]
* cropped sticker [a4ec2a0]
* busy loop due to CircularProgressIndicator [15856e1]
* Crash on timeline [a206f23]
* typo on webiste [00a693e]
* Make sure the aspect ratio of image bubbles stays the same [a4579a5]
* Linux failing on attempting to open hive [76e476e]
* Secure storage [0a52496]
* Make sure the textfield is unfocused before opening the camera [6821a42]
* Close safariviewcontroller on SSO [ba685b7]

### Refactor
* Rename store and allow storing custom values [b1c35e5]

## v0.34.1 - 2021-07-14
Bugfix image picker on Android 11

## v0.34.0 - 2021-07-13
Mostly bugfixes and one new feature: Lottie file rendering.

### All changes:
* feat: Add rendering of lottie files
* fix: Check for jitsi server in well-known lookup also on login screen
* fix: show thumbnails in timeline on desktop
* feat: Add a proper file saver
* feat: Better detect the device type from the device name
* fix: Workaround for iOS not removing the app badge
* fix: Keyboard hides imagePicker buttons on iOS
* feat: Add rendering of lottie files
* fix: Don't allow backup of the android app

## v0.33.3 - 2021-07-11
Another bugfixing release to solve some problems and republish the app on iOS.

### Changes
* Redesign SSO buttons
* Update dependencies
* Remove moor database (no migration from here possible)
* fix: Keyboard hides imagePicker buttons on iOS

## v0.33.2 - 2021-06-29
* Fix Linux Flatpak persistent storing of data

## v0.33.0 - 2021-06-26
Just a more minor bugfixing release with some design changes in the settings, updated missing translations and for rebuilding the arm64 Linux Flatpak.

### Features
* redesigned settings
* Updated translations - thanks to all translators
* display progress bar in first sync
* changed Linux window default size
* update some dependencies

### Fixes
* Favicon on web
* Database not storing files correctly
* Linux builds for arm64
* a lot of minor bugs

## v0.32.2 - 2021-06-20
* fix: Broken hive keys

## v0.32.1 - 2021-06-17
* fix: Hive breaks if room IDs contain emojis (yes there are users with hacked synapses out there who needs this)
* feat: Also migrate inbound group sessions


## v0.32.0 - 2021-06-16
FluffyChat 0.32.0 targets improved stability and a new onboarding flow where single sign on is now the more prominent way to get new users into the app. This release also introduces a complete rewritten database under the hood based on the key value store Hive instead of sqlite. This should improve the overall stability and the performance of the web version.

### Feat
* Long-press reactions to see who sent this
* New login UI
* Shift+Enter makes a new line on web and desktop
* Updated translations - Thanks to all translators
* Brand new database backend
* Updated dependencies
* Minor design tweaks

### Fixes
* Single sign on on iOS and web
* Database corruptions
* Minor fixes

## v0.31.3 - 2021-05-28

### Fixes
* Build Linux
* Multiline keyboard on web and desktop

## v0.31.2 - 2021-05-28

### Fixes
* Setting up push was broken

## v0.31.0 - 2021-05-26

### Chore
* Format iOS stuff [584c873]
* LibOlm has been updated to 3.2.3

### Feature
* Cute animation for hiding the + button in inputbar [37c40a2]
* Improved chat bubble design and splash animations [0b3734f]
* Zoom page transition on Android and Fuchsia [e6c20dd]

### Fixes
* "Pick an image" button in emote settings doesn't do anything [e6be684]
* Formatting and style [2540a6c]
* Emoji picker [e1bd4e1]
* Systemuioverlaystyle [c0d446b]
* Status bar and system navigation bar theme [d986986]
* Open URIs [6d7c52c]
* Status bar color [f347edd]
* add missing purpose string [3830b4b]
* Workaround for iOS not clearing notifications with fcm_shared_isolate [88a7e8d]
* Minor glitch in bootstrap [107a3aa]
* Send read markers [08dd2d7]

### Docs
* Update code style [3e7269d]

### Refactor
* Structure files in more directories [ebc598a]
* Rename UI to Views [e44de26]
* rename UI to View and MVC login page [cc113bb]
* Rename views to pages [a93165e]
* Move widgets to lib [56a2455]
* Move translations to assets [0526e66]
* Update SDK [4f13473]
* Use default systemUiOverlayStyle [8292ee7]

## v0.30.2 - 2021-05-13

### Feature
* Implement registration with email [19616f3]

### Fixes
* Android input after sending message [4488520]

### Changes
* Switch to tchncs.de as default homeserver

### Refactor
* UIA registering [48bf116]

## v0.30.1 - 2021-05-07

### Chore
* Update translations

### Fixes
* Record audio on iOS [cd1e9ae]

## v0.30.0 - 2021-05-01

In this release we have mostly focused on bugfixing and stability. We have switched to the new Flutter 2 framework and have done a lot of refactoring under the hood. The annoying freezing bug should now be fixed. Voice messages now have a new backend which should improve the sound quality and stability. There is now a more professional UI for editing aliases of a room. Users can now see a list of all aliases, add new aliases, delete them and mark one alias as the canonical (or main) alias. Some minor design changes and design fixes should improve the overall UX of the app exspecially on tablets.

Version 0.30.0 will be the first version with arm64 support. You can download binaries from the CI and we will try to publish it on Flathub. Together with the new Linux Desktop Notifications feature, this might be interesting for the Librem 5 or the PinePhone. Sadly I don't own one of these very interesting devices. If you have one, I would very like to see some screenshots of it! :-)

### Chore
* Update UP and automatically re-register UP on startup [aa3348e]

### Feature
* Desktop notifications on Linux Desktop [25e76f0]
* Much better alias managing [642db67]
* Archive with clean up [f366ab6]

### Fixes
* Lock screen [f8ba7bd]
* Freeze bug [15c3178]
* UserBottomSheet [dbb0464]
* Message bubble wrong height [2b9bd9c]
* Low height layout [0d6b43d]
* Behaviour of homeserver textfield [2c8a8a4]
* Build Linux [d867a56]
* EmojiPicker background [0a5270b]
* e2ee files [ccd7964]
* Remove the goddamn package from hell circular checkbox!!! Shame on you! SHAME! [81c6906]
* Missing null check [586c248]
* Chat UI doesnt load [4f20ea4]

### Refactor
* Remove unused variable [b9f5c94]
* Remove flutter_sound [334d4c0]
* Switch to record package [2cf4f47]
* Sort dependencies [f2295f7]
* Widget file structure and MVC user bottom sheet [bd53745]
* Dialogs as views [69deae3]
* MVC Settings page [bc5e973]
* MVC Settings Notifications [c291b08]
* MVC multiple emote settings [a64ada5]
* MVC settings ignore list [f23fdcc]
* MVC emote settings [1f9f3f4]
* Null safe dependencies [ca82a46]
* MVC settings style [c6083b6]
* MVC settings 3pid [6bfe7b2]
* MVC search [b008d56]
* Folder structure and MVC chat ui [fb61824]
* Move some views to widgets [1fe5b78]
* MVC device settings view [15731b9]
* New private chat view [453d4f3]
* MVC chat permission settings [001e0ee]
* MVC chat list view [7658425]
* MVC chat encryption settings [576e840]
* MVC chat details [28ed394]
* Enable more lints [6a56ec4]
* MVC new group view [3f889e2]
* MVC invitation selection [c12e815]

## v0.29.1 - 2021-04-13

### Chore
* Bump version [215f3c8]

### Fixes
* Save file [3f854d6]
* Routing broken in chat details [f1166b2]
* Tests [e75a5a0]
* Minor sentry crashes [9aa7d52]
* nogooglewarning [7619941]

### Refactor
* MVC archive [c2cbad7]
* MVC sign up password view [fa0162a]
* MVC sign up view [db19b37]
* Controllers [f5f02c6]

## v0.29.0 - 2021-04-09

### Chore
* Clean up repo [ef7ccef]
* Bump version [81a4c26]
* Nicer FAB icon [3eeb9a9]
* Archive button in main menu [da3dc80]
* turn renderHtml and hideUnknownEvents on [29f8e05]
* Remove unused dependencies [c505c50]

### Feature
* Experimental support for room upgrades [a3af5a9]

### Fixes
* Room upgrade again [1d40705]
* Better padding [c79562f]
* Room upgrade [dac26dd]
* iOS [3a6b329]
* React if not allowed [0146767]
* iPad dividerwidth [a154db0]
* Playstore release job [47c9180]
* Remove blur [ebf73bf]
* Support for email registration [7e5eae5]
* Typo [6250fd0]
* #323 [56e5c81]
* Typo [b38b0e4]
* Buggy routing [62bf380]
* barrierDismissible: true, [de9e373]
* UserBottomSheet SafeArea [0e172c7]
* Add normal mode again to OnePageCard [c057d31]
* ScrollController in chatlist [93477d3]
* SafeArea on iPad [8911e64]
* Missing null check [7cb0dc4]
* Overflow in chat app bar [5bf5483]
* Select room version [2f5a73f]

### Docs
* Add code style [035ad96]

### Refactor
* Move app_config to /configs [8b9f4a4]
* homeserver picker view [8e828d8]
* widgets dir [c9ab69a]

## v0.28.1 - 2021-03-28

### Chore
* Update version [518634a]

### Feature
* Implement new search view design [e42dd4b]

### Fixes
* Share on iOS [ea31991]
* Permission to send video call [4de6d16]
* Unread badge color [49d5f86]
* Push on iOS [cb6217c]
* Add Podfile to gitignore [dd4b4c5]
* Own user in people list [ce047b7]
* Start chat [92ff960]
* Set status missing [17a3311]

### Refactor
* push stuff [b6eaf5b]

## v0.28.0 - 2021-03-16

### Chore
* Bump version [f8ee682]
* Change push gateway url [078aefa]
* Update file picker cross dependency [91c6912]
* Update snapcraft.yaml but still not working [1072379]
* Update changelog [a05f2f0]
* Change call icon [7403ac7]
* Update famedlySdk [ec64cf6]

### Feature
* Cache and resend status message [c8a7031]
* New experimental design [94aa9a3]
* Better verification design [9bcd6b2]
* Verify and block devices in devices list [8ebacfe]

### Fixes
* substring in reply key respects unicode runes [5695342]
* Resend status message [05cd699]
* Remove test push [a838d90]
* Email validation [c8e487c]
* CI [2e60322]
* CI [7275837]
* CI [1a8dc50]
* CI [c012081]
* CI [380732d]
* CI [06c31c0]
* CI [4d1a171]
* CI [597ceab]
* snapcraft CI [fee0eb9]
* Bootstrap in columnview [bcd2a03]
* Remove unnecessary snapcraft dependencies [3a816d1]
* Snapcraft and it builds now :-) [eb0eca4]
* flutter_matrix_html crash and flutter_maths stuffs [3caac92]
* Minor bugs [9fbfca6]
* add mail [53fc634]
* 3pid [887f3b1]
* Bootstrap hint [8651b37]
* Bootstrap hint [1331b10]
* Own presence at top of the list [ac6fcd1]
* Analyzer [e1ddfc8]
* Trim username on registration [61a8eb5]
* Password success banner if not succeeded [5150563]
* Status color [42d9bf5]
* Routes [6faa60e]
* Dialog using wrong Navigator [9458ab3]
* sso on web [aa396ac]
* Missing localizations in dialogs [9b1d7ec]
* Tap on notification to open room in (hopefully) all cases [57560ff]
* Allow screenshots again [6258b6a]
* Missing tooltips in IconButtons [57a021f]
* empty horizontal stories list [b1f6209]
* Line color [3d59d9a]
* Dont show random users in top bar [54e268b]
* Localize ok cancel alert dialogs [9f9b833]
* Use single-isolate push [949771d]

### Docs
* Update readme and contributing [449e46d]
* Update Turkish translation for website [4a664eb]

### Refactor
* Update SDK and enable login with email and phone [864b665]
* Migrate to flutter 2 [bb97b1b]
* Switch to TextButton [55803d1]

## v0.27.0 - 2021-02-17

### Chore
* Switch to experimental new hedwig [30a1fb0]
* update sdk & remove selfSign [26f7cb3]
* Update sdk [cde8a30]
* Update unified push [e73f5d5]
* Change push gateway port [8f36140]

### Feature
* localize bootstrap [395e62e]
* Add more bootstrap features [e4db84a]
* Add some tooltipps [b9eb8d1]
* Get jitsi instance from wellknown [bd24387]
* Make font size configurable [ea1bb89]
* Allow manual verification of other peoples devices [ad3c89b]
* Simplified bootstrap [d9984da]
* new design [33dd1d2]
* Implement reporting of events [d553685]
* Implement experimental new design [10cf8da]
* Deprecated authwebview and use platform browser [d7aae3a]
* Implement autofillhints [41a2457]

### Fixes
* Website [080a909]
* docs _site dir [875d652]
* Bootstrap dialog [c72da0a]
* Bootstrap wipe [774f674]
* MetaRow fontsize [a13e673]
* Stories displayname cropping [6f06c6a]
* Update read receipt display [de6e495]
* Bottom padding of chat list [aa5ce56]
* Hard to read titles in chat details [df90136]
* Website urls [295c113]
* applock enter non digits [5726c4f]
* Update contact list [d870ec3]
* Better error in discover [0c1864c]
* Minor fixes [c058d39]
* Share view [2bd00e6]
* Endless bootstrap loading [65d5f9a]
* More minor fixes [4c10ef5]
* Default offline state [72604c6]
* Remove old code [14f633b]
* Inputborder [6960618]
* Unlock the mutex [5789a86]
* Wrong fab action [5429697]
* SecureStorage sometimes reading wrong / bad values [d94f0d7]
* Wrong urls [29076db]
* Start chat with yourself from status [f3b3584]
* BottomNavigationbar colors [08f24d7]
* Emote settings and discovery fallback [8f8b8d8]
* reportEvent uses positive int [408c810]
* Autofillhints on readonly [baafebb]
* Bring back proper emote settings [6b01a83]
* Build ios [f5b1ae8]
* iOS bundle id [6a70830]
* iOS push [2bf184a]
* iOS push [c01bdf7]

### Docs
* Fix qr-codes [c7f0a74]
* grammar fixes [c4d569b]

### Refactor
* Theme colors [fe13778]
* border radius [ddd10d1]

## v0.26.1 - 2021-01-26

### Chore
* Update SDK [e9df6bf]
* Bump version [d79b356]
* Update dependencies [6159f99]

### Feature
* Add unified push as push provider [124a5ee]

### Fixes
* Link color [16d6623]

## v0.26.0 - 2021-01-25

### Chore
* Redesign textfields [aef8090]
* Simplify bootstrap [2df4a78]
* Update audio player icons [3f14d5e]
* Redesign homepicker page [e402a02]
* Remove unused dependency [2089e62]
* Update SDK [a05215f]
* Update readme [19f1df7]
* Change startpage design [4b8ad1b]
* Log warning if firebase token problem [90867e6]
* Update dependencies [a56f939]
* Redesign homeserver picker page [3c71351]
* Increase max size of message bubbles [8477385]
* Use correct paths on new server [2f00007]

### Feature
* emoji working on desktop [c3feb65]
* Implement sso [d1d470d]
* Implement app lock [77ee2ef]
* Dismiss keyboard on view scroll. [70f96bf]
* Display version number in app [e1e60c4]

### Fixes
* Dark mode fixes [36746c8]
* Dark theme [0bd0e58]
* clean up iOS dir [6ae59a8]
* Homeserver readonly if conifg wants it [c81158a]
* Search mxid for private chat [b6dca5b]
* Remove unnecessary padding [5f54057]
* Foreground push again [1d6c9cf]
* Foreground push [ea1cefa]
* embedding all fonts to fix the font error [55c6379]
* Minor desktop fixes [c224993]
* fonts in a standard path [bfa5601]
* Make tapping on pills join if remote directory is private [8ffb3db]
* key verification dialog button order [c5adfc2]
* Allow joining of unpublished aliases again [ed570a6]
* Make tap on pills and matrix.to links work again [48ad322]
* Load settings on startup [6906832]
* Persistent settings [03b00b7]
* Voice message recording dialog [d273b2a]
* UserBottomSheet [38e8e1b]
* Dialogs [5f0ce49]
* no exception if token is just null [db349a5]
* Load config.json only on web [a04c3ab]
* App lock [8d6642c]
* cross file picker [d47f855]
* Send file [fde2f8b]
* APL [913f3cf]
* app lock [6d12168]
* mxid validation [25da65f]
* Startpage textfield padding [81e706a]
* Provider in user bottom sheet [48d6fbd]
* Readme [dda0925]

### Docs
* Make howtofork.md less misunderstandable [96de54a]
* Add howtofork.md [f091469]
* Mention emoji font [bb53714]
* Add famedly contact link [7f2d61e]
* Update fdroid button [ea7e20b]

### Refactor
* Theme and iOS stuff [189f65a]
* Upgrade to latest flutter_sound_lite [2f7dece]

## v0.25.1 - 2021-01-17

### Chore
* Bump version [c881424]

### Fixes
* Change size [83e2385]

### Refactor
* remove deprecated approute [be08de5]

## v0.25.0 - 2021-01-16

### Chore
* Minor design improvements [d4dbe83]
* Minor design tweaks [06581e2]
* Bump version [7f51f7f]
* redesign start first chat [e13a732]
* Better authwebview [d76df0a]

### Fixes
* Share files [d018a4b]
* Typing update [9b5a3ca]
* Status [d27dbe0]
* Set status [7063b34]
* Column width [a35c4d0]
* Dont send only whitespaces [c0958c6]
* BuildContext in key verification dialog [c4866c7]
* Ignore list [0458064]
* Archive route [5e62267]
* Remove popup menu item [5945bcc]
* chat padding [079c35e]
* Remove logs [8910772]
* Video calls [672eca6]
* loading history [a5e9553]
* Missing divider [cf07eed]
* loading dialog configs [de2796e]
* Display current theme mode [41483dd]
* Better authwebview [5a1085a]
* authwebview [2f7749a]
* Minor apl bugs [05b9551]

### Docs
* Update fdroid logo [31d16a0]

### Refactor
* Use APL [cbcfa15]
* Use Provider [880f9cc]
* Use adaptive_theme [5d52c26]

## v0.24.3 - 2021-01-15

### Chore
* Bump version [46c8386]
* Update SDK [ba0726c]
* Update fdroid domain [f130681]
* Update dependencies [611e5e3]

### Feature
* Add Turkish translations for website [817c7dd]
* Handle matrix: URIs as per MSC2312 [1da643f]

### Fixes
* Format [84b2ac9]
* Push gateway url [ed2fbf7]

## v0.24.2 - 2021-01-08

### Chore
* Update linux version [ef9369c]
* Update SDK [4a006c9]

### Feature
* Regulate when thumbnails are animated as per MSC2705 [f5e11c2]

### Fixes
* Don't allow an empty ssss passphrase in key verification [3a0ce79]
* reactions [92684da]
* Reply fallback sometimes being stripped incorrectly [e9ec699]
* Don't show loading dialog on request history [e4b6e10]
* Properly handle url encoding in matrix.to URLs [baccd0a]

### Refactor
* Switch to loading dialog [e84bc25]

## v0.24.1 - 2020-12-24

### Chore
* Update linux build [a91407f]
* Add website to main repo [4df33a1]
* Update dependencies [0d9f418]
* Change main docs [56d97f6]
* Update SDK and logviewer [45b9c4f]
* Context icon improvements [6381cea]
* Update SDK [e802593]

### Feature
* Better invite search bar [3c4a29b]
* Open alias in discover page [f0d1f5a]
* Implement logger [714c7b4]

### Fixes
* auto-dep update [d9e8c5f]
* Read receipts and filtered events [0ae36f0]
* Don't re-render the lock icon nearly as often [00a56a7]
* Format [e0bc337]
* Analyzer [5d8bfa3]
* logger [64c5ea9]
* Have a space after mentions, making it consistent with @-completion [b18e81a]
* Display right key in key request dialog [f8e8e96]
* Respect hidden events when calculating read receipt message [702895f]
* Store emoji picker history and make sure you can't send the same emoji twice [0066a33]
* Logger [0abebdd]
* Allow key verification to scroll vertically [accd9b4]
* Make filter input field auto-lose focus when entering room view [bdb695e]
* Update file picker [6df75d1]

## v0.24.0 - 2020-12-18

### Chore
* Update dependencies [550cb4a]
* Update SDK [775a33b]
* Update dependencies [644433c]
* Switch to upstream noti settings [5cc4265]
* Go back to upstream open noti settings [6effebe]
* Update dependencies [5af4eab]

### Feature
* Add languages to iOS [68a5efb]
* Bring back config.json [b6a0d37]
* Implement emojipicker for reactions [20b3157]
* Add config hideTypingUsernames [19c0440]
* Implement hideAllStateEvents [721c0b2]
* Enhanced configuration [1e7bac3]
* Implement experimental bootstrapping [f6945f7]
* add ability to mark a room as unread [fe2b391]
* Try out new firebase [41a471e]
* Implement discover groups page [e728ccc]
* Add chat permissions settings [bf4b439]
* Multiline dialog text field [8d05a83]
* Implement rich notification settings [87a73dd]

### Fixes
* Update typing [3d70b1e]
* Build in dev [f892a9f]
* Fix that damn regex [8961bff]
* CI [ebb114d]
* CI [0adeb09]
* Format [9e5fb70]
* CI scripts [46b886f]
* join public room [30883e5]
* CI [7f44982]
* open_noti_settings [f4c1202]
* Missing localization [cb191e2]
* Analyzer bug [be428dd]
* Set chat avatar on web [621fcb7]
* CI [da5bc56]

### Refactor
* Update sdk [32acc21]

## v0.23.1 - 2020-11-25

### Fixes
* Release CI [14d8c80]

## v0.23.0 - 2020-11-25

### Chore
* Update adaptive dialogs [0061660]
* Prettier redacted events [d1e291e]
* Minor design changes in user viewer [b4fb283]
* Minor design changes in chatlist item [6977112]
* Implement playstore CD [4c5760c]
* Only load google services if needed [bae779a]

### Feature
* Next version [1af048e]
* Annoy user with dialog to add a recovery method [d9ec9f6]
* Implement password recovery [4b2fef5]
* Collapse room create states [fc0c038]
* Minor design improvements [0b8cc24]
* Improved encryption UI [2516848]

### Fixes
* Broken dialog [97bb692]
* set email dialog [72e325a]
* Minor fixes [11e2dd5]
* redacted icon color [d60709b]
* Unban [f056e65]
* Minor design issues [d9590dd]
* Buttons in chatlist [7d08817]
* Sendername prefix [a6b60ad]
* Sendername prefix [8aaff6f]
* Minor key request design fix [0ed29b6]
* removal of appbundle from the release artifacts [b1c248f]
* Copying an event did not obey edits [0cb262c]
* Suggest correct rooms [59ec9de]

### Refactor
* Make verification in dialogs [1f9e953]
* matrix to link prefix [1aa9c08]

## v0.22.1 - 2020-11-21

### Fixes
* Input bar not working, making app unusable [10773b4]

## v0.22.0 - 2020-11-21

### Chore
* fix CI [00ed0d6]
* fix CI [bb4bb9f]
* Fix CI variables [d3822b0]
* update flutter_matrix_html [ed27bee]
* update flutter_matrix_html [af36533]
* Update dependencies [57256fb]
* Update dependencies [40825e1]
* Switch to adaptive dialogs [9ea7afc]
* Switch from bottoast to flushbar [e219593]
* Clean up CI [7e84675]
* Remove unused dependency [d12de2d]

### Feature
* Add svg support and better image handling [f70bbc3]
* add config.json [4b7fb6b]
* persistent upload of release artifacts [1b2481b]
* Option to hide redacted and unknown events [36315a4]
* Better encryption / verification [1ff986e]

### Fixes
* iOS [26731ab]
* resolve some sentry issues [61f35e8]
* resolve some sentry issues [2c3693e]
* iOS build [9fee409]
* Automatic update deps job [255c05d]
* Don't re-render message widgets on insertion of new messages, making e.g. audio playing not stop [25b2997]
* Add missing safearea [caab868]
* no pushers enpdoint [b3942ad]
* Sentry and small null fix [5dc22be]

### Refactor
* CI [34d7fdd]
* SDK update [7e23280]

## v0.21.1 - 2020-10-28

### Chore
* update version code [d1dfa9c]

## v0.21.0 - 2020-10-28

### Chore
* Change compileSdkVersion again [f93f9c2]
* Update packages [b471bd0]
* Update SDK [86a385d]
* New version [40d00b0]
* Update flutter_matrix_html [4981cf4]
* Update sdk [8773770]
* Only load google services if needed [051ec8f]
* release [844b4a8]

### Fixes
* CompileSDKVersion [bcf75fc]
* Target sdk [c3e23b6]
* File picker issue [aa191c1]
* Sentry [b903ea9]
* user bottom sheet design [7876164]
* Android Download [8a542bf]
* Avatar Border Radius [a8b617e]
* loading spinner stuck on broken images [e917879]
* send file dialog - prevent multiple file sending [941b211]
* Multiple related store things [36405f8]
* Logo background color [42a927e]

## v0.20.0 - 2020-10-23

### Chore
* update dependencies [427cdc0]
* upate matrix link text [0892ca9]
* Change default linux window size [719323a]
* Update changelog [ef22778]
* Update matrix_link_text [fc2a0c0]
* update flutter_secure_store [61c6aec]
* Minor snap fix [daf9969]
* Add privacy informations to app [e569be7]
* Make app ready for flutter 1 22 [e5b23fa]

### Feature
* Implement mouse select chat list items [6d41136]
* Implement linux desktop notifications [75cd6f1]
* Implement change device name [bfd3888]
* Publish as snap [46590d7]
* Enhance emote experience [cafd639]
* Implement new status feature [090795f]
* More beautiful status [d9c2d4f]
* Enhance roomlist context menu [493b700]
* Implement basic windows linux support [7fad316]
* Enable macOS build [a845209]

### Fixes
* return text field to the previous state after editing message [08e61c0]
* Web server picker [4cb19be]
* Some single-emoji names crashing [b29ebce]
* Snapcraft [c1eebc1]
* Minor design fix [a713a2f]
* Minor design fixes [e9aa285]
* Change device displayname [c5c7ee7]
* LocalStorage location on desktop [81e32c5]
* fixed mxid input method, removed code redundancy [060156c]
* overgo issues with flutter_secure_store [6d0f344]
* resize images in a separate isolate [56967a9]
* Build Linux CI [a941356]
* Build Linux CI [2a6b5d8]
* send images as images, not files [751dcb7]
* Show device name in account information correctly [468c258]
* Minor fixes [aee854e]
* Make theme loading work properly [f6ab1e0]
* CI [6b7d21d]
* User Status crash [0413b0c]
* small desktop fixes [540ff68]
* Desktop url launcher [4dfd0db]
* Snap [ec7dd2b]
* Snap [4648466]
* CI [4345df3]
* Linux database [772ff33]
* TextField [7ec349b]
* Inputbar focus [5e673c6]
* Desktop file picker [662e2f1]
* Desktop images [5409fe8]
* Try with select 1 [6e924cb]
* More debug logs [9b572f5]
* Minor design bugs [6ffbf16]
* Minor user status bugs [f84ac1d]
* Improve loading dialogs [41ceb84]
* Invite left members [fe649e5]
* tapping on aliases not always working [c0390ca]
* determine 12h/24h time based on settings, not locale [ca19e9f]
* fix up translations to use keys and fix arb files [74b15dd]

## v0.19.0 - 2020-09-21

### Chore
* Version update & olm-CI [0f805a2]
* Update SDK & Changelog [1825543]
* Add new language [c6d67ad]
* master --> main [1de3c54]
* switch to cached_network_image [bbca0c2]
* update dependencies [2a62cf8]
* Add more debugging logs to debug key decrypt issues [20d3ea9]
* Update SDK, re-enable transactions on mobile [1f4c2a1]
* update languages [40e9544]
* Updat changelog [d1e898c]
* update sdk [954eedb]

### Feature
* Implement send reactions [6bf25b7]
* Improve design [c8a63c6]
* Display emotes/emojis bigger [9cccd07]
* Add scroll-to-event [8547422]
* Implement ignore list [b2fa88c]
* Add license page [dcf4c4c]
* Implement rich push notifications on android [f4e4b90]
* Implement sentry [705ced8]
* Send image / video / file dialog [80114df]
* Blurhashes and better thumbnails [2321829]
* open links better [04cbf0c]
* Implement web audio player [0f6b46d]
* New notification sound [8a5be21]

### Fixes
* Last bits for the release [1db9bdd]
* Small stuff [9d3f272]
* Search bar [eca25de]
* font size being too large accidentally in some places [43dd222]
* Scroll down button not showing [8cd8f90]
* Don't double-confirm sending audio messages [168b8b0]
* Hotfix ignore list [94f8f34]
* Push on conduit [e5cd144]
* Images with an info block but no size crashing [5f58789]
* Allow requesting past messages if all events in the current timeline are filtered [0f9ff4a]
* annoying notification sound [739a70c]
* Status design [f7930fe]
* Send read receipt only on focus [98316f1]
* Desktop notifications [b05bfa6]


This CHANGELOG.md was generated with [**Changelog for Dart**](https://pub.dartlang.org/packages/changelog)

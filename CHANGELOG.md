# Version 0.17.0 - 2020-08-??
### Fixes:
- Don't re-render the room list nearly as often, increasing performance

# Version 0.16.0 - 2020-07-24
### Features
- Implement web notifications
- Implement a connection status header	
### Changes
- Switch out database engine for faster performance
- Greatly improve startup time
- Added languages: Galician, Croatian, Japanese, Russian, Ukrainian - Thanks a lot to all the weblate users!
- Only show the microg toast once, if you have play services disabled
- Homeserver URL input now strips trailing whitespace and slash - Thanks @Katerina
- Also use prev_content to determine profile of a user: This allows the username and avatar of people who left a group to still be displayed
### Fixes:
- Fix not being able to initiate key verification properly
- Fix message sending being weird on slow networks
- Fix a few HTML rendering bugs
- Various other fixes
- Fix the 12h clock showing 00:15am, instead of 12:15am	- Thanks @not_chicken
- Fix an issue with replies and invalid HTML
- Fix messages getting lost when retrieving chat history
- Fix a bug where an incorrect string encoding from the server is assumed
- Fix a bug where people couldn't log in if they had email notifications enabled

# Version 0.15.1 - 2020-06-26
### Fixes:
- Fix a big with account data being stored incorrectly

# Version 0.15.0 - 2020-06-26
### Features:
- New room list app bar design
- Chat app bar transparent
- Implement web file picker
- Minor design and UX improvements
- Implement Cross Signing
- Restore keys from online key backup
- Added translations: Czech, Spanish, Slovakian
### Changes:
- Show presences of users sharing a direct chat
- Big refactoring
### Fixes:
- Various fixes, including e2ee fixes and olm session recovery

# Version 0.14.0 - 2020-05-20
### Features:
- Implement image viewer
- Implement room pills
- New chat appBar showing presences and room avatars
- Implement well-known support
### Fixes:
- Minor fixes, refactoring and performance improvements

# Version 0.13.2 - 2020-05-13
### Fixes:
- Fix textfields copy&paste
- Clean up pushers on server
- Show rich notifications

# Version 0.13.1 - 2020-05-11
### Fixes:
- Fix share content

# Version 0.13.0 - 2020-05-10
### Features:
- New status feature
- HTML rendering of messages
- Markdown support
- Enhanced chat list design
- New translations (Polish, Hungarian)
### Fixes:
- Lots of minor fixes and refactoring

# Version 0.12.4 - 2020-04-17
### Fixed
- Login without google services

# Version 0.12.2 - 2020-04-12
### Changes:
- New set homeserver UX
### Fixed
- Fix toasts when switching views
- Fix image flickering
- Fix login without google services
- Fix toasts

# Version 0.12.0 - 2020-04-10
### Features:
- Implement custom wallpapers
- Lightweight Jitsi integration for video calls
- Use SKIA for web
### Fixes:
- Fix image scaling
- Minor bugfixes

# Version 0.11.0 - 2020-04-02
### Features:
- Share content with FluffyChat
### Fixes:
- Minor bugfixes

# Version 0.10.1 - 2020-03-29
### Fixes:
- Fix a lazy loading bug
- Improve app icon

# Version 0.10.0 - 2020-03-29
### New features
- Voice messages
- New message bubble design
### Changes:
- Use SnackBars instead of Toasts
### Fixes:
- Minor fixes in the SDK
- Loading dialog when sending files is displayed too long
- Fixed device settings list

# Version 0.9.0 - 2020-03-13
### New features
- Improved design
- End2End encryption for normal messages (not yet files)
- Key sharing
- Device keys verification UI
### Fixes
- Minor bug fixes

# Version 0.8.2 - 2020-02-17
### Fixes
- SpeedDial labels not visible in light mode

# Version 0.8.1 - 2020-02-16
### New features
- Dark mode

# Version 0.8.0 - 2020-02-16
### New features
- Image Viewer
- Improved UX design
- Experimental End-to-end encryption in the web version

# Version 0.7.2 - 2020-02-10
### Changed
- Invite link text
### Fixed
- Replies on replies fixed

# Version 0.7.1 - 2020-02-10
- Replies with correct sender id

# Version 0.7.0 - 2020-02-10
### New features
- Select mode in chat
- Implement replies
- Add scroll down button in chat

# Version 0.6.0 - 2020-02-09
### New features
- Add e2ee settings
- Minor design improvements
### Fixes
- Minor bugs fixed

# Version 0.5.2 - 2020-01-29
### Changes
- New default homeserver: tchncs.de
### Fixes
- Translation fixed
- Parsing of m.room.aliases events

# Version 0.5.1 - 2020-01-28
### Changes
- Refactoring under the hood
### Fixes
- Fixed the bug that when revoking permissions for a user makes the user an admin
- Fixed the Kick user when user has already left the group

# Version 0.5.0 - 2020-01-20
### New features
- Localizations
- Enhanced group settings
- Username search
### Fixes
- Minor bug fixes
- Invite to direct chat

# Version 0.4.0 - 2020-01-18
### New features
- Registration
- Avatars with name letters
- Calc username colors
### Fixes

# Version 0.3.0 - 2020-01-17
### New features
- Improved design
- Implement signing up (Still needs a matrix.org fix)
- Forward messages
- Content viewer
### Fixes
- Chat textfield isn't scrollable on large text
- Text disappears in textfield on resuming the app

# Version 0.2.3 - 2020-01-08
### New features
- Added changelog
- Added copy button
### Fixes
- Groups without name now have a "Group with" prefix

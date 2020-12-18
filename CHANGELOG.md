# Change Log for fluffychat
Chat with your friends.

## Unreleased

### Chore
* Update dependencies [550cb4a]
* Update SDK [775a33b]
* Update dependencies [644433c]
* Switch to upstream noti settings [5cc4265]
* Go back to upstream open noti settings [6effebe]
* Update dependencies [5af4eab]

### Feature
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

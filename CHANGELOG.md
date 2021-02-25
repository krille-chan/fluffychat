# Change Log for fluffychat
Chat with your friends.

## Unreleased

### Chore
* Change call icon [7403ac7]
* Update famedlySdk [ec64cf6]

### Feature
* New experimental design [94aa9a3]
* Better verification design [9bcd6b2]
* Verify and block devices in devices list [8ebacfe]

### Fixes
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

# fluffychat

Chat with your friends.

[Install using F-Droid](https://mtrnord.gitlab.io/fluffychat-flutter-fdroid/fdroid/repo/)

Community: [#fluffychat:matrix.org](https://matrix.to/#/#fluffychat:matrix.org)

## How to build

1. [Install flutter](https://flutter.dev)

2. Clone the repo

### Android / iOS

3. `flutter run`

### Web

3. `flutter channel beta && flutter upgrade`

4. `flutter config --enable-web`

5. `flutter run`

## How to add translations for your language

1. Replace the non-translated string in the codebase:
```
Text("Hello world"),
```
with a method call:
```
Text(I18n.of(context).helloWorld),
```
And add the method to `/lib/i18n/i18n.dart`:
```
String get helloWorld => Intl.message('Hello world');
```

2. Add the string to the .arb files with this command:
```
flutter pub run intl_translation:extract_to_arb --output-dir=lib/i18n lib/i18n/i18n.dart
```

3. Copy the new translation objects from `/lib/i18n/intl_message.arb` to `/lib/i18n/intl_<yourlanguage>.arb` and translate it or create a new file for your language by copying `intl_message.arb`.

4. Update the translations with this command:
```
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/i18n --no-use-deferred-loading lib/i18n/i18n.dart lib/i18n/intl_*.arb
```

5. Make sure your language is in `supportedLocales` in `/lib/main.dart`.
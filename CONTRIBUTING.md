# How you can contribute to FluffyChat

Thanks for using FluffyChat and thanks for your decision to contribute. ❤❤❤ There are multiple ways how you can help us:

## Social Media:
We always need help with social media stuff. We don't have much time and the time we have we spend in developing. So we often lack to spread news about new features to the world.
Just contact us at [#fluffychat:matrix.org](https://matrix.to/#/#fluffychat:matrix.org).

## Translations:
You can add translations for your language easily. Just download this file [intl_messages.arb](https://gitlab.com/ChristianPauly/fluffychat-flutter/-/raw/master/lib/i18n/intl_messages.arb) and translate it to your language. Then you can either send us the file and we add it to the project or you can do this by yourself in these steps (for mor experienced users):

1. Create a GitLab account if you don't have one.
2. Fork the project.
3. Create a new .arb file in /lib/i18n and name it with the country code of your language. For example with klingon you name it **intl_kl.arb**.
4. (Optional) If you are a Flutter developer, execute this command to add the translations to the project: 
```
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/i18n --no-use-deferred-loading lib/i18n/i18n.dart lib/i18n/intl_*.arb
```
5. Start a new Merge Request and become a hero. ❤❤❤

## Bug reports:
Bug reporting and issue tracking is a huge task. We need help with:
1. Sort and label issues.
2. Find duplications.
3. Track issues over the whole life cycle.
4. Find bugs and add them to the issue list.

## Donations:
If you don't have any time but too much money you could either buy Apple products or support the development of FluffyChat. 😇 There are two ways of donations:
- [Buy me a coffee](https://ko-fi.com/krille)
- [Monthly donations](https://liberapay.com/Krille)
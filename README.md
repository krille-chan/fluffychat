![](https://i.imgur.com/wi7RlVt.png)

<p align="center">
  <a href="https://matrix.to/#/#fluffychat:matrix.org" target="new">Join the community</a> - <a href="https://metalhead.club/@krille" target="new">Follow me on Mastodon</a> - <a href="https://hosted.weblate.org/projects/fluffychat/" target="new">Translate FluffyChat</a> - <a href="https://gitlab.com/ChristianPauly/fluffychat-website" target="new">Translate the website</a> - <a href="https://fluffychat.im" target="new">Website</a> - <a href="https://gitlab.com/famedly/famedlysdk" target="new">Famedly Matrix SDK</a> - <a href="https://famedly.com/kontakt">Server hosting and professional support</a>
 </p>
<br>
<br>

FluffyChat is a multi-platform Matrix client written in Dart/Flutter. It compiles to native code von Android, iOS, macOS, Windows and Linux and renders with Skia on the web. FluffyChat is just a hobby project from the developers of [Famedly](https://famedly.com) and licensed under AGPLv3. It follows a [design philosophy](https://ko-fi.com/post/FluffyChats-Design-Philosophy-W7W63A6YS) to be minimalistic, inclusive and easy to use.

# How to build

1. [Install flutter](https://flutter.dev)

2. Clone the repo:
```
git clone --recurse-submodules https://gitlab.com/famedly/fluffychat
cd fluffychat
```

3. Choose your target platform below and enable support for it.

4. Debug with: `flutter run`

### Android

* Install CMake from the SDK Manager

* Install ninja:
```
sudo apt install ninja-build
```

* Build with: `flutter build apk`

### iOS / iPadOS

* Have a Mac with Xcode installed, and set up for Xcode-managed app signing
* If you want automatic app installation to connected devices, make sure you have Apple Configurator installed, with the Automation Tools (`cfgutil`) enabled
* Set a few environment variables
    * FLUFFYCHAT_NEW_TEAM: the Apple Developer team that your certificates should live under
    * FLUFFYCHAT_NEW_GROUP: the group you want App IDs and such to live under (ie: com.example.fluffychat)
    * FLUFFYCHAT_INSTALL_IPA: set to `1` if you want the IPA to be deployed to connected devices after building, otherwise unset
* Run `./scripts/build-ios.sh`

### Web

* Enable web support in Flutter: https://flutter.dev/docs/get-started/web

* Build with:
```bash
./scripts/prepare-web.sh
flutter build web --release
```

* Optionally configure by serving a `config.json` at the same path as fluffychat.
  An example can be found at `config.sample.json`. None of these
  values have to exist, the ones stated here are the default ones. If you e.g. only want
  to change the default homeserver, then only modify the `default_homeserver` key.

### Desktop (Linux, Windows, macOS)

* Enable Desktop support in Flutter: https://flutter.dev/desktop

* Build with one of these:
```bash
flutter build linux --release
flutter build windows --release
flutter build macos --release
```


# How to add translations for your language

You can use Weblate to translate the app to your language:

https://hosted.weblate.org/projects/fluffychat/

If you want to get your translated strings approved, please ask in our
<a href="https://matrix.to/#/#fluffychat:matrix.org" target="new">support room</a>!

1. Replace the non-translated string in the codebase:
```
Text("Hello world"),
```
with a method call:
```
Text(L10n.of(context).helloWorld),
```

and add the following import if missing:

```
import 'package:flutter_gen/gen_l10n/l10n.dart';
```

2. Add the string to `/lib/l10n/l10n_en.arb`:

(The following example need to be sorounded by the usual json `{}` and after the `@@locale` key)

Example A:
```
"helloWorld": "Hello World!",
"@helloWorld": {
  "description": "The conventional newborn programmer greeting"
}
```

Example B:
```
"hello": "Hello {userName}",
"@hello": {
  "description": "A message with a single parameter",
  "placeholders": {
    "userName": {
      "type": “String”,
      “example”: “Bob”
    }
  }
}
```

3. For testing just run a regular build without extras

# Android push notifications without FCM
Fluffychat has the ability to receive push notifications on android without FCM via the
[UnifiedPush](https://github.com/UnifiedPush) project, e.g. using gotify as push backend. As the project is still pretty new
there might still be some bugs, overall it seems to be working, though.

While UnifiedPush also supports p2p push via [NoProvider2Push](https://github.com/NoProvider2Push/android)
here the gotify setup will be outlined. Adapt re-write proxies accordingly, if you want to use a different push provider.

For self-hosted push with gotify you have to install and configure [gotify-server](https://github.com/gotify/server)
with [UnifiedPush](https://github.com/UnifiedPush/contrib/blob/main/providers/gotify.md) support.

Next, you add the `repo.unifiedpush.org` repository to fdroid and install the gotify client via it. Log into your gotify account and push notifications should work!

## Matrix-specific re-write proxy
Until [MSC2970](https://github.com/matrix-org/matrix-doc/pull/2970) is figured out we unfortunately
need another simple re-write proxy. By default the one at https://matrix.gateway.unifiedpush.org
is used, however you can easily self-host it. For that, add to your nginx config on the same domain you serve gotify the following (change *relay.example.tld*):
```
resolver 9.9.9.9;

location /_matrix/push/v1/notify {
    set $target '';
    if ($request_method = GET ) {
        return 200 '{"gateway":"matrix","unifiedpush":{"gateway":"matrix"}}';
    }
    access_by_lua_block {
        local cjson = require("cjson")
        ngx.req.read_body()
        local body = ngx.req.get_body_data()
        local parsedBody = cjson.decode(body)
        local accepted = "https://relay.example.tld/"
        ngx.var.target = parsedBody["notification"]["devices"][1]["pushkey"]
        ngx.req.set_body_data(body)
        if(string.sub(ngx.var.target,1,string.len(accepted))~=accepted) then ngx.var.target="http://0.0.0.0/"
        end
    }
    proxy_set_header Content-Type application/json;
    proxy_set_header Host $host;
    proxy_pass $target;
}
```

# Special thanks to

* <a href="https://github.com/fabiyamada">Fabiyamada</a> is a graphics designer from Brasil and has made the fluffychat logo and the banner. Big thanks for her great designs.

* <a href="https://github.com/advocatux">Advocatux</a> has made the Spanish translation with great love and care. He always stands by my side and supports my work with great commitment.

* Thanks to MTRNord and Sorunome for developing.

* Thanks to Mark for all his support and the chat background.

* Also thanks to all translators and testers! With your help, fluffychat is now available in more than 12 languages.

* <a href="https://github.com/googlefonts/noto-emoji/">Noto Emoji Font</a> for the awesome emojis.

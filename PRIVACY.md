# Privacy

FluffyChat is available on Android, iOS and as a web version. Desktop versions for Windows, Linux and macOS may follow.

*   [Matrix](#1)
*   [Sentry](#2)
*   [Database](#3)
*   [Encryption](#4)
*   [App Permissions](#5)
*   [Push Notifications](#6)

## Matrix<a id="1"/>
FluffyChat uses the Matrix protocol. This means that FluffyChat is just a client that can be connected to any compatible matrix server. The respective data protection agreement of the server selected by the user then applies.

For convenience, one or more servers are set as default that the FluffyChat developers consider trustworthy. The developers of FluffyChat do not guarantee their trustworthiness. Before the first communication, users are informed which server they are connecting to.

FluffyChat only communicates with the selected server, with sentry.io if enabled and with [OpenStreetMap](https://openstreetmap.org) to display maps.

More information is available at: [https://matrix.org](https://matrix.org)

## Sentry<a id="2"/>
FluffyChat uses Sentry for crash reports if the user allows it.

More information is available at: [https://sentry.io](https://sentry.io)

## Database<a id="3"/>
FluffyChat caches some data received from the server in a local database on the device of the user.

More information is available at: [https://pub.dev/packages/hive](https://pub.dev/packages/hive)

## Encryption<a id="4"/>
All communication of substantive content between Fluffychat and any server is done in secure way, using transport encryption to protect it.

FluffyChat is able to use End-To-End-Encryption as a tech preview.

## App Permissions<a id="5"/>

The permissions are the same on Android and iOS but may differ in the name. This are the Android Permissions:

#### Internet Access
FluffyChat needs to have internet access to communicate with the Matrix Server.

#### Vibrate
FluffyChat uses vibration for local notifications. More informations about this are at the used package:
[https://pub.dev/packages/flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

#### Record Audio
FluffyChat can send voice messages in a chat and therefore needs to have the permission to record audio.

#### Write External Storage
The user is able to save received files and therefore app needs this permission.

#### Read External Storage
The user is able to send files from the device's file system.

#### Location
FluffyChat makes it possible to share the current location via the chat. When the user shares their location, FluffyChat uses the device location service and sends the geo-data via Matrix.

## Push Notifications<a id="6"/>
FluffyChat uses the Firebase Cloud Messaging service for push notifications on Android and iOS. This takes place in the following steps:
1. The matrix server sends the push notification to the FluffyChat Push Gateway
2. The FluffyChat Push Gateway forwards the message in a different format to Firebase Cloud Messaging
3. Firebase Cloud Messaging waits until the user's device is online again
4. The device receives the push notification from Firebase Cloud Messaging and displays it as a notification

The source code of the push gateway can be viewed here:
[https://gitlab.com/famedly/services/famedly-push-gateway](https://gitlab.com/famedly/services/famedly-push-gateway)

`event_id_only` is used as the format for the push notification. A typical push notification therefore only contains:
- Event ID
- Room ID
- Unread Count
- Information about the device that is to receive the message

A typical push notification could look like this:
```json
{
  "notification": {
    "event_id": "$3957tyerfgewrf384",
    "room_id": "!slw48wfj34rtnrf:example.com",
    "counts": {
      "unread": 2,
      "missed_calls": 1
    },
    "devices": [
      {
        "app_id": "chat.fluffy.fluffychat",
        "pushkey": "V2h5IG9uIGVhcnRoIGRpZCB5b3UgZGVjb2RlIHRoaXM/",
        "pushkey_ts": 12345678,
        "data": {},
        "tweaks": {
          "sound": "bing"
        }
      }
    ]
  }
}
```

FluffyChat sets the `event_id_only` flag at the Matrix Server. This server is then responsible to send the correct data.

import 'package:famedlysdk/famedlysdk.dart';

extension ClientPresenceExtension on Client {
  List<Presence> get statuses => presences.values
      .where((p) => p.presence.statusMsg?.isNotEmpty ?? false)
      .toList();
}

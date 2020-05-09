import 'package:famedlysdk/famedlysdk.dart';

extension ClientPresenceExtension on Client {
  List<Presence> get statusList {
    final statusList = presences.values.toList().reversed.toList();
    statusList.removeWhere((p) => p.statusMsg?.isEmpty ?? true);
    statusList.reversed.toList();
    return statusList;
  }
}

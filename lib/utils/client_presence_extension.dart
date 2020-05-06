import 'package:famedlysdk/famedlysdk.dart';

extension ClientPresenceExtension on Client {
  List<Presence> get statusList {
    final statusList = presences.values.toList();
    statusList.sort((a, b) => b.time.compareTo(a.time));
    return statusList;
  }
}

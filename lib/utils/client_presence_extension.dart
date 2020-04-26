import 'package:famedlysdk/famedlysdk.dart';
import 'presence_extension.dart';

extension ClientPresenceExtension on Client {
  List<Presence> get statusList {
    final statusList = presences.values.toList();
    statusList.removeWhere((Presence p) => !p.isStatus);
    statusList.sort((a, b) => b.time.compareTo(a.time));
    return statusList;
  }
}

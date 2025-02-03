import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:matrix/matrix.dart';

extension AccountIdentiferExt on Client {
  bool get isSupportAccount => userID == Environment.supportUserId;
}

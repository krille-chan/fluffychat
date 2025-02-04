import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';

extension AccountIdentiferExt on Client {
  bool get isSupportAccount => userID == Environment.supportUserId;
}

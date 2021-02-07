import 'package:famedlysdk/famedlysdk.dart';
import 'package:famedlysdk/encryption.dart';
import 'platform_infos.dart';
import 'famedlysdk_store.dart';

class FluffyClient extends Client {
  static final FluffyClient _instance = FluffyClient._internal();

  /// The ID of the currently active room, if there is one. May be null or emtpy
  String activeRoomId;

  factory FluffyClient() {
    return _instance;
  }

  FluffyClient._internal()
      : super(
          PlatformInfos.clientName,
          enableE2eeRecovery: true,
          verificationMethods: {
            KeyVerificationMethod.numbers,
            if (PlatformInfos.isMobile || PlatformInfos.isLinux)
              KeyVerificationMethod.emoji,
          },
          importantStateEvents: <String>{
            'im.ponies.room_emotes', // we want emotes to work properly
          },
          databaseBuilder: getDatabase,
          supportedLoginTypes: {
            AuthenticationTypes.password,
            if (PlatformInfos.isMobile) AuthenticationTypes.sso
          },
        );
}

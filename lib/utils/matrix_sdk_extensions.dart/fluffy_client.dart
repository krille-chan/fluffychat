import 'package:matrix/matrix.dart';
import 'package:matrix/encryption.dart';
import 'package:fluffychat/utils/database/flutter_famedly_sdk_hive_database.dart';
import 'package:matrix_api_lite/fake_matrix_api.dart';
import '../platform_infos.dart';
import '../famedlysdk_store.dart';

class FluffyClient extends Client {
  static FluffyClient _instance;

  factory FluffyClient({testMode = false}) {
    Logs().level = Level.verbose;
    _instance ??= FluffyClient._internal(testMode: testMode);
    return _instance;
  }

  FluffyClient._internal({testMode = false})
      : super(
          testMode ? 'FluffyChat Widget Tests' : PlatformInfos.clientName,
          httpClient: testMode ? FakeMatrixApi() : null,
          enableE2eeRecovery: true,
          verificationMethods: {
            KeyVerificationMethod.numbers,
            if (PlatformInfos.isMobile || PlatformInfos.isLinux)
              KeyVerificationMethod.emoji,
          },
          importantStateEvents: <String>{
            'im.ponies.room_emotes', // we want emotes to work properly
          },
          databaseBuilder: testMode
              ? null
              : FlutterFamedlySdkHiveDatabase.hiveDatabaseBuilder,
          legacyDatabaseBuilder: testMode ? null : getDatabase,
          supportedLoginTypes: {
            AuthenticationTypes.password,
            if (PlatformInfos.isMobile || PlatformInfos.isWeb)
              AuthenticationTypes.sso
          },
        );
}

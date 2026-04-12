// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:fluffychat/config/setting_keys.dart';
// import 'package:fluffychat/pages/voip/controller/voip_plugin.dart';
// import 'package:matrix/matrix.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class VoipPluginController {
//   VoipPluginController(this.client, this.sharedPref);

//   final Client client;
//   final SharedPreferences sharedPref;

//   VoIP? get voip => _delegate?.voip;
//   VoipPlugin? _delegate;

//   bool get isPluginEnabled => AppSettings.experimentalVoip.value;
//   bool get isInitialized => voip != null;

//   void init() {
//     if (!isPluginEnabled) return;

//     if (isInitialized) return;

//     _delegate = VoipPlugin(this);
//   }

//   Future<VoipCallResult> startCall({required Room room, required CallType type}) async {
//     if (!isPluginEnabled) {
//       return const VoipCallResult.failure('VoIP is not enabled');
//     }

//     final platformError = await _checkPlatformSupport();
//     if (platformError != null) return VoipCallResult.failure(platformError);

//     if (!isInitialized) init();

//     try {
//       await voip?.inviteToCall(room, type);
//       return const VoipCallResult.success();
//     } catch (e) {
//       return VoipCallResult.failure(e.toString());
//     }
//   }

//   void dispose() {
//     _delegate?.voip = null;
//     _delegate = null;
//   }

//   void enable() {
//     AppSettings.experimentalVoip.setItem(true);
//     init();
//   }

//   void disable() {
//     AppSettings.experimentalVoip.setItem(false);
//     dispose();
//   }

//   Future<String?> _checkPlatformSupport() async {
//     try {
//       final androidInfo = await DeviceInfoPlugin().androidInfo;
//       if (androidInfo.version.sdkInt < 21) {
//         return 'Android SDK 21+ is required for VoIP';
//       }
//     } catch (_) {}
//     return null;
//   }
// }

// // ════════════════════════════════════════════
// // Union Type
// // ════════════════════════════════════════════
// sealed class VoipCallResult {
//   const VoipCallResult();
//   const factory VoipCallResult.success() = VoipCallSuccess;
//   const factory VoipCallResult.failure(String message) = VoipCallFailure;
// }

// class VoipCallSuccess extends VoipCallResult {
//   const VoipCallSuccess();
// }

// class VoipCallFailure extends VoipCallResult {
//   const VoipCallFailure(this.message);
//   final String message;
// }

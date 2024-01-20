// import 'dart:async';
// import 'dart:convert';

// import 'package:fluffychat/pangea/config/environment.dart';
// import 'package:fluffychat/pangea/constants/model_keys.dart';
// import 'package:fluffychat/pangea/network/urls.dart';
// import 'package:http/http.dart';

// import '../network/requests.dart';

// class TextToSpeechRequest {
//   String text;
//   String langCode;

//   TextToSpeechRequest({required this.text, required this.langCode});

//   Map<String, dynamic> toJson() => {
//         ModelKey.text: text,
//         ModelKey.langCode: langCode,
//       };
// }

// class TextToSpeechResponse {
//   String audioContent;
//   String mediaType;
//   int durationMillis;
//   List<int> waveform;

//   TextToSpeechResponse({
//     required this.audioContent,
//     required this.mediaType,
//     required this.durationMillis,
//     required this.waveform,
//   });

//   factory TextToSpeechResponse.fromJson(
//     Map<String, dynamic> json,
//   ) =>
//       TextToSpeechResponse(
//         audioContent: json["audio_content"],
//         mediaType: json["media_type"],
//         durationMillis: json["duration_millis"],
//         waveform: List<int>.from(json["wave_form"]),
//       );
// }

// class TextToSpeechService {
//   static Future<TextToSpeechResponse> get({
//     required String accessToken,
//     required TextToSpeechRequest params,
//   }) async {
//     final Requests request = Requests(
//       choreoApiKey: Environment.choreoApiKey,
//       accessToken: accessToken,
//     );

//     final Response res = await request.post(
//       url: PApiUrls.textToSpeech,
//       body: params.toJson(),
//     );

//     final Map<String, dynamic> json = jsonDecode(res.body);

//     return TextToSpeechResponse.fromJson(json);
//   }
// }

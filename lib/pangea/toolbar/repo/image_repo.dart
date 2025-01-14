import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../common/config/environment.dart';
import '../../common/network/requests.dart';

class GenerateImageeResponse {
  final String imageUrl;
  final String prompt;

  GenerateImageeResponse({
    required this.imageUrl,
    required this.prompt,
  });

  factory GenerateImageeResponse.fromJson(Map<String, dynamic> json) {
    return GenerateImageeResponse(
      imageUrl: json['image_url'],
      prompt: json['prompt'],
    );
  }

  factory GenerateImageeResponse.error() {
    // TODO: Implement better error handling
    return GenerateImageeResponse(
      imageUrl: 'https://i.imgur.com/2L2JYqk.png',
      prompt: 'Error',
    );
  }
}

class GenerateImageRequest {
  String prompt;

  GenerateImageRequest({required this.prompt});

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
      };
}

class ImageRepo {
  static Future<GenerateImageeResponse> fetchImage(
    GenerateImageRequest request,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    ); // Set your API base URL
    final requestBody = request.toJson();

    try {
      final Response res = await req.post(
        url: '/generate-image/', // Endpoint in your FastAPI server
        body: requestBody,
      );

      if (res.statusCode == 200) {
        final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
        return GenerateImageeResponse.fromJson(
          decodedBody,
        ); // Convert response to ImageModel
      } else {
        throw Exception('Failed to load image');
      }
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack, data: requestBody);
      return GenerateImageeResponse
          .error(); // Return an error model or handle accordingly
    }
  }
}

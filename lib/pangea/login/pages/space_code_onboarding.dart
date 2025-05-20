import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/login/pages/space_code_onboarding_view.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SpaceCodeOnboarding extends StatefulWidget {
  const SpaceCodeOnboarding({super.key});

  @override
  State<SpaceCodeOnboarding> createState() => SpaceCodeOnboardingState();
}

class SpaceCodeOnboardingState extends State<SpaceCodeOnboarding> {
  Profile? profile;
  Client get client => Matrix.of(context).client;

  final TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    _setProfile();
    codeController.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> _setProfile() async {
    try {
      profile = await client.getProfileFromUserId(
        client.userID!,
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'userId': client.userID,
        },
      );
    } finally {
      if (mounted) setState(() {});
    }
  }

  Future<void> submitCode() async {
    String code = codeController.text.trim();
    if (code.isEmpty) return;

    try {
      final link = Uri.parse(Uri.parse(code).fragment);
      if (link.queryParameters.containsKey(SpaceConstants.classCode)) {
        code = link.queryParameters[SpaceConstants.classCode]!;
      }
    } catch (e) {
      debugPrint("Text input is not a URL: $e");
    }

    await MatrixState.pangeaController.classController
        .joinClasswithCode(context, code);
  }

  @override
  Widget build(BuildContext context) =>
      SpaceCodeOnboardingView(controller: this);
}

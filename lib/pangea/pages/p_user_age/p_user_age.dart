// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:fluffychat/pangea/constants/age_limits.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/pages/p_user_age/p_user_age_view.dart';
import 'package:fluffychat/pangea/utils/p_extension.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/bot_name.dart';
import '../../utils/error_handler.dart';

class PUserAge extends StatefulWidget {
  const PUserAge({Key? key}) : super(key: key);

  @override
  PUserAgeController createState() => PUserAgeController();
}

class PUserAgeController extends State<PUserAge> {
  bool loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobController = TextEditingController();
  // #Pangea

  String? error;
  bool unknownErrorState = false;
  // DateTime? dateOfBirth;

  final PangeaController pangeaController = MatrixState.pangeaController;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => Matrix.of(context)
          .client
          .startDirectChat(
            BotName.byEnvironment,
            enableEncryption: false,
          )
          .onError(
            (error, stackTrace) =>
                ErrorHandler.logError(e: error, s: stackTrace),
          ),
    );
  }

  String? dobFieldValidator(String? value) {
    try {
      if (value?.isEmpty ?? true) {
        return L10n.of(context)!.yourBirthdayPleaseShort;
      }
      final DateTime dob = _textToDate!;
      if (!dob.isAtLeastYearsOld(AgeLimits.toUseTheApp)) {
        return L10n.of(context)!.mustBe13;
      }
      return null;
    } catch (err, stack) {
      ErrorHandler.logError(e: err, s: stack);
      return L10n.of(context)!.invalidDob;
    }
  }

  DateTime? get _textToDate {
    try {
      final DateTime initial = DateFormat.yMd().parse(dobController.text);
      return initial;
    } catch (err) {
      return null;
    }
  }

  DateTime get initialDate =>
      _textToDate ?? DateTime.now().subtract(const Duration(days: 13 * 365));

  //Note: used linear progress bar (also used in fluffychat signup button) for consistency
  createUserInPangea() async {
    try {
      setState(() {
        error = null;
      });
      if (!formKey.currentState!.validate()) return;
      setState(() {
        loading = true;
      });

      final String date = DateFormat('MM-dd-yyyy').format(_textToDate!);

      if (pangeaController.userController.userModel?.access == null) {
        await pangeaController.userController.createPangeaUser(dob: date);
      } else {
        await pangeaController.userController.updateUserProfile(
          dateOfBirth: date,
        );
      }
      // Matrix.of(context).widget.router!.currentState!.to(
      //       '/rooms',
      //       queryParameters:
      //           Matrix.of(context).widget.router!.currentState!.queryParameters,
      //     );
      FluffyChatApp.router.go('/rooms');
    } catch (err, s) {
      setState(() {
        unknownErrorState = true;
      });
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
    } finally {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return !unknownErrorState
        ? PUserAgeView(this)
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Text(
                "${L10n.of(context)!.oopsSomethingWentWrong} \n ${L10n.of(context)!.errorPleaseRefresh}",
              ),
            ),
          );
  }
}

import 'dart:developer';

import 'package:fluffychat/pangea/constants/age_limits.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/pages/p_user_age/p_user_age_view.dart';
import 'package:fluffychat/pangea/utils/p_extension.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../utils/error_handler.dart';

class PUserAge extends StatefulWidget {
  const PUserAge({super.key});

  @override
  PUserAgeController createState() => PUserAgeController();
}

class PUserAgeController extends State<PUserAge> {
  bool loading = false;
  int? selectedAge;
  TextEditingController dobController = TextEditingController();

  String? error;
  bool unknownErrorState = false;

  final PangeaController pangeaController = MatrixState.pangeaController;

  @override
  void initState() {
    super.initState();
    pangeaController.startChatWithBotIfNotPresent();
  }

  String? dobValidator() {
    try {
      if (selectedDate == null) {
        return L10n.of(context).yourBirthdayPleaseShort;
      }
      if (!selectedDate!.isAtLeastYearsOld(AgeLimits.toUseTheApp)) {
        return L10n.of(context).mustBe13;
      }
      return null;
    } catch (err, stack) {
      ErrorHandler.logError(e: err, s: stack);
      return L10n.of(context).invalidDob;
    }
  }

  DateTime? get selectedDate {
    if (selectedAge == null) return null;
    final now = DateTime.now();
    return DateTime(now.year - selectedAge!, now.month, now.day);
  }

  //Note: used linear progress bar (also used in fluffychat signup button) for consistency
  Future<void> createUserInPangea() async {
    try {
      setState(() => error = dobValidator());
      if (error?.isNotEmpty == true) return;
      setState(() => loading = true);

      final DateTime? dob =
          pangeaController.userController.profile.userSettings.dateOfBirth;

      if (dob == null) {
        await pangeaController.userController.createProfile(
          dob: selectedDate!,
        );
      } else {
        pangeaController.userController.updateProfile((profile) {
          profile.userSettings.dateOfBirth = selectedDate!;
          return profile;
        });
      }
      pangeaController.subscriptionController.reinitialize();
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

  void setSelectedAge(int? value) {
    setState(() {
      selectedAge = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !unknownErrorState
        ? PUserAgeView(this)
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Text(
                "${L10n.of(context).oopsSomethingWentWrong} \n ${L10n.of(context).errorPleaseRefresh}",
              ),
            ),
          );
  }
}

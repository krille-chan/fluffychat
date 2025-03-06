import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import '../../../config/themes.dart';
import '../../../widgets/matrix.dart';
import 'p_language_dropdown.dart';
import 'p_question_container.dart';

Future<void> pLanguageDialog(
  BuildContext parentContext,
  Function callback,
) async {
  final PangeaController pangeaController = MatrixState.pangeaController;
  //PTODO: if source language not set by user, default to languge from device settings
  final LanguageModel? userL1 = pangeaController.languageController.userL1;
  final LanguageModel? userL2 = pangeaController.languageController.userL2;
  final LanguageModel? systemLanguage =
      pangeaController.languageController.systemLanguage;

  LanguageModel? selectedSourceLanguage = systemLanguage;
  if (userL1 != null && userL1.langCode != LanguageKeys.unknownLanguage) {
    selectedSourceLanguage = userL1;
  }

  LanguageModel selectedTargetLanguage;
  if (userL2 != null && userL2.langCode != LanguageKeys.unknownLanguage) {
    selectedTargetLanguage = userL2;
  } else {
    selectedTargetLanguage = selectedSourceLanguage?.langCode != 'en'
        ? PLanguageStore.byLangCode('en')!
        : PLanguageStore.byLangCode('es')!;
  }

  return showDialog(
    useRootNavigator: false,
    context: parentContext,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: AlertDialog(
              title: Text(L10n.of(context).updateLanguage),
              content: SizedBox(
                width: FluffyThemes.columnWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PQuestionContainer(
                      title: L10n.of(context).whatIsYourBaseLanguage,
                    ),
                    PLanguageDropdown(
                      onChange: (p0) =>
                          setState(() => selectedSourceLanguage = p0),
                      initialLanguage:
                          selectedSourceLanguage ?? LanguageModel.unknown,
                      languages: pangeaController.pLanguageStore.baseOptions,
                      isL2List: false,
                      decorationText: L10n.of(context).myBaseLanguage,
                    ),
                    PQuestionContainer(
                      title: L10n.of(context).whatLanguageYouWantToLearn,
                    ),
                    PLanguageDropdown(
                      onChange: (p0) =>
                          setState(() => selectedTargetLanguage = p0),
                      initialLanguage: selectedTargetLanguage,
                      languages: pangeaController.pLanguageStore.targetOptions,
                      isL2List: true,
                      decorationText: L10n.of(context).iWantToLearn,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(L10n.of(context).cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  onPressed: () {
                    selectedSourceLanguage?.langCode !=
                            selectedTargetLanguage.langCode
                        ? showFutureLoadingDialog(
                            context: context,
                            future: () async {
                              try {
                                await pangeaController.userController
                                    .updateProfile(
                                  (profile) {
                                    profile.userSettings.sourceLanguage =
                                        selectedSourceLanguage?.langCode;
                                    profile.userSettings.targetLanguage =
                                        selectedTargetLanguage.langCode;
                                    return profile;
                                  },
                                  waitForDataInSync: true,
                                );
                                Navigator.pop(context);
                              } catch (err, s) {
                                debugger(when: kDebugMode);
                                ErrorHandler.logError(
                                  e: err,
                                  s: s,
                                  data: {},
                                );
                                rethrow;
                              } finally {
                                callback();
                              }
                            },
                          )
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                L10n.of(context).noIdenticalLanguages,
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          );
                  },
                  child: Text(L10n.of(context).saveChanges),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

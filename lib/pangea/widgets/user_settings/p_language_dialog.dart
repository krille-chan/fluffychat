import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import '../../../config/themes.dart';
import '../../../widgets/matrix.dart';
import 'p_language_dropdown.dart';
import 'p_question_container.dart';

pLanguageDialog(BuildContext parentContext, Function callback) {
  final PangeaController pangeaController = MatrixState.pangeaController;
  //PTODO: if source language not set by user, default to languge from device settings
  LanguageModel selectedSourceLanguage =
      pangeaController.languageController.userL1 ??
          pangeaController.pLanguageStore.targetOptions[0];
  LanguageModel selectedTargetLanguage =
      pangeaController.languageController.userL2 ??
          pangeaController.pLanguageStore.targetOptions[1];

  return showDialog(
    useRootNavigator: false,
    context: parentContext,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: AlertDialog(
              title: Text(L10n.of(parentContext)!.updateLanguage),
              content: SizedBox(
                width: FluffyThemes.columnWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PQuestionContainer(
                        title: L10n.of(parentContext)!.whatIsYourBaseLanguage,),
                    PLanguageDropdown(
                      onChange: (p0) =>
                          setState(() => selectedSourceLanguage = p0),
                      initialLanguage: selectedSourceLanguage,
                      languages: pangeaController.pLanguageStore.baseOptions,
                    ),
                    PQuestionContainer(
                        title:
                            L10n.of(parentContext)!.whatLanguageYouWantToLearn,),
                    PLanguageDropdown(
                      onChange: (p0) =>
                          setState(() => selectedTargetLanguage = p0),
                      initialLanguage: selectedTargetLanguage,
                      languages: pangeaController.pLanguageStore.targetOptions,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(L10n.of(parentContext)!.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  onPressed: () {
                    selectedSourceLanguage.langCode !=
                            selectedTargetLanguage.langCode
                        ? showFutureLoadingDialog(
                            context: context,
                            future: () async {
                              try {
                                await pangeaController.userController
                                    .updateUserProfile(
                                  sourceLanguage:
                                      selectedSourceLanguage.langCode,
                                  targetLanguage:
                                      selectedTargetLanguage.langCode,
                                );
                                Navigator.pop(context);
                              } catch (err, s) {
                                debugger(when: kDebugMode);
                                //PTODO-Lala add standard error message
                                ErrorHandler.logError(e: err, s: s);
                                rethrow;
                              } finally {
                                callback();
                              }
                            },
                          )
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  L10n.of(parentContext)!.noIdenticalLanguages,),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          );
                  },
                  child: Text(L10n.of(parentContext)!.saveChanges),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

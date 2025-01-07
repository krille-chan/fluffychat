import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../flag.dart';

//PTODO - move this to settings_learning_view.dart and make callback a setState

class LanguageTile extends StatelessWidget {
  final SettingsLearningController learningController;
  final PangeaController pangeaController = MatrixState.pangeaController;

  LanguageTile(this.learningController, {super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageModel? sourceLanguage =
        pangeaController.languageController.userL1;

    final LanguageModel? targetLanguage =
        pangeaController.languageController.userL2;

    //PTODO - placeholder saying 'select your languages'
    // if (targetLanguage == null || sourceLanguage == null) {
    //   debugger(when: kDebugMode);
    //   return const SizedBox();
    // }

    return ListTile(
      // title: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: const [
      //       Text("Source Language"),
      //       SizedBox(
      //         width: 10,
      //       ),
      //       Icon(Icons.arrow_right_alt_outlined, size: 20),
      //       SizedBox(
      //         width: 10,
      //       ),
      //       Text("Target Language"),
      //     ]),
      title: Text(L10n.of(context).myLanguages),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LanguageFlag(
            language: sourceLanguage,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            sourceLanguage?.getDisplayName(context) ??
                L10n.of(context).sourceLanguage,
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(Icons.arrow_right_alt_outlined, size: 20),
          const SizedBox(
            width: 10,
          ),
          LanguageFlag(
            language: targetLanguage,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            targetLanguage?.getDisplayName(context) ??
                L10n.of(context).targetLanguage,
          ),
        ],
      ),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () async {
        learningController.changeLanguage();
      },
    );
  }
}

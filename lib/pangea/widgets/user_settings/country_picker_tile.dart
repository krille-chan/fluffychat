import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

import '../../models/user_model.dart';

class CountryPickerTile extends StatelessWidget {
  final SettingsLearningController learningController;
  final PangeaController pangeaController = MatrixState.pangeaController;

  CountryPickerTile(this.learningController, {super.key});

  @override
  Widget build(BuildContext context) {
    final Profile? profile = pangeaController.userController.userModel?.profile;
    return ListTile(
      title: Text(
        "${L10n.of(context)!.countryInformation}: ${profile?.countryDisplayName(context) ?? ''} ${profile?.flagEmoji}",
      ),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () => showCountryPicker(
        context: context,
        showPhoneCode:
            false, // optional. Shows phone code before the country name.
        onSelect: (Country country) async {
          showFutureLoadingDialog(
            context: context,
            future: () async {
              try {
                learningController.changeCountry(country);
              } catch (err) {
                debugger(when: kDebugMode);
              }
            },
          );
        },
      ),
    );
  }
}

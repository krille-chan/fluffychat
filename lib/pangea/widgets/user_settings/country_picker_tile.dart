import 'package:country_picker/country_picker.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/utils/country_display.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../models/user_model.dart';

class CountryPickerTile extends StatelessWidget {
  final SettingsLearningController learningController;
  final PangeaController pangeaController = MatrixState.pangeaController;

  CountryPickerTile(this.learningController, {super.key});

  @override
  Widget build(BuildContext context) {
    final Profile profile = pangeaController.userController.profile;

    final String displayName = CountryDisplayUtil.countryDisplayName(
          profile.userSettings.country,
          context,
        ) ??
        '';

    final String flag = CountryDisplayUtil.flagEmoji(
      profile.userSettings.country,
    );

    return ListTile(
      title: Text(
        "${L10n.of(context).countryInformation}: $displayName $flag",
      ),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () => showCountryPicker(
        context: context,
        showPhoneCode: false,
        onSelect: learningController.changeCountry,
      ),
    );
  }
}

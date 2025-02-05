import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/pangea/learning_settings/utils/country_display.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CountryPickerTile extends StatelessWidget {
  final SettingsLearningController learningController;
  final PangeaController pangeaController = MatrixState.pangeaController;

  CountryPickerTile(this.learningController, {super.key});

  @override
  Widget build(BuildContext context) {
    final String displayName = CountryDisplayUtil.countryDisplayName(
          learningController.country,
          context,
        ) ??
        '';

    final String flag = CountryDisplayUtil.flagEmoji(
      learningController.country,
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

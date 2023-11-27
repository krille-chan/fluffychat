// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:country_picker/country_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

// Project imports:
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../models/user_model.dart';

class CountryPickerTile extends StatelessWidget {
  final PangeaController pangeaController = MatrixState.pangeaController;

  CountryPickerTile({Key? key}) : super(key: key);

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
                await pangeaController.userController.updateUserProfile(
                  country: country.displayNameNoCountryCode,
                );
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

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/pages/p_user_age/p_user_age.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../widgets/layouts/login_scaffold.dart';

class PUserAgeView extends StatelessWidget {
  final PUserAgeController controller;
  const PUserAgeView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !controller.loading,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withAlpha(50),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    L10n.of(context).yourBirthdayPlease,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    L10n.of(context).certifyAge(13),
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  leading: Radio<int>(
                    value: 13,
                    groupValue: controller.selectedAge,
                    onChanged: controller.setSelectedAge,
                    activeColor: AppConfig.primaryColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    L10n.of(context).certifyAge(18),
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  leading: Radio<int>(
                    value: 18,
                    groupValue: controller.selectedAge,
                    onChanged: controller.setSelectedAge,
                    activeColor: AppConfig.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Hero(
            tag: 'loginButton',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ElevatedButton(
                onPressed: controller.createUserInPangea,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: controller.loading
                    ? const LinearProgressIndicator()
                    : Text(L10n.of(context).getStarted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

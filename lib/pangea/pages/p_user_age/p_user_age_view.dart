import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';

import 'package:fluffychat/pangea/pages/p_user_age/p_user_age.dart';
import '../../../widgets/layouts/login_scaffold.dart';

class PUserAgeView extends StatelessWidget {
  final PUserAgeController controller;
  const PUserAgeView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.dobController.text = "";
    return LoginScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !controller.loading,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          children: [
            // #Pangea
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              child: Text(
                L10n.of(context)!.yourBirthdayPlease,
                textAlign: TextAlign.justify,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                readOnly: controller.loading,
                autocorrect: false,
                controller: controller.dobController,
                keyboardType: TextInputType.datetime,
                autofillHints:
                    controller.loading ? null : [AutofillHints.birthday],
                validator: controller.dobFieldValidator,
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    initialDatePickerMode: DatePickerMode.year,
                    context: context,
                    initialDate: controller.initialDate,
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    controller.dobController.text =
                        DateFormat.yMd().format(pickedDate);
                    controller.error = null;
                  } else {
                    controller.error = L10n.of(context)!.invalidDob;
                  }
                },
                // onChanged: (String newValue) {
                //   try {
                //     controller.dateOfBirth =
                //         DateTime.parse(controller.dobController.text);
                //     controller.error = null;
                //   } catch (err) {
                //     controller.error = L10n.of(context)!.invalidDob;
                //   }
                // },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: L10n.of(context)!.enterYourDob,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .background
                      .withOpacity(0.75),
                  errorText: controller.error,
                  errorStyle: TextStyle(
                    color: controller.dobController.text.isEmpty
                        ? Colors.orangeAccent
                        : Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Hero(
              tag: 'loginButton',
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  onPressed: controller.createUserInPangea,
                  child: controller.loading
                      ? const LinearProgressIndicator()
                      : Text(L10n.of(context)!.getStarted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

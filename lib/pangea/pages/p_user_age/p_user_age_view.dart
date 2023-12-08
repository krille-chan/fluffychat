import 'package:fluffychat/pangea/pages/p_user_age/p_user_age.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../widgets/layouts/login_scaffold.dart';

class PUserAgeView extends StatelessWidget {
  final PUserAgeController controller;
  const PUserAgeView(this.controller, {super.key});

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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).colorScheme.background,
                          ),
                          padding: const EdgeInsets.all(12),
                          // height: 350,
                          width: 500,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Card(
                                child: SfDateRangePicker(
                                  view: DateRangePickerView.month,
                                  showNavigationArrow: true,
                                  showActionButtons: true,
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
                                  initialDisplayDate: controller.initialDate,
                                  initialSelectedDate: controller.initialDate,
                                  onSubmit: (val) {
                                    final DateTime? pickedDate =
                                        val as DateTime?;
                                    if (pickedDate != null) {
                                      controller.dobController.text =
                                          DateFormat.yMd().format(pickedDate);
                                      controller.error = null;
                                    } else {
                                      controller.error =
                                          L10n.of(context)!.invalidDob;
                                    }
                                    Navigator.pop(context);
                                  },
                                  onCancel: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
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

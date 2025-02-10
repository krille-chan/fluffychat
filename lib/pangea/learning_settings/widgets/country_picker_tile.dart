import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/pangea/learning_settings/utils/country_display.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CountryPickerDropdown extends StatefulWidget {
  final SettingsLearningController learningController;
  final PangeaController pangeaController = MatrixState.pangeaController;

  CountryPickerDropdown(this.learningController, {super.key});

  @override
  CountryPickerDropdownState createState() => CountryPickerDropdownState();
}

class CountryPickerDropdownState extends State<CountryPickerDropdown> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<Country>(
      customButton: widget.learningController.country != null
          ? CountryPickerTile(
              widget.learningController.country!,
              isDropdown: true,
            )
          : null,
      decoration: InputDecoration(
        labelText: L10n.of(context).countryInformation,
      ),
      dropdownStyleData: const DropdownStyleData(
        maxHeight: 300,
      ),
      items: [
        ...CountryService().getAll().map(
              (country) => DropdownMenuItem(
                value: country,
                child: CountryPickerTile(country),
              ),
            ),
      ],
      onChanged: widget.learningController.changeCountry,
      value: widget.learningController.country,
      dropdownSearchData: DropdownSearchData(
        searchController: _searchController,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            autofocus: true,
            controller: _searchController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          final countryName = item.value?.name.toLowerCase();
          if (countryName == null) return false;

          final search = searchValue.toLowerCase();
          return countryName.startsWith(search);
        },
      ),
      onMenuStateChange: (isOpen) {
        if (!isOpen) _searchController.clear();
      },
    );
  }
}

class CountryPickerTile extends StatelessWidget {
  final Country country;
  final bool isDropdown;

  const CountryPickerTile(
    this.country, {
    super.key,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          CountryDisplayUtil.flagEmoji(country.name),
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            CountryDisplayUtil.countryDisplayName(
                  country.name,
                  context,
                ) ??
                '',
            style: const TextStyle().copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isDropdown)
          Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      ],
    );
  }
}

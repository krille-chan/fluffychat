import 'package:flutter/foundation.dart';
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
    final countries = CountryService().getAll();
    return DropdownButtonFormField2<Country>(
      customButton: widget.learningController.country != null &&
              countries.any(
                (country) =>
                    country.name == widget.learningController.country!.name,
              )
          ? CountryPickerTile(
              widget.learningController.country!,
              isDropdown: true,
            )
          : null,
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.zero,
      ),
      isExpanded: true,
      decoration: InputDecoration(
        labelText: L10n.of(context).countryInformation,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: kIsWeb ? 500 : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
      ),
      items: [
        ...countries.map(
          (country) => DropdownMenuItem(
            value: country,
            child: Container(
              color: widget.learningController.country == country
                  ? Theme.of(context).colorScheme.primary.withAlpha(20)
                  : Colors.transparent,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              child: CountryPickerTile(country),
            ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              CountryDisplayUtil.flagEmoji(country.name),
              style: const TextStyle(fontSize: 25),
            ),
            const SizedBox(width: 10),
            Text(
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
          ],
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

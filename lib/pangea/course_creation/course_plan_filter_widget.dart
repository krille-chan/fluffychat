import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:fluffychat/pangea/common/widgets/dropdown_text_button.dart';

class CoursePlanFilter<T> extends StatefulWidget {
  final T? value;
  final List<T> items;

  final void Function(T?) onChanged;
  final String defaultName;
  final String? shortName;
  final String Function(T) displayname;

  final bool enableSearch;

  const CoursePlanFilter({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.defaultName,
    required this.displayname,
    this.enableSearch = false,
    this.shortName,
  });

  @override
  State<CoursePlanFilter<T>> createState() => CoursePlanFilterState<T>();
}

class CoursePlanFilterState<T> extends State<CoursePlanFilter<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        customButton: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.onSurface),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 2.0,
          ),
          child: Row(
            spacing: 4.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.value != null
                    ? widget.displayname(widget.value as T)
                    : widget.defaultName,
                style: theme.textTheme.labelMedium,
              ),
              const Icon(
                Icons.arrow_drop_down,
                size: 12.0,
              ),
            ],
          ),
        ),
        value: widget.value,
        items: [null, ...widget.items]
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: DropdownTextButton(
                  text: item != null
                      ? widget.displayname(item)
                      : widget.shortName ?? widget.defaultName,
                  isSelected: item == widget.value,
                ),
              ),
            )
            .toList(),
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        dropdownStyleData: const DropdownStyleData(
          width: 250,
        ),
        dropdownSearchData: widget.enableSearch
            ? DropdownSearchData(
                searchController: _searchController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: TextField(
                    autofocus: true,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  final displayName = (item.value != null
                          ? widget.displayname(item.value as T)
                          : widget.defaultName)
                      .toLowerCase();

                  final search = searchValue.toLowerCase();
                  return displayName.startsWith(search);
                },
              )
            : null,
        onMenuStateChange: (isOpen) {
          if (!isOpen) _searchController.clear();
        },
      ),
    );
  }
}

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
            borderRadius: BorderRadius.circular(40.0),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.value != null
                    ? widget.displayname(widget.value as T)
                    : widget.defaultName,
              ),
              const Icon(
                Icons.arrow_drop_down,
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

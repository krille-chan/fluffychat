import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class DefaultAppBarSearchField extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) onChanged;
  final Widget suffix;

  const DefaultAppBarSearchField({
    Key key,
    this.searchController,
    this.onChanged,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return Container(
      height: 40,
      padding: EdgeInsets.only(right: 16),
      child: Material(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(32),
        child: TextField(
          autocorrect: false,
          controller: searchController,
          onChanged: onChanged,
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            hintText: L10n.of(context).searchForAChat,
            suffixIcon: focusNode.hasFocus
                ? IconButton(
                    icon: Icon(Icons.backspace_outlined),
                    onPressed: () {
                      searchController.clear();
                      focusNode.unfocus();
                    },
                  )
                : suffix,
          ),
        ),
      ),
    );
  }
}

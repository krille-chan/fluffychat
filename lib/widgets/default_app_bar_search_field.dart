import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../config/app_config.dart';

class DefaultAppBarSearchField extends StatefulWidget {
  final TextEditingController searchController;
  final void Function(String) onChanged;
  final void Function(String) onSubmit;
  final Widget suffix;
  final bool autofocus;
  final String prefixText;
  final String hintText;
  final EdgeInsets padding;
  final bool readOnly;
  final Widget prefixIcon;
  final bool unfocusOnClear;
  final bool autocorrect;

  DefaultAppBarSearchField({
    Key key,
    this.searchController,
    this.onChanged,
    this.onSubmit,
    this.suffix,
    this.autofocus = false,
    this.prefixText,
    this.hintText,
    this.padding,
    this.readOnly = false,
    this.prefixIcon,
    this.unfocusOnClear = true,
    this.autocorrect = true,
  }) : super(key: key);

  @override
  DefaultAppBarSearchFieldState createState() =>
      DefaultAppBarSearchFieldState();
}

class DefaultAppBarSearchFieldState extends State<DefaultAppBarSearchField> {
  TextEditingController _searchController;
  bool _lastTextWasEmpty = false;
  final FocusNode _focusNode = FocusNode();

  void requestFocus() => _focusNode.requestFocus();

  void _updateSearchController() {
    final thisTextIsEmpty = _searchController.text?.isEmpty ?? false;
    if (_lastTextWasEmpty != thisTextIsEmpty) {
      setState(() => _lastTextWasEmpty = thisTextIsEmpty);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
    // we need to remove the listener in the dispose method, so we need a reference to the callback
    _searchController.addListener(_updateSearchController);
    _focusNode.addListener(() => setState(() => null));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.removeListener(_updateSearchController);
    if (widget.searchController == null) {
      // we need to dispose our own created searchController
      _searchController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: widget.padding ?? EdgeInsets.only(right: 12),
      child: TextField(
        autofocus: widget.autofocus,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.autocorrect,
        keyboardType: widget.autocorrect ? null : TextInputType.visiblePassword,
        controller: _searchController,
        onChanged: widget.onChanged,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        onSubmitted: widget.onSubmit,
        decoration: InputDecoration(
          prefixText: widget.prefixText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            borderSide:
                BorderSide(color: Theme.of(context).secondaryHeaderColor),
          ),
          contentPadding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 16,
          ),
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: !widget.readOnly &&
                  (_focusNode.hasFocus ||
                      (widget.suffix == null &&
                          (_searchController.text?.isNotEmpty ?? false)))
              ? IconButton(
                  tooltip: L10n.of(context).clearText,
                  icon: Icon(Icons.backspace_outlined),
                  onPressed: () {
                    _searchController.clear();
                    widget.onChanged?.call('');
                    if (widget.unfocusOnClear) _focusNode.unfocus();
                  },
                )
              : widget.suffix,
        ),
      ),
    );
  }
}

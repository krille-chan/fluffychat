import 'package:flutter/material.dart';

class DefaultAppBarSearchField extends StatefulWidget {
  final TextEditingController searchController;
  final void Function(String) onChanged;
  final Widget suffix;
  final bool autofocus;
  final String prefixText;
  final String hintText;
  final EdgeInsets padding;

  const DefaultAppBarSearchField({
    Key key,
    this.searchController,
    this.onChanged,
    this.suffix,
    this.autofocus = false,
    this.prefixText,
    this.hintText,
    this.padding,
  }) : super(key: key);

  @override
  _DefaultAppBarSearchFieldState createState() =>
      _DefaultAppBarSearchFieldState();
}

class _DefaultAppBarSearchFieldState extends State<DefaultAppBarSearchField> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController _searchController;
  bool _lastTextWasEmpty = false;

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
      child: Material(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(32),
        child: TextField(
          autofocus: widget.autofocus,
          autocorrect: false,
          controller: _searchController,
          onChanged: widget.onChanged,
          focusNode: _focusNode,
          decoration: InputDecoration(
            prefixText: widget.prefixText,
            contentPadding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            hintText: widget.hintText,
            suffixIcon: _focusNode.hasFocus ||
                    (widget.suffix == null &&
                        (_searchController.text?.isNotEmpty ?? false))
                ? IconButton(
                    icon: Icon(Icons.backspace_outlined),
                    onPressed: () {
                      _searchController.clear();
                      widget.onChanged?.call('');
                      _focusNode.unfocus();
                    },
                  )
                : widget.suffix,
          ),
        ),
      ),
    );
  }
}

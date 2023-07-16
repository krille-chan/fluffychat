import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluffychat/config/themes.dart';

import '../../config/app_config.dart';
import 'chat.dart';

class ChatEmojiPicker extends StatefulWidget {
  final ChatController controller;

  const ChatEmojiPicker(this.controller, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatEmojiPickerState();
  }
}

class _ChatEmojiPickerState extends State<ChatEmojiPicker> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _searchScrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Emoji> _searchResults = List.empty();
  bool _isSearchFocused = false;

  @override
  void dispose() {
    _searchScrollController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar(BuildContext context, bool isEmpty) {
    return SizedBox(
      height: 44,
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isSearchFocused = hasFocus;
          });
        },
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          maxLines: 1,
          onChanged: (text) async {
            _searchResults =
                await EmojiPickerUtils().searchEmoji(text, defaultEmojiSet);
            setState(() {});
          },
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            ),
            hintText: L10n.of(context)!.search,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: _isSearchFocused
                ? IconButton(
                    tooltip: L10n.of(context)!.cancel,
                    icon: const Icon(Icons.arrow_back_outlined),
                    onPressed: () {
                      _searchController.text = '';
                      _searchResults = List.empty();
                      _searchFocusNode.unfocus();
                    },
                    color: Theme.of(context).colorScheme.onBackground,
                  )
                : Icon(
                    Icons.search_outlined,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            suffixIcon: isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _searchController.text = '';
                      _searchResults = List.empty();;
                    },
                    icon: Icon(
                      Icons.clear_outlined,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
  ) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isEmpty
              ? 'Type your search phrase'
              : 'No matches',
        ),
      );
    }

    const Config config = Config();

    return LayoutBuilder(
      builder: (context, constraints) {
        final emojiSize = config.getEmojiSize(constraints.maxWidth);
        return GridView.count(
          scrollDirection: Axis.vertical,
          controller: _searchScrollController,
          primary: false,
          padding: config.gridPadding,
          crossAxisCount: config.columns,
          mainAxisSpacing: config.verticalSpacing,
          crossAxisSpacing: config.horizontalSpacing,
          children: [
            for (int i = 0; i < _searchResults.length; i++)
              EmojiCell.fromConfig(
                emoji: _searchResults[i],
                emojiSize: emojiSize,
                index: i,
                onEmojiSelected: widget.controller.onEmojiSelected,
                config: config,
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.showEmojiPicker) {
      _searchController.text = '';
      _searchResults = List.empty();
    }

    return AnimatedContainer(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
      height: widget.controller.showEmojiPicker
          ? MediaQuery.of(context).size.height / 2
          : 0,
      child: widget.controller.showEmojiPicker
          ? ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, _) {
                return Column(
                  children: [
                    _buildSearchBar(context, value.text.isEmpty),
                    Expanded(
                      child: (value.text.isEmpty && !_isSearchFocused)
                          ? EmojiPicker(
                              onEmojiSelected:
                                  widget.controller.onEmojiSelected,
                              onBackspacePressed:
                                  widget.controller.emojiPickerBackspace,
                              config: Config(
                                noRecents: Text(
                                  L10n.of(context)!.noRecentEmojis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                bgColor: Theme.of(context)
                                    .canvasColor, // TODO: needs to match color of input_bar
                              ),
                            )
                          : _buildSearchResults(context),
                    ),
                  ],
                );
              },
            )
          : null,
    );
  }
}

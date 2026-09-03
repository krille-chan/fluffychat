// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';

class EmojiPickerDialog extends StatefulWidget {
  final OnEmojiSelected? onEmojiSelected;
  final OnBackspacePressed? onBackspacePressed;
  final Category? initCategory;
  final Color? backgroundColor;

  const EmojiPickerDialog({
    this.onEmojiSelected,
    this.onBackspacePressed,
    this.initCategory,
    this.backgroundColor,
    super.key,
  });

  @override
  EmojiPickerDialogState createState() => EmojiPickerDialogState();
}

class EmojiPickerDialogState extends State<EmojiPickerDialog> {
  final GlobalKey<EmojiPickerState> key = GlobalKey();
  final emojiUtils = EmojiPickerUtils();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return EmojiPicker(
      key: key,
      customWidget: (config, state, showSearchBar) => _EmojiPicker(
        config: config,
        state: state,
        backgroundColor:
            widget.backgroundColor ?? theme.colorScheme.onInverseSurface,
        onEmojiSelected: (category, emoji) {
          widget.onEmojiSelected?.call(category, emoji);
          emojiUtils.addEmojiToRecentlyUsed(key: key, emoji: emoji);
        },
        initCategory: widget.initCategory ?? Category.RECENT,
      ),
      onBackspacePressed: widget.onBackspacePressed,
      config: Config(
        locale: Localizations.localeOf(context),
        skinToneConfig: SkinToneConfig(
          dialogBackgroundColor: Color.lerp(
            theme.colorScheme.surface,
            theme.colorScheme.primaryContainer,
            0.75,
          )!,
          indicatorColor: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _EmojiPicker extends StatefulWidget {
  final Config config;
  final EmojiViewState state;
  final Color backgroundColor;
  final OnEmojiSelected onEmojiSelected;
  final Category initCategory;

  const _EmojiPicker({
    required this.config,
    required this.state,
    required this.backgroundColor,
    required this.onEmojiSelected,
    required this.initCategory,
  });

  @override
  State<_EmojiPicker> createState() => _EmojiPickerController();
}

class _EmojiPickerController extends State<_EmojiPicker>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final PageController pageController;
  late final TextEditingController searchController;

  void onCategoryNavigationChanged() {
    final targetCategory = widget.state.categoryNavigationNotifier.value;
    if (targetCategory != null) {
      final index = widget.state.categoryEmoji.indexWhere(
        (element) => element.category == targetCategory,
      );
      if (index != -1) {
        final currentPage = pageController.page?.round();
        if (index != currentPage) {
          pageController.jumpToPage(index);
        }
      }
    }
  }

  @override
  void initState() {
    final targetCategory = widget.state.currentCategory ?? widget.initCategory;
    var initCategory = widget.state.categoryEmoji.indexWhere(
      (element) => element.category == targetCategory,
    );
    if (initCategory == -1) {
      initCategory = 0;
    }

    tabController = TabController(
      initialIndex: initCategory,
      length: widget.state.categoryEmoji.length,
      vsync: this,
    );
    pageController = PageController(initialPage: initCategory);
    searchController = TextEditingController();

    widget.state.categoryNavigationNotifier.addListener(
      onCategoryNavigationChanged,
    );

    super.initState();
  }

  @override
  void dispose() {
    widget.state.categoryNavigationNotifier.removeListener(
      onCategoryNavigationChanged,
    );
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _EmojiPickerView(this);
  }
}

class _EmojiPickerView extends StatelessWidget {
  final _EmojiPickerController controller;

  const _EmojiPickerView(this.controller);

  Widget buildEmojiCell(Emoji emoji, double emojiSize, double emojiBoxSize) {
    return EmojiCell.fromConfig(
      emoji: emoji,
      emojiSize: emojiSize,
      emojiBoxSize: emojiBoxSize,
      onEmojiSelected: controller.widget.onEmojiSelected,
      config: controller.widget.config,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final emojiSize = controller.widget.config.emojiViewConfig.getEmojiSize(
          constraints.maxWidth,
        );
        final emojiBoxSize = controller.widget.config.emojiViewConfig
            .getEmojiBoxSize(constraints.maxWidth);

        return EmojiContainer(
          color: controller.widget.backgroundColor,
          buttonMode: ButtonMode.MATERIAL,
          child: ClipRect(
            child: Column(
              children: [
                ColoredBox(
                  color: theme.colorScheme.surface,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46.0,
                          child: TabBar(
                            labelColor: theme.colorScheme.primary,
                            indicatorColor: theme.colorScheme.primary,
                            unselectedLabelColor: theme.colorScheme.primary
                                .withAlpha(128),
                            controller: controller.tabController,
                            labelPadding: EdgeInsets.zero,
                            onTap: controller.pageController.jumpToPage,
                            tabs: [
                              ...controller.widget.state.categoryEmoji
                                  .asMap()
                                  .entries
                                  .map<Widget>(
                                    (item) => Tab(
                                      icon: Icon(
                                        getIconForCategory(
                                          const CategoryIcons(),
                                          item.value.category,
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: PageView.builder(
                    itemCount: controller.widget.state.categoryEmoji.length,
                    controller: controller.pageController,
                    onPageChanged: (index) {
                      controller.tabController.animateTo(
                        index,
                        duration: kTabScrollDuration,
                      );

                      // clear search when changing tabs
                      if (index == 0 &&
                          controller.searchController.text.isNotEmpty) {
                        controller.searchController.clear();
                      }

                      controller.widget.state.onCategoryChanged?.call(
                        controller.widget.state.categoryEmoji[index].category,
                      );
                    },
                    itemBuilder: (context, index) {
                      final categoryEmoji =
                          controller.widget.state.categoryEmoji[index];

                      if (categoryEmoji.category == Category.RECENT) {
                        return _EmojiPickerSearch(
                          state: controller.widget.state,
                          textController: controller.searchController,
                          backgroundColor: controller.widget.backgroundColor,
                          emojiCellBuilder: (emoji) =>
                              buildEmojiCell(emoji, emojiSize, emojiBoxSize),
                        );
                      }

                      return GridView.builder(
                        key: const Key('emojiScrollView'),
                        scrollDirection: Axis.vertical,
                        primary: false,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              crossAxisCount: 10,
                            ),
                        itemCount: categoryEmoji.emoji.length,
                        itemBuilder: (context, index) => buildEmojiCell(
                          categoryEmoji.emoji[index],
                          emojiSize,
                          emojiBoxSize,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmojiPickerSearch extends StatefulWidget {
  final EmojiViewState state;
  final TextEditingController textController;
  final Color backgroundColor;
  final Function(Emoji emoji) emojiCellBuilder;

  const _EmojiPickerSearch({
    required this.state,
    required this.textController,
    required this.backgroundColor,
    required this.emojiCellBuilder,
  });

  @override
  _EmojiPickerSearchController createState() => _EmojiPickerSearchController();
}

class _EmojiPickerSearchController extends State<_EmojiPickerSearch> {
  final emojiUtils = EmojiPickerUtils();
  final results = List<Emoji>.empty(growable: true);
  bool showNoRecents = false;

  void updateResults(List<Emoji> emojis) {
    results
      ..clear()
      ..addAll(emojis);
  }

  void fetchRecents() {
    emojiUtils.getRecentEmojis().then((value) {
      if (!mounted) return;
      setState(() {
        if (value.isEmpty) {
          showNoRecents = true;
        }
        updateResults(value.map((e) => e.emoji).toList());
      });
    });
  }

  void onTextInputChanged() {
    setState(() {
      results.clear();
      showNoRecents = false;
    });

    final text = widget.textController.text;
    if (text.isEmpty) {
      fetchRecents();
    } else {
      emojiUtils.searchEmoji(text, widget.state.categoryEmoji).then((value) {
        if (!mounted) return;
        setState(() => updateResults(value));
      });
    }
  }

  @override
  void initState() {
    fetchRecents();
    widget.textController.addListener(onTextInputChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.textController.removeListener(onTextInputChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _EmojiPickerSearchView(this);
  }
}

class _EmojiPickerSearchView extends StatelessWidget {
  final _EmojiPickerSearchController controller;

  const _EmojiPickerSearchView(this.controller);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);

        return Material(
          color: controller.widget.backgroundColor,
          child: SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsetsGeometry.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: TextField(
                      autofocus: false,
                      controller: controller.widget.textController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.colorScheme.secondaryContainer,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        contentPadding: EdgeInsets.zero,
                        hintText: L10n.of(context).search,
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.normal,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: const Icon(Icons.search_outlined),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: controller.showNoRecents
                      ? const _NoRecent()
                      : GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1,
                                crossAxisCount: 10,
                              ),
                          itemCount: controller.results.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) =>
                              controller.widget.emojiCellBuilder(
                                controller.results[index],
                              ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NoRecent extends StatelessWidget {
  const _NoRecent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          L10n.of(context).emoteKeyboardNoRecents,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

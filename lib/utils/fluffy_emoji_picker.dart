// ignore_for_file: prefer_function_declarations_over_variables, implementation_imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:emoji_picker_flutter/src/category_emoji.dart';
import 'package:emoji_picker_flutter/src/emoji_picker_internal_utils.dart';
import 'package:emoji_picker_flutter/src/emoji_skin_tones.dart';
import 'package:emoji_picker_flutter/src/emoji_view_state.dart';
import 'package:emoji_picker_flutter/src/triangle_shape.dart';
import 'package:emojis/emoji.dart' as emoji;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/matrix.dart';

/// Default EmojiPicker Implementation - adjusted for FluffyChat
///
/// Copied and adjusted from: [DefaultEmojiPickerView]
class FluffyEmojiPickerView extends EmojiPickerBuilder {
  /// Constructor
  FluffyEmojiPickerView(Config config, EmojiViewState state)
      : super(config, state);

  @override
  DefaultEmojiPickerViewState createState() => DefaultEmojiPickerViewState();
}

class DefaultEmojiPickerViewState extends State<FluffyEmojiPickerView>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  TabController? _tabController;
  OverlayEntry? _overlay;
  late final _scrollController = ScrollController();
  late final _utils = EmojiPickerInternalUtils();
  final int _skinToneCount = 6;
  final double tabBarHeight = 46;

  @override
  void initState() {
    var initCategory = widget.state.categoryEmoji.indexWhere(
        (element) => element.category == widget.config.initCategory);
    if (initCategory == -1) {
      initCategory = 0;
    }
    _tabController = TabController(
        initialIndex: initCategory,
        length: widget.state.categoryEmoji.length,
        vsync: this);
    _pageController = PageController(initialPage: initCategory)
      ..addListener(_closeSkinToneDialog);
    _scrollController.addListener(_closeSkinToneDialog);
    super.initState();
  }

  @override
  void dispose() {
    _closeSkinToneDialog();
    super.dispose();
  }

  void _closeSkinToneDialog() {
    _overlay?.remove();
    _overlay = null;
  }

  void _openSkinToneDialog(
    Emoji emoji,
    double emojiSize,
    CategoryEmoji categoryEmoji,
    int index,
  ) {
    _overlay = _buildSkinToneOverlay(
      emoji,
      emojiSize,
      categoryEmoji,
      index,
    );
    Overlay.of(context)?.insert(_overlay!);
  }

  Widget _buildBackspaceButton() {
    if (widget.state.onBackspacePressed != null) {
      return Material(
        type: MaterialType.transparency,
        child: IconButton(
            padding: const EdgeInsets.only(bottom: 2),
            icon: Icon(
              Icons.backspace,
              color: widget.config.backspaceColor,
            ),
            onPressed: () {
              widget.state.onBackspacePressed!();
            }),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final emojiSize = widget.config.getEmojiSize(constraints.maxWidth);

        return Container(
          color: widget.config.bgColor,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: tabBarHeight,
                      child: TabBar(
                        labelColor: widget.config.iconColorSelected,
                        indicatorColor: widget.config.indicatorColor,
                        unselectedLabelColor: widget.config.iconColor,
                        controller: _tabController,
                        labelPadding: EdgeInsets.zero,
                        onTap: (index) {
                          _closeSkinToneDialog();
                          _pageController!.jumpToPage(index);
                        },
                        tabs: widget.state.categoryEmoji
                            .asMap()
                            .entries
                            .map<Widget>((item) =>
                                _buildCategory(item.key, item.value.category))
                            .toList(),
                      ),
                    ),
                  ),
                  _buildBackspaceButton(),
                ],
              ),
              Flexible(
                child: PageView.builder(
                  itemCount: widget.state.categoryEmoji.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    _tabController!.animateTo(
                      index,
                      duration: widget.config.tabIndicatorAnimDuration,
                    );
                  },
                  itemBuilder: (context, index) =>
                      _buildPage(emojiSize, widget.state.categoryEmoji[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategory(int index, Category category) {
    return Tab(
      icon: Icon(
        widget.config.getIconForCategory(category),
      ),
    );
  }

  Widget _buildPage(double emojiSize, CategoryEmoji categoryEmoji) {
    final matrix = Matrix.of(context);

    // Display notice if recent has no entries yet
    if (categoryEmoji.category == Category.RECENT) {
      final recent = matrix.client.recentEmojis;
      final sorted = recent.keys.toList()
        ..sort((a, b) => recent[b]!.compareTo(recent[a]!));
      categoryEmoji.emoji = sorted
          .map((char) => Emoji(emoji.Emoji.byChar(char)?.name ?? '', char))
          .toList();
      if (categoryEmoji.emoji.isEmpty) {
        return _buildNoRecent();
      }
    }
    // Build page normally
    return GestureDetector(
      onTap: _closeSkinToneDialog,
      child: GridView.count(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        controller: _scrollController,
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(0),
        crossAxisCount: widget.config.columns,
        mainAxisSpacing: widget.config.verticalSpacing,
        crossAxisSpacing: widget.config.horizontalSpacing,
        children: categoryEmoji.emoji.asMap().entries.map((item) {
          final index = item.key;
          final emoji = item.value;
          final onPressed = () {
            _closeSkinToneDialog();
            matrix.client.addRecentEmoji(emoji.emoji);
            widget.state.onEmojiSelected(categoryEmoji.category, emoji);
          };

          final onLongPressed = () {
            if (!emoji.hasSkinTone || !widget.config.enableSkinTones) {
              _closeSkinToneDialog();
              return;
            }
            _closeSkinToneDialog();
            _openSkinToneDialog(emoji, emojiSize, categoryEmoji, index);
          };

          return _buildButtonWidget(
            onPressed: onPressed,
            onLongPressed: onLongPressed,
            child: _buildEmoji(
              emojiSize,
              categoryEmoji,
              emoji,
              widget.config.enableSkinTones,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build and display Emoji centered of its parent
  Widget _buildEmoji(
    double emojiSize,
    CategoryEmoji categoryEmoji,
    Emoji emoji,
    bool showSkinToneIndicator,
  ) {
    // FittedBox needed for display, font scale settings
    return FittedBox(
      fit: BoxFit.fill,
      child: Stack(children: [
        emoji.hasSkinTone && showSkinToneIndicator
            ? Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size(8, 8),
                  painter: TriangleShape(widget.config.skinToneIndicatorColor),
                ),
              )
            : Container(),
        Text(
          emoji.emoji,
          textScaleFactor: 1.0,
          style: TextStyle(
            fontSize: emojiSize,
            backgroundColor: Colors.transparent,
          ),
        ),
      ]),
    );
  }

  /// Build different Button based on ButtonMode
  Widget _buildButtonWidget({
    required VoidCallback onPressed,
    required VoidCallback onLongPressed,
    required Widget child,
  }) {
    if (widget.config.buttonMode == ButtonMode.MATERIAL) {
      return TextButton(
        onPressed: onPressed,
        onLongPress: onLongPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: child,
      );
    }
    return GestureDetector(
      onLongPress: onLongPressed,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  /// Build Widget for when no recent emoji are available
  Widget _buildNoRecent() {
    return Center(
        child: Text(
      widget.config.noRecentsText,
      style: widget.config.noRecentsStyle,
      textAlign: TextAlign.center,
    ));
  }

  /// Overlay for SkinTone
  OverlayEntry _buildSkinToneOverlay(
    Emoji emoji,
    double emojiSize,
    CategoryEmoji categoryEmoji,
    int index,
  ) {
    // Calculate position of emoji in the grid
    final row = index ~/ widget.config.columns;
    final column = index % widget.config.columns;
    // Calculate position for skin tone dialog
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final emojiSpace = renderBox.size.width / widget.config.columns;
    final topOffset = emojiSpace;
    final leftOffset = _getLeftOffset(emojiSpace, column);
    final left = offset.dx + column * emojiSpace + leftOffset;
    final top = tabBarHeight +
        offset.dy +
        row * emojiSpace -
        _scrollController.offset -
        topOffset;

    // Generate other skintone options
    final skinTonesEmoji = SkinTone.values
        .map((skinTone) => _utils.applySkinTone(emoji, skinTone))
        .toList();

    return OverlayEntry(
      builder: (context) => Positioned(
        left: left,
        top: top,
        child: Material(
          elevation: 4.0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            color: widget.config.skinToneDialogBgColor,
            child: Row(
              children: [
                _buildSkinToneEmoji(
                    categoryEmoji, emoji, emojiSpace, emojiSize),
                _buildSkinToneEmoji(
                    categoryEmoji, skinTonesEmoji[0], emojiSpace, emojiSize),
                _buildSkinToneEmoji(
                    categoryEmoji, skinTonesEmoji[1], emojiSpace, emojiSize),
                _buildSkinToneEmoji(
                    categoryEmoji, skinTonesEmoji[2], emojiSpace, emojiSize),
                _buildSkinToneEmoji(
                    categoryEmoji, skinTonesEmoji[3], emojiSpace, emojiSize),
                _buildSkinToneEmoji(
                    categoryEmoji, skinTonesEmoji[4], emojiSpace, emojiSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build Emoji inside skin tone dialog
  Widget _buildSkinToneEmoji(
    CategoryEmoji categoryEmoji,
    Emoji emoji,
    double width,
    double emojiSize,
  ) {
    return SizedBox(
      width: width,
      height: width,
      child: _buildButtonWidget(
        onPressed: () {
          widget.state.onEmojiSelected(categoryEmoji.category, emoji);
          _closeSkinToneDialog();
        },
        onLongPressed: () {},
        child: _buildEmoji(emojiSize, categoryEmoji, emoji, false),
      ),
    );
  }

  // Calucates the offset from the middle of selected emoji to the left side
  // of the skin tone dialog
  // Case 1: Selected Emoji is close to left border and offset needs to be
  // reduced
  // Case 2: Selected Emoji is close to right border and offset needs to be
  // larger than half of the whole width
  // Case 3: Enough space to left and right border and offset can be half
  // of whole width
  double _getLeftOffset(double emojiWidth, int column) {
    final remainingColumns =
        widget.config.columns - (column + 1 + (_skinToneCount ~/ 2));
    if (column >= 0 && column < 3) {
      return -1 * column * emojiWidth;
    } else if (remainingColumns < 0) {
      return -1 *
          ((_skinToneCount ~/ 2 - 1) + -1 * remainingColumns) *
          emojiWidth;
    }
    return -1 * ((_skinToneCount ~/ 2) * emojiWidth) + emojiWidth / 2;
  }
}

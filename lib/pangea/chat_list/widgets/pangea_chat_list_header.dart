import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicators.dart';

class PangeaChatListHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final ChatListController controller;
  final bool globalSearch;
  final bool showSearch;

  const PangeaChatListHeader({
    super.key,
    required this.controller,
    required this.showSearch,
    this.globalSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const LearningProgressIndicators(),
                AnimatedSize(
                  duration: FluffyThemes.animationDuration,
                  child: showSearch
                      ? TextField(
                          controller: controller.searchController,
                          focusNode: controller.searchFocusNode,
                          textInputAction: TextInputAction.search,
                          onChanged: (text) => controller.onSearchEnter(
                            text,
                            globalSearch: globalSearch,
                          ),
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
                            prefixIcon: controller.isSearchMode
                                ? IconButton(
                                    tooltip: L10n.of(context).cancel,
                                    icon: const Icon(Icons.close_outlined),
                                    onPressed: controller.cancelSearch,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  )
                                : IconButton(
                                    onPressed: controller.startSearch,
                                    icon: Icon(
                                      Icons.search_outlined,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/utils/sync_status_localization.dart';
import '../../widgets/matrix.dart';

class ChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatListController controller;
  final bool globalSearch;

  const ChatListHeader({
    super.key,
    required this.controller,
    this.globalSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final client = Matrix.of(context).client;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: StreamBuilder(
        stream: client.onSyncStatus.stream,
        builder: (context, snapshot) {
          final status = client.onSyncStatus.value ??
              const SyncStatusUpdate(SyncStatus.waitingForResponse);
          final hide = client.onSync.value != null &&
              status.status != SyncStatus.error &&
              client.prevBatch != null;
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  focusNode: controller.searchFocusNode,
                  textInputAction: TextInputAction.search,
                  onChanged: (text) => controller.onSearchEnter(
                    text,
                    globalSearch: globalSearch,
                  ),
                  style: TextStyle(
                    color: theme.colorScheme.onSecondary,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.tertiary,
                    contentPadding: EdgeInsets.zero,
                    hintText: hide
                        ? L10n.of(context).searchChatsRooms
                        : status.calcLocalizedString(context),
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: hide
                        ? controller.isSearchMode
                            ? IconButton(
                                tooltip: L10n.of(context).cancel,
                                icon: const Icon(Icons.close_outlined),
                                onPressed: controller.cancelSearch,
                                color: theme.colorScheme.onSecondary,
                              )
                            : IconButton(
                                onPressed: controller.startSearch,
                                icon: Icon(
                                  Icons.search_outlined,
                                  color: theme.colorScheme.onSecondary,
                                ),
                              )
                        : Container(
                            margin: const EdgeInsets.all(12),
                            width: 8,
                            height: 8,
                            child: Center(
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                value: status.progress,
                                valueColor: status.error != null
                                    ? AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.secondary,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                    suffixIcon: controller.isSearchMode && globalSearch
                        ? controller.isSearching
                            ? const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12,
                                ),
                                child: SizedBox.square(
                                  dimension: 24,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                        : SizedBox(
                            width: 0,
                            child: ClientChooserButton(controller),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/dropdown_text_button.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics_download_enum.dart';
import 'package:fluffychat/pangea/spaces/widgets/download_space_analytics_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class SpaceAnalyticsView extends StatelessWidget {
  final SpaceAnalyticsState controller;
  const SpaceAnalyticsView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final mini = constraints.maxWidth <= 550;
        return MaxWidthBody(
          maxWidth: 1000,
          showBorder: false,
          child: Column(
            spacing: !mini ? 24.0 : 12.0,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: !mini ? 12.0 : 4.0,
                    children: [
                      _MenuButton(
                        text: L10n.of(context).requestAll,
                        icon: Symbols.approval_delegation,
                        onPressed: controller.requestAllAnalytics,
                        mini: mini,
                        hideLabel: false,
                      ),
                      if (kIsWeb &&
                          controller.room != null &&
                          controller.availableAnalyticsRooms.isNotEmpty)
                        _MenuButton(
                          text: L10n.of(context).download,
                          icon: Icons.download,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => DownloadAnalyticsDialog(
                                space: controller.room!,
                                analyticsRooms:
                                    controller.availableAnalyticsRooms,
                              ),
                            );
                          },
                          mini: mini,
                        ),
                    ],
                  ),
                  Row(
                    spacing: !mini ? 12.0 : 4.0,
                    children: [
                      if (controller.lastUpdatedString != null)
                        Text(
                          L10n.of(context).lastUpdated(
                            controller.lastUpdatedString!,
                          ),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: !mini ? 12.0 : 8.0,
                            color: theme.disabledColor,
                          ),
                        ),
                      _MenuButton(
                        text: L10n.of(context).refresh,
                        icon: Symbols.refresh,
                        onPressed: controller.refresh,
                        mini: mini,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<LanguageModel>(
                          customButton: Container(
                            height: !mini ? 36.0 : 26.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: !mini ? 8.0 : 4.0,
                              vertical: 4.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (controller.selectedLanguage != null)
                                  Text(
                                    mini
                                        ? controller.selectedLanguage!.langCode
                                            .toUpperCase()
                                        : controller.selectedLanguage!
                                                .getDisplayName(context) ??
                                            controller
                                                .selectedLanguage!.displayName,
                                    style: TextStyle(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      fontSize: !mini ? 16.0 : 12.0,
                                    ),
                                  ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: theme.colorScheme.onPrimaryContainer,
                                  size: !mini ? 24.0 : 14.0,
                                ),
                              ],
                            ),
                          ),
                          value: controller.selectedLanguage,
                          items: controller.availableLanguages
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: DropdownTextButton(
                                    text: item.getDisplayName(context) ??
                                        item.displayName,
                                    isSelected: false,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: controller.setSelectedLanguage,
                          buttonStyleData: ButtonStyleData(
                            // This is necessary for the ink response to match our customButton radius.
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            offset: Offset(-160, 0),
                            width: 250,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              controller.initialized
                  ? Table(
                      columnWidths: const {0: FlexColumnWidth(2.5)},
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: theme.dividerColor),
                            ),
                          ),
                          children: [
                            _TableHeaderCell(
                              text: L10n.of(context).viewingAnalytics(
                                controller.completedDownloads,
                                controller.downloads.length,
                              ),
                              icon: Icons.group_outlined,
                              mini: mini,
                            ),
                            _TableHeaderCell(
                              text: L10n.of(context).level,
                              icon: Icons.star,
                              mini: mini,
                            ),
                            _TableHeaderCell(
                              text: L10n.of(context).vocab,
                              icon: Symbols.dictionary,
                              mini: mini,
                            ),
                            _TableHeaderCell(
                              text: L10n.of(context).grammar,
                              icon: Symbols.toys_and_games,
                              mini: mini,
                            ),
                            _TableHeaderCell(
                              text: L10n.of(context).activities,
                              icon: Icons.radar,
                              mini: mini,
                            ),
                          ],
                        ),
                        ...controller.sortedDownloads.mapIndexed(
                          (index, entry) {
                            final download = entry.value;
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Opacity(
                                    opacity: download.requestStatus.opacity,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: !mini ? 12.0 : 4.0,
                                      ),
                                      child: Row(
                                        spacing: !mini ? 16.0 : 8.0,
                                        children: [
                                          Avatar(
                                            size: !mini ? 64.0 : 40.0,
                                            mxContent: entry.key.avatarUrl,
                                            name: entry.key.calcDisplayname(),
                                            userId: entry.key.id,
                                            presenceUserId: entry.key.id,
                                          ),
                                          Flexible(
                                            child: Column(
                                              spacing: 4.0,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height:
                                                      index == 0 ? 8.0 : 0.0,
                                                ),
                                                Text(
                                                  entry.key.id,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize:
                                                        !mini ? 16.0 : 12.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                _RequestButton(
                                                  status:
                                                      download.requestStatus,
                                                  onPressed: () => controller
                                                      .requestAnalytics(
                                                    entry.key,
                                                  ),
                                                  mini: mini,
                                                ),
                                                const SizedBox(height: 8.0),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                _TableContentCell(
                                  text: download.summary?.level?.toString(),
                                  downloadStatus: download.downloadStatus,
                                  requestStatus: download.requestStatus,
                                  mini: mini,
                                ),
                                _TableContentCell(
                                  text: download.summary?.numLemmas.toString(),
                                  downloadStatus: download.downloadStatus,
                                  requestStatus: download.requestStatus,
                                  mini: mini,
                                ),
                                _TableContentCell(
                                  text: download.summary?.numMorphConstructs
                                      .toString(),
                                  downloadStatus: download.downloadStatus,
                                  requestStatus: download.requestStatus,
                                  mini: mini,
                                ),
                                _TableContentCell(
                                  text: download.summary?.numCompletedActivities
                                      .toString(),
                                  downloadStatus: download.downloadStatus,
                                  requestStatus: download.requestStatus,
                                  mini: mini,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  : const CircularProgressIndicator.adaptive(),
            ],
          ),
        );
      },
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  final bool mini;
  final bool? hideLabel;

  const _MenuButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.mini = false,
    this.hideLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final height = !mini ? 36.0 : 26.0;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onPressed,
        child: Container(
          height: height,
          width: hideLabel ?? mini ? height : null,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(40),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: !mini ? 8.0 : 4.0,
            vertical: 4.0,
          ),
          child: hideLabel ?? mini
              ? Icon(
                  icon,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: !mini ? 24.0 : 14.0,
                )
              : Row(
                  spacing: 4.0,
                  children: [
                    Icon(
                      icon,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: !mini ? 24.0 : 14.0,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: !mini ? 16.0 : 12.0,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool mini;

  const _TableHeaderCell({
    required this.text,
    required this.icon,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: 8.0,
      ),
      child: Column(
        spacing: 10.0,
        children: [
          Icon(icon, size: 22.0),
          Text(
            text,
            style: TextStyle(
              fontSize: !mini ? 12.0 : 8.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableContentCell extends StatelessWidget {
  final String? text;
  final DownloadStatus downloadStatus;
  final RequestStatus requestStatus;
  final bool mini;

  const _TableContentCell({
    required this.text,
    required this.downloadStatus,
    required this.requestStatus,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    if (downloadStatus != DownloadStatus.complete) {
      return _MissingContentCell(
        downloadStatus,
        requestStatus,
      );
    }

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: Opacity(
        opacity: requestStatus.opacity,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text!,
            style: TextStyle(
              fontSize: !mini ? 16.0 : 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _MissingContentCell extends StatelessWidget {
  final DownloadStatus status;
  final RequestStatus requestStatus;

  const _MissingContentCell(
    this.status,
    this.requestStatus,
  );

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: Opacity(
        opacity: requestStatus.opacity,
        child: Container(
          alignment: Alignment.center,
          child: status == DownloadStatus.loading
              ? const SizedBox(
                  width: 16.0,
                  height: 16.0,
                  child: CircularProgressIndicator.adaptive(),
                )
              : Icon(
                  requestStatus == RequestStatus.unavailable
                      ? Icons.block
                      : Icons.visibility_off_outlined,
                  size: 16.0,
                ),
        ),
      ),
    );
  }
}

class _RequestButton extends StatelessWidget {
  final RequestStatus status;
  final VoidCallback onPressed;
  final bool mini;

  const _RequestButton({
    required this.status,
    required this.onPressed,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!status.showButton) return const SizedBox.shrink();
    return MouseRegion(
      cursor: status.enabled ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: status.enabled ? onPressed : null,
        child: Opacity(
          opacity: status.enabled ? 0.9 : 0.3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: status.backgroundColor(context),
            ),
            child: Row(
              spacing: 8.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  status.icon,
                  size: !mini ? 12.0 : 8.0,
                ),
                Text(
                  status.label(context),
                  style: TextStyle(fontSize: !mini ? 12.0 : 8.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

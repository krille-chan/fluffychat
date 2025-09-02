import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/find_your_people/find_your_people.dart';
import 'package:fluffychat/pangea/find_your_people/public_space_tile.dart';
import 'package:fluffychat/pangea/spaces/utils/space_code.dart';

class FindYourPeopleView extends StatelessWidget {
  final FindYourPeopleState controller;

  const FindYourPeopleView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return Scaffold(
      appBar: isColumnMode
          ? null
          : AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Icon(
                Icons.groups_outlined,
                size: 24.0,
                color: theme.colorScheme.primary,
              ),
              centerTitle: false,
              leadingWidth: 48.0,
              actions: [
                TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.join_full,
                        color: theme.colorScheme.primary,
                        size: 24.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        L10n.of(context).joinWithCode,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () =>
                      SpaceCodeUtil.joinWithSpaceCodeDialog(context),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/rooms/communities/newcourse'),
        icon: const Icon(Icons.add_box_outlined),
        label: Text(
          L10n.of(context).newCourse,
          overflow: TextOverflow.fade,
        ),
      ),
      body: Padding(
        padding: isColumnMode
            ? const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              )
            : const EdgeInsets.all(12.0),
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isColumnMode)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 12.0,
                ),
                child: Text(
                  L10n.of(context).findCourse,
                  style: const TextStyle(fontSize: 32.0),
                ),
              ),
            Expanded(
              child: Column(
                spacing: isColumnMode ? 32.0 : 16.0,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ConstrainedBox(
                              constraints: isColumnMode
                                  ? const BoxConstraints(
                                      minWidth: 200.0,
                                      maxWidth: 400.0,
                                    )
                                  : BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                              24.0,
                                    ),
                              child: SizedBox(
                                height: 40.0,
                                width: isColumnMode ? 300.0 : null,
                                child: TextField(
                                  controller: controller.searchController,
                                  onChanged: controller.onSearchEnter,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    filled: !isColumnMode,
                                    fillColor: isColumnMode
                                        ? null
                                        : theme.colorScheme.secondaryContainer,
                                    border: OutlineInputBorder(
                                      borderSide: isColumnMode
                                          ? const BorderSide()
                                          : BorderSide.none,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      20.0,
                                      0,
                                    ),
                                    hintText: L10n.of(context).findCourse,
                                    hintStyle: TextStyle(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.search_outlined,
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (isColumnMode)
                              Wrap(
                                children: [
                                  TextButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.join_full,
                                          color: theme
                                              .colorScheme.onPrimaryContainer,
                                          size: 24.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          L10n.of(context).joinWithCode,
                                          style: TextStyle(
                                            color: theme
                                                .colorScheme.onPrimaryContainer,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () =>
                                        SpaceCodeUtil.joinWithSpaceCodeDialog(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  controller.error != null
                      ? Column(
                          spacing: 8.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ErrorIndicator(
                              message: L10n.of(context).oopsSomethingWentWrong,
                            ),
                            IconButton(
                              onPressed: controller.setSpaceItems,
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        )
                      : controller.loading
                          ? const CircularProgressIndicator.adaptive()
                          : controller.spaceItems.isEmpty
                              ? Text(
                                  L10n.of(context).nothingFound,
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: controller.spaceItems.length,
                                    itemBuilder: (context, index) {
                                      final space =
                                          controller.spaceItems[index];
                                      return Padding(
                                        padding: isColumnMode
                                            ? const EdgeInsets.only(
                                                bottom: 32.0,
                                              )
                                            : const EdgeInsets.only(
                                                bottom: 16.0,
                                              ),
                                        child: PublicSpaceTile(space: space),
                                      );
                                    },
                                  ),
                                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

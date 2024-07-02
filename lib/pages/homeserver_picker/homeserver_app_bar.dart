import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/homeserver_picker/public_homeserver.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'homeserver_bottom_sheet.dart';
import 'homeserver_picker.dart';

class HomeserverAppBar extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<PublicHomeserver>(
      decorationBuilder: (context, child) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 256),
        child: Material(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          elevation: Theme.of(context).appBarTheme.scrolledUnderElevation ?? 4,
          shadowColor:
              Theme.of(context).appBarTheme.shadowColor ?? Colors.black,
          child: child,
        ),
      ),
      emptyBuilder: (context) => ListTile(
        leading: const Icon(Icons.search_outlined),
        title: Text(L10n.of(context)!.nothingFound),
      ),
      loadingBuilder: (context) => ListTile(
        leading: const CircularProgressIndicator.adaptive(strokeWidth: 2),
        title: Text(L10n.of(context)!.loadingPleaseWait),
      ),
      errorBuilder: (context, error) => ListTile(
        leading: const Icon(Icons.error_outlined),
        title: Text(
          error.toLocalizedString(context),
        ),
      ),
      itemBuilder: (context, homeserver) => ListTile(
        title: Text(homeserver.name),
        subtitle: homeserver.description == null
            ? null
            : Text(homeserver.description ?? ''),
        trailing: IconButton(
          icon: const Icon(Icons.info_outlined),
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => HomeserverBottomSheet(
              homeserver: homeserver,
            ),
          ),
        ),
      ),
      suggestionsCallback: (pattern) async {
        pattern = pattern.toLowerCase().trim();
        final homeservers = await controller.loadHomeserverList();
        final matches = homeservers
            .where(
              (homeserver) =>
                  homeserver.name.toLowerCase().contains(pattern) ||
                  (homeserver.description?.toLowerCase().contains(pattern) ??
                      false),
            )
            .toList();
        if (pattern.contains('.') &&
            pattern.split('.').any((part) => part.isNotEmpty) &&
            !matches.any((homeserver) => homeserver.name == pattern)) {
          matches.add(PublicHomeserver(name: pattern));
        }
        return matches;
      },
      onSelected: (suggestion) {
        controller.homeserverController.text = suggestion.name;
        controller.checkHomeserverAction();
      },
      controller: controller.homeserverController,
      builder: (context, textEditingController, focusNode) => TextField(
        enabled: !controller.isLoggingIn,
        controller: textEditingController,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: Navigator.of(context).canPop()
              ? IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
          fillColor: FluffyThemes.isColumnMode(context)
              ? Theme.of(context).colorScheme.surface
              // ignore: deprecated_member_use
              : Theme.of(context).colorScheme.surfaceVariant,
          prefixText: '${L10n.of(context)!.homeserver}: ',
          hintText: L10n.of(context)!.enterYourHomeserver,
          suffixIcon: const Icon(Icons.search),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: controller.checkHomeserverAction,
        autocorrect: false,
      ),
    );
  }
}

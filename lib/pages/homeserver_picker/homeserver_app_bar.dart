import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';

import 'package:fluffychat/config/app_config.dart';
import 'homeserver_bottom_sheet.dart';
import 'homeserver_picker.dart';

class HomeserverAppBar extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<HomeserverBenchmarkResult>(
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        elevation: Theme.of(context).appBarTheme.scrolledUnderElevation ?? 4,
        shadowColor: Theme.of(context).appBarTheme.shadowColor ?? Colors.black,
        constraints: const BoxConstraints(maxHeight: 256),
      ),
      itemBuilder: (context, homeserver) => ListTile(
        title: Text(homeserver.homeserver.baseUrl.toString()),
        subtitle: Text(homeserver.homeserver.description ?? ''),
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
        final homeserverList =
            await const JoinmatrixOrgParser().fetchHomeservers();
        final benchmark = await HomeserverListProvider.benchmarkHomeserver(
          homeserverList,
          timeout: const Duration(seconds: 3),
        );
        return benchmark;
      },
      onSuggestionSelected: (suggestion) {
        controller.homeserverController.text =
            suggestion.homeserver.baseUrl.host;
        controller.checkHomeserverAction();
      },
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller.homeserverController,
        decoration: InputDecoration(
          prefixIcon: Navigator.of(context).canPop()
              ? IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
          fillColor: Theme.of(context).colorScheme.onInverseSurface,
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

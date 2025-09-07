import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';

class HomeserverPickerPage extends StatelessWidget {
  final HomeserverPickerType type;
  const HomeserverPickerPage({required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HomeserverPickerViewModel(
      type: type,
      builder: (context, state) {
        final selectedHomserver = state.selectedHomeserver;
        final publicHomeservers = state.publicHomeservers;
        return LoginScaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              switch (type) {
                HomeserverPickerType.login =>
                  L10n.of(context).loginWithExistingAccount,
                HomeserverPickerType.register =>
                  L10n.of(context).createNewAccount,
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  readOnly: state.isLoading,
                  controller: state.filterTextController,
                  decoration: InputDecoration(
                    filled: true,
                    errorText: state.error,
                    fillColor: theme.colorScheme.surfaceContainer,
                    prefixIcon: const Icon(Icons.search_outlined),
                    hintText: 'Choose a server... Any server!',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.help_outline_outlined),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: publicHomeservers == null
              ? state.error != null
                  ? Center(
                      child: TextButton(
                        onPressed: state.fetchHomeservers,
                        child: Text(L10n.of(context).tryAgain),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
              : RadioGroup(
                  groupValue: state.selectedHomeserver,
                  onChanged: state.selectHomeserver,
                  child: ListView.builder(
                    itemCount: publicHomeservers.length,
                    itemBuilder: (context, i) {
                      final server = publicHomeservers[i];
                      return RadioListTile.adaptive(
                        enabled: !state.isLoading,
                        value: server,
                        radioScaleFactor: 2,
                        secondary: IconButton(
                          icon: const Icon(Icons.info_outlined),
                          onPressed: () {},
                        ),
                        title: Text(server.name ?? 'Unknown'),
                        subtitle: Column(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (server.languages?.isNotEmpty == true)
                              Row(
                                spacing: 4.0,
                                children: server.languages!
                                    .map(
                                      (language) => Material(
                                        borderRadius: BorderRadius.circular(
                                          AppConfig.borderRadius,
                                        ),
                                        color:
                                            theme.colorScheme.tertiaryContainer,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0,
                                            vertical: 3.0,
                                          ),
                                          child: Text(
                                            language,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: theme.colorScheme
                                                  .onTertiaryContainer,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            if (server.features?.isNotEmpty == true)
                              Row(
                                spacing: 4.0,
                                children: server.features!
                                    .map(
                                      (feature) => Material(
                                        borderRadius: BorderRadius.circular(
                                          AppConfig.borderRadius,
                                        ),
                                        color: theme
                                            .colorScheme.secondaryContainer,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0,
                                            vertical: 3.0,
                                          ),
                                          child: Text(
                                            feature,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: theme.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            Text(
                              server.description ?? 'A general homeserver',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          bottomNavigationBar: AnimatedSize(
            duration: FluffyThemes.animationDuration,
            curve: FluffyThemes.animationCurve,
            child: selectedHomserver == null
                ? const SizedBox.shrink()
                : Material(
                    elevation: 8,
                    shadowColor: theme.appBarTheme.shadowColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => state
                                .checkHomeserverAction(selectedHomserver.name!),
                        child: state.isLoading
                            ? const CircularProgressIndicator.adaptive()
                            : Text(L10n.of(context).continueText),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

enum HomeserverPickerType { login, register }

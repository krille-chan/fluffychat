import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/sign_in/view_model/model/public_homeserver_data.dart';
import 'package:fluffychat/pages/sign_in/view_model/sign_in_view_model.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/sign_in_flows/check_homeserver.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/view_model_builder.dart';

class SignInPage extends StatelessWidget {
  final bool signUp;
  const SignInPage({required this.signUp, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ViewModelBuilder(
      create: () => SignInViewModel(Matrix.of(context), signUp: signUp),
      builder: (context, viewModel, _) {
        final state = viewModel.value;
        final publicHomeservers = state.filteredPublicHomeservers;
        final selectedHomserver = state.selectedHomeserver;
        return LoginScaffold(
          appBar: AppBar(
            leading:
                state.loginLoading.connectionState == ConnectionState.waiting
                ? CloseButton(
                    onPressed: () =>
                        viewModel.setLoginLoading(AsyncSnapshot.nothing()),
                  )
                : BackButton(onPressed: Navigator.of(context).pop),
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: theme.colorScheme.surface,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text(
              signUp
                  ? L10n.of(context).createNewAccount
                  : L10n.of(context).login,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              spacing: 16,
              children: [
                SelectableText(
                  signUp
                      ? L10n.of(context).signUpGreeting
                      : L10n.of(context).signInGreeting,
                  textAlign: .center,
                ),
                TextField(
                  readOnly:
                      state.publicHomeservers.connectionState ==
                          ConnectionState.waiting ||
                      state.loginLoading.connectionState ==
                          ConnectionState.waiting,
                  controller: viewModel.filterTextController,
                  autocorrect: false,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.secondaryContainer,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    errorText: state.publicHomeservers.error?.toLocalizedString(
                      context,
                    ),
                    prefixIcon: const Icon(Icons.search_outlined),
                    hintText: L10n.of(context).searchOrEnterHomeserverAddress,
                  ),
                ),
                if (state.publicHomeservers.connectionState ==
                    ConnectionState.done)
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(
                        AppConfig.borderRadius,
                      ),
                      clipBehavior: Clip.hardEdge,
                      color: theme.colorScheme.surfaceContainerLow,
                      child: RadioGroup<PublicHomeserverData>(
                        groupValue: state.selectedHomeserver,
                        onChanged: viewModel.selectHomeserver,
                        child: ListView.builder(
                          itemCount: publicHomeservers.length,
                          itemBuilder: (context, i) {
                            final server = publicHomeservers[i];
                            final website = server.website;
                            return Semantics(
                              identifier: 'homeserver_tile_$i',
                              child: RadioListTile(
                                value: server,
                                enabled:
                                    state.loginLoading.connectionState !=
                                    ConnectionState.waiting,
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(server.name ?? 'Unknown'),
                                    ),
                                    if (website != null)
                                      SizedBox.square(
                                        dimension: 32,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.open_in_new_outlined,
                                            size: 16,
                                          ),
                                          onPressed: () =>
                                              launchUrlString(website),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Column(
                                  spacing: 4.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (server.features?.isNotEmpty == true)
                                      Wrap(
                                        spacing: 4.0,
                                        runSpacing: 4.0,
                                        children: [
                                          ...?server.languages?.map(
                                            (language) => Material(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppConfig.borderRadius,
                                                  ),
                                              color: theme
                                                  .colorScheme
                                                  .tertiaryContainer,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6.0,
                                                      vertical: 3.0,
                                                    ),
                                                child: Text(
                                                  language,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: theme
                                                        .colorScheme
                                                        .onTertiaryContainer,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ...server.features!.map(
                                            (feature) => Material(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppConfig.borderRadius,
                                                  ),
                                              color: theme
                                                  .colorScheme
                                                  .secondaryContainer,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6.0,
                                                      vertical: 3.0,
                                                    ),
                                                child: Text(
                                                  feature,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: theme
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    Text(
                                      server.description ??
                                          'A matrix homeserver',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                else
                  Center(child: CircularProgressIndicator.adaptive()),
              ],
            ),
          ),
          bottomNavigationBar: AnimatedSize(
            duration: FluffyThemes.animationDuration,
            curve: FluffyThemes.animationCurve,
            child:
                selectedHomserver == null ||
                    !publicHomeservers.contains(selectedHomserver)
                ? const SizedBox.shrink()
                : Material(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SafeArea(
                        child: Semantics(
                          identifier: 'connect_to_homeserver_button',
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                            onPressed:
                                state.loginLoading.connectionState ==
                                    ConnectionState.waiting
                                ? null
                                : () => connectToHomeserverFlow(
                                    selectedHomserver,
                                    context,
                                    viewModel.setLoginLoading,
                                    signUp,
                                  ),
                            child:
                                state.loginLoading.connectionState ==
                                    ConnectionState.waiting
                                ? const CircularProgressIndicator.adaptive()
                                : Text(L10n.of(context).continueText),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

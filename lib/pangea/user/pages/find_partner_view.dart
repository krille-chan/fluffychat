import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as matrix;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/pangea/learning_settings/utils/country_display.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_language_dropdown.dart';
import 'package:fluffychat/pangea/user/models/user_model.dart';
import 'package:fluffychat/pangea/user/widgets/list_placeholder.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../widgets/profile_bottom_sheet.dart';
import 'find_partner.dart';

class FindPartnerView extends StatelessWidget {
  final FindPartnerController controller;
  const FindPartnerView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const PageTitleText(),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: FluffyThemes.columnWidth * 2,
            minWidth: FluffyThemes.columnWidth * 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LanguageSelectionRow(
                controller: controller,
                isSource: true,
              ),
              LanguageSelectionRow(
                controller: controller,
                isSource: false,
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L10n.of(context).iWantALanguagePartnerFrom,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          controller.countrySearch ??
                              L10n.of(context).worldWide,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: controller.flagEmoji != null
                              ? RichText(
                                  text: TextSpan(
                                    text: controller.flagEmoji,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                )
                              : const PangeaLogoSvg(width: 30),
                        ),
                        IconButton(
                          icon: const Icon(Icons.expand_more),
                          onPressed: () => showCountryPicker(
                            showWorldWide: true,
                            context: context,
                            showPhoneCode: false,
                            onSelect: (Country country) {
                              controller.filterUserProfiles(
                                country: country,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              controller.initialLoad
                  ? const ExpandedContainer(body: ListPlaceholder())
                  : controller.userProfiles.isNotEmpty
                      ? ExpandedContainer(
                          body: ListView.builder(
                            controller: controller.scrollController,
                            itemCount: controller.userProfiles.length + 1,
                            itemBuilder: (context, i) => i !=
                                    controller.userProfiles.length
                                ? UserProfileEntry(
                                    pangeaProfile: controller.userProfiles[i],
                                    controller: controller,
                                  )
                                : controller.loading
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      )
                                    : const SizedBox.shrink(),
                          ),
                        )
                      : ExpandedContainer(
                          body: Center(
                            child: Text(L10n.of(context).noResults),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandedContainer extends StatelessWidget {
  const ExpandedContainer({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: body,
      ),
    );
  }
}

class ProfileSearchTextField extends StatelessWidget {
  const ProfileSearchTextField({
    super.key,
    required this.controller,
  });

  final FindPartnerController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: L10n.of(context).searchBy,
        suffixIconConstraints: const BoxConstraints(
          maxWidth: 48,
          maxHeight: 48,
          minWidth: 48,
        ),
        suffixIcon: controller.initialLoad
            ? const CircularProgressIndicator.adaptive()
            : const Icon(Icons.search_outlined),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onChanged: controller.searchUserProfilesWithCoolDown,
    );
  }
}

class PageTitleText extends StatelessWidget {
  const PageTitleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        L10n.of(context).iWantAConversationPartner,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class LanguageSelectionRow extends StatelessWidget {
  const LanguageSelectionRow({
    super.key,
    required this.controller,
    required this.isSource,
  });

  final FindPartnerController controller;
  final bool isSource;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: ListTile(
            title: isSource
                ? Text(
                    L10n.of(context).iWantALanguagePartnerWhoSpeaks,
                    style: const TextStyle(fontSize: 16),
                  )
                : Text(
                    L10n.of(context).iWantALanguagePartnerWhoIsLearning,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
        Flexible(
          child: PLanguageDropdown(
            languages: isSource
                ? controller.pangeaController.pLanguageStore.baseOptions
                : controller.pangeaController.pLanguageStore.targetOptions,
            onChange: (language) {
              controller.filterUserProfiles(
                sourceLanguage: isSource ? language : null,
                targetLanguage: isSource ? null : language,
              );
            },
            isL2List: !isSource,
            initialLanguage: isSource
                ? controller.sourceLanguageSearch
                : controller.targetLanguageSearch,
            decorationText: isSource
                ? L10n.of(context).myBaseLanguage
                : L10n.of(context).iWantToLearn,
          ),
        ),
      ],
    );
  }
}

class UserProfileEntry extends StatelessWidget {
  final PangeaProfile pangeaProfile;
  final FindPartnerController controller;

  const UserProfileEntry({
    super.key,
    required this.pangeaProfile,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder<matrix.Profile>(
          future: Matrix.of(context)
              .client
              .getProfileFromUserId(pangeaProfile.pangeaUserId),
          builder: ((context, snapshot) {
            final matrixProfile = snapshot.data;
            return ListTile(
              leading: Avatar(
                name: matrixProfile == null || matrixProfile.avatarUrl == null
                    ? pangeaProfile.pangeaUserId
                    : null,
                mxContent: matrixProfile?.avatarUrl,
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      //PTODO - get matrix u and show displayName
                      matrixProfile?.displayName ??
                          pangeaProfile.pangeaUserId.replaceAll(
                            ":${AppConfig.defaultHomeserver.replaceAll("matrix.", "")}",
                            "",
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 20),
                  RichText(
                    text: TextSpan(
                      text: CountryDisplayUtil.flagEmoji(pangeaProfile.country),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (c) => ProfileBottomSheet(
                  userId: pangeaProfile.pangeaUserId,
                  outerContext: context,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

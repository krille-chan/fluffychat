import 'dart:async';

import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/user/models/user_model.dart';
import '../../../widgets/matrix.dart';
import '../../common/controllers/pangea_controller.dart';
import '../models/user_profile_search_model.dart';
import '../repo/user_repo.dart';
import 'find_partner_view.dart';

class FindPartner extends StatefulWidget {
  const FindPartner({super.key});

  @override
  State<FindPartner> createState() => FindPartnerController();
}

class FindPartnerController extends State<FindPartner> {
  PangeaController pangeaController = MatrixState.pangeaController;

  bool initialLoad = true;
  bool loading = false;
  String currentSearchTerm = "";
  late LanguageModel targetLanguageSearch;
  late LanguageModel sourceLanguageSearch;
  String? countrySearch;
  String? flagEmoji;

  //PTODO - implement pagination
  String? nextUrl = "";
  int nextPage = 1;

  Timer? coolDown;

  final List<PangeaProfile> _userProfilesCache = [];

  final scrollController = ScrollController();
  String? error;

  @override
  void initState() {
    targetLanguageSearch = pangeaController.languageController.userL1 ??
        pangeaController.pLanguageStore.targetOptions[1];
    sourceLanguageSearch = pangeaController.languageController.userL2 ??
        pangeaController.pLanguageStore.targetOptions[0];

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        searchUserProfiles();
      }
    });

    searchUserProfiles().then((_) => setState(() => initialLoad = false));

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error != null && error!.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(L10n.of(context).oopsSomethingWentWrong),
            Text(L10n.of(context).errorPleaseRefresh),
          ],
        ),
      );
    }
    return FindPartnerView(this);
  }

  List<PangeaProfile> get userProfiles => _userProfilesCache.where((p) {
        return (p.targetLanguage != null &&
                targetLanguageSearch.langCode == p.targetLanguage) &&
            (p.sourceLanguage != null &&
                sourceLanguageSearch.langCode == p.sourceLanguage) &&
            (countrySearch == null ||
                (p.country != null && countrySearch == p.country));
      }).toList();

  void searchUserProfilesWithCoolDown(String text) {
    coolDown?.cancel();
    coolDown = Timer(
      const Duration(milliseconds: 0),
      () => searchUserProfiles(),
    );
  }

  Future<void> searchUserProfiles() async {
    coolDown?.cancel();
    if (loading || nextUrl == null) return;
    setState(() => loading = true);

    UserProfileSearchResponse response;
    try {
      final String accessToken = pangeaController.userController.accessToken;
      response = await PUserRepo.searchUserProfiles(
        accessToken: accessToken,
        targetLanguage: targetLanguageSearch.langCode,
        sourceLanguage: sourceLanguageSearch.langCode,
        country: countrySearch,
        limit: 15,
        pageNumber: nextPage.toString(),
      );
    } catch (err, s) {
      error = err.toString();
      setState(() => loading = false);
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          "accessToken": pangeaController.userController.accessToken,
          "targetLanguage": targetLanguageSearch.langCode,
          "sourceLanguage": sourceLanguageSearch.langCode,
          "country": countrySearch,
          "pageNumber": nextPage.toString(),
        },
      );
      return;
    }

    nextUrl = response.next;
    nextPage++;

    final String? currentUserId = pangeaController.matrixState.client.userID;
    _userProfilesCache.addAll(
      response.results.where(
        (p) =>
            !_userProfilesCache.any(
              (element) => p.pangeaUserId == element.pangeaUserId,
            ) &&
            p.pangeaUserId != currentUserId,
      ),
    );

    setState(() => loading = false);
  }

  Future<void> filterUserProfiles({
    LanguageModel? targetLanguage,
    LanguageModel? sourceLanguage,
    Country? country,
  }) async {
    if (country != null) {
      if (country.name != "World Wide") {
        countrySearch = country.displayNameNoCountryCode;
        flagEmoji = country.flagEmoji;
      } else {
        countrySearch = null;
        flagEmoji = null;
      }
    }
    if (targetLanguage != null) {
      targetLanguageSearch = targetLanguage;
    }
    if (sourceLanguage != null) {
      sourceLanguageSearch = sourceLanguage;
    }
    nextPage = 1;
    nextUrl = "";
    await searchUserProfiles();
    setState(() {});
  }
}

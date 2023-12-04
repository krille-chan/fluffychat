import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/models/user_model.dart';
import '../../../widgets/matrix.dart';
import '../../controllers/pangea_controller.dart';
import '../../models/user_profile_search_model.dart';
import '../../repo/user_repo.dart';
import 'find_partner_view.dart';

class FindPartner extends StatefulWidget {
  const FindPartner({Key? key}) : super(key: key);

  @override
  State<FindPartner> createState() => FindPartnerController();
}

class FindPartnerController extends State<FindPartner> {
  PangeaController pangeaController = MatrixState.pangeaController;

  bool loading = false;
  String currentSearchTerm = "";
  late LanguageModel targetLanguageSearch;
  late LanguageModel sourceLanguageSearch;
  String? countrySearch;
  String? flagEmoji;

  //PTODO - implement pagination
  String? previousPage;

  Timer? coolDown;

  final List<Profile> _userProfilesCache = [];

  @override
  void initState() {
    targetLanguageSearch = pangeaController.languageController.userL1 ??
        pangeaController.pLanguageStore.targetOptions[1];
    sourceLanguageSearch = pangeaController.languageController.userL2 ??
        pangeaController.pLanguageStore.targetOptions[0];

    searchUserProfiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FindPartnerView(this);
  }

  // List<Profile> get userProfiles => currentSearchTerm.isNotEmpty
  //     ? _userProfilesCache
  //         .where((p) =>
  //             (p.fullName != null && p.fullName!.contains(currentSearchTerm)) ||
  //             (p.pangeaUserId != null &&
  //                 p.pangeaUserId!.contains(currentSearchTerm)) ||
  //             (p.sourceLanguage != null &&
  //                 p.sourceLanguage!.contains(currentSearchTerm)) ||
  //             // (p.speaks != null &&
  //             //     p.speaks!.any((e) => e.contains(currentSearchTerm))) ||
  //             (p.country != null && p.country!.contains(currentSearchTerm)) ||
  //             // (p.interests != null &&
  //             //     p.interests!.any((e) => e.contains(currentSearchTerm))))
  //         .toList()
  //     : _userProfilesCache;

  List<Profile> get userProfiles => _userProfilesCache.where((p) {
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

  void searchUserProfiles() async {
    coolDown?.cancel();
    if (loading) return;
    setState(() => loading = true);

    final UserProfileSearchResponse response =
        await PUserRepo.searchUserProfiles(
      accessToken: await pangeaController.userController.accessToken,
      targetLanguage: targetLanguageSearch.langCode,
      sourceLanguage: sourceLanguageSearch.langCode,
      country: countrySearch,
      limit: 30,
    );
    for (final p in response.results) {
      if (!_userProfilesCache
          .any((element) => p.pangeaUserId == element.pangeaUserId)) {
        _userProfilesCache.add(p);
      }
    }

    setState(() => loading = false);
  }
}

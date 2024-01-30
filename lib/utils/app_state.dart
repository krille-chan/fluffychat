import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import '../../utils/voip/call_state_proxy.dart';

class AppState extends ChangeNotifier {
  bool? wipe;
  String? welcomeMessage;
  Profile? userProfile;

  /// set using `setupCallAndOpenCallPage` and manually on incoming call rn.
  CallStateProxy? proxy;
  Function? confirmPINCallback;

  /// used to set the remote caller user to show incoming/outgoing call screens
  /// before a pc is created.
  User? remoteUserInCall;

  /// used by the call screen minimize button to navigate back to the last
  /// screen where banner was tapped
  String? bannerClickedOnPath;

  /// a banner widget which can be set using the `setGlobalBanner` and removed
  /// using the `removeGlobalBanner` methods. Is shown on all screens
  Widget? globalBanner;

  /// similar to `globalBanner` but shown below it if both banners are set.
  /// In non-column mode, it's only shown at the top of `NavScaffold` and nowhere else
  Widget? secondaryGlobalBanner;

  /// The [eventId] which has been searched by user. Only used in three column mode.
  String? searchedEventId;

  /// stores a list of the room ids where user clicked to hide the join group call
  /// banner
  List<String> hideGroupCallBanner = [];
  void addRoomToHideBanner(Room room) {
    hideGroupCallBanner.add(room.id);
    notifyListeners();
  }

  /// Use these to set banner anytime in the app
  void setGlobalBanner(Widget banner, {bool isSecondary = false}) {
    if (isSecondary) {
      secondaryGlobalBanner = banner;
    } else {
      globalBanner = banner;
    }
    notifyListeners();
  }

  /// Use these to remove the global banner
  void removeGlobalBanner({bool isSecondary = false}) {
    if (isSecondary) {
      secondaryGlobalBanner = null;
    } else {
      globalBanner = null;
    }
    notifyListeners();
  }

  /// Use to set [searchedEventId]. Only use in three column mode.
  void setSearchedEventId(String eventId) {
    searchedEventId = eventId;
    notifyListeners();
  }

  /// Use to remove [searchedEventId]. Only use in three column mode.
  void removeSearchedEventId() {
    searchedEventId = null;
    notifyListeners();
  }
}

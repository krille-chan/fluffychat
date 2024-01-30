import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

class AppState extends ChangeNotifier {
  /// used by the call screen minimize button to navigate back to the last
  /// screen where banner was tapped
  String? bannerClickedOnPath;

  /// a banner widget which can be set using the `setGlobalBanner` and removed
  /// using the `removeGlobalBanner` methods. Is shown on all screens
  Widget? globalBanner;

  /// stores a list of the room ids where user clicked to hide the join group call
  /// banner
  List<String> hideGroupCallBanner = [];
  void addRoomToHideBanner(Room room) {
    hideGroupCallBanner.add(room.id);
    notifyListeners();
  }

  /// Use these to set banner anytime in the app
  void setGlobalBanner(Widget banner, {bool isSecondary = false}) {
    globalBanner = banner;

    notifyListeners();
  }

  /// Use these to remove the global banner
  void removeGlobalBanner({bool isSecondary = false}) {
    globalBanner = null;

    notifyListeners();
  }
}

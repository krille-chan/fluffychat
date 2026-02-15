import 'package:flutter/material.dart';

import 'package:fluffychat/pages/sign_in/view_model/model/public_homeserver_data.dart';

class SignInState {
  PublicHomeserverData? selectedHomeserver;
  AsyncSnapshot<List<PublicHomeserverData>> publicHomeservers =
      const AsyncSnapshot.nothing();
  List<PublicHomeserverData> filteredPublicHomeservers = [];
  AsyncSnapshot<bool> loginLoading = const AsyncSnapshot.nothing();
}

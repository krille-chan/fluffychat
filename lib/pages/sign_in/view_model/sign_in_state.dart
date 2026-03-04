import 'package:flutter/material.dart';

import 'package:fluffychat/pages/sign_in/view_model/model/public_homeserver_data.dart';

class SignInState {
  final PublicHomeserverData? selectedHomeserver;
  final AsyncSnapshot<List<PublicHomeserverData>> publicHomeservers;
  final List<PublicHomeserverData> filteredPublicHomeservers;
  final AsyncSnapshot<bool> loginLoading;

  const SignInState({
    this.selectedHomeserver,
    this.publicHomeservers = const AsyncSnapshot.nothing(),
    this.loginLoading = const AsyncSnapshot.nothing(),
    this.filteredPublicHomeservers = const [],
  });

  SignInState copyWith({
    PublicHomeserverData? selectedHomeserver,
    AsyncSnapshot<List<PublicHomeserverData>>? publicHomeservers,
    AsyncSnapshot<bool>? loginLoading,
    List<PublicHomeserverData>? filteredPublicHomeservers,
  }) {
    return SignInState(
      selectedHomeserver: selectedHomeserver ?? this.selectedHomeserver,
      publicHomeservers: publicHomeservers ?? this.publicHomeservers,
      loginLoading: loginLoading ?? this.loginLoading,
      filteredPublicHomeservers:
          filteredPublicHomeservers ?? this.filteredPublicHomeservers,
    );
  }
}

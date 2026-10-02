// SPDX-FileCopyrightText: 2019-Present svettszx
// SPDX-FileCopyrightText: 2019-Present Contributors to Aerogram
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum OAuthProvider { google, apple }

class OAuthResult {
  final OAuthProvider provider;
  final String? email;
  final String? displayName;
  final String? idToken;
  final String? authorizationCode;

  const OAuthResult({
    required this.provider,
    this.email,
    this.displayName,
    this.idToken,
    this.authorizationCode,
  });
}

class OAuthManager {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<OAuthResult?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) return null;

      return OAuthResult(
        provider: OAuthProvider.google,
        email: account.email,
        displayName: account.displayName,
        idToken: idToken,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  static Future<bool> isGoogleSignedIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      return account != null;
    } catch (_) {
      return false;
    }
  }

  static Future<OAuthResult?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) return null;

      return OAuthResult(
        provider: OAuthProvider.apple,
        email: credential.email,
        displayName: credential.givenName != null || credential.familyName != null
            ? [credential.givenName, credential.familyName]
                .whereType<String>()
                .join(' ')
                .trim()
            : null,
        idToken: identityToken,
        authorizationCode: credential.authorizationCode,
      );
    } catch (_) {
      return null;
    }
  }

  static String providerLabel(OAuthProvider provider) {
    switch (provider) {
      case OAuthProvider.google:
        return 'Google';
      case OAuthProvider.apple:
        return 'Apple';
    }
  }
}

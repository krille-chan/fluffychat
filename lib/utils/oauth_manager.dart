// SPDX-FileCopyrightText: 2019-Present svettszx
// SPDX-FileCopyrightText: 2019-Present Contributors to Aerogram
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:matrix/matrix.dart';

class OAuthManager {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  /// Sign in with Google
  /// Returns the email and id_token if successful
  static Future<({String email, String idToken})?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) return null;

      return (email: account.email, idToken: idToken);
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }

  /// Sign out from Google
  static Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Google Sign-Out error: $e');
    }
  }

  /// Check if user is already signed in with Google
  static Future<bool> isGoogleSignedIn() async {
    final account = await _googleSignIn.signInSilently();
    return account != null;
  }

  /// Sign in with Apple (iOS only)
  /// Returns the email and identityToken if successful
  static Future<({String? email, String identityToken})?> signInWithApple() async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDSignInScopes.email,
          AppleIDSignInScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.example.aerogram.signin',
          teamId: 'YOUR_TEAM_ID', // Replace with your Apple Team ID
          redirectUrl: Uri.parse(
            'https://your-redirect-url.example.com/callback',
          ),
        ),
      );

      final identityToken = result.identityToken;
      if (identityToken == null) return null;

      return (email: result.email, identityToken: identityToken);
    } catch (e) {
      print('Apple Sign-In error: $e');
      return null;
    }
  }

  /// Login to Matrix using OAuth token
  /// This uses a custom login endpoint that supports OAuth tokens
  static Future<void> matrixLoginWithOAuth({
    required Client matrixClient,
    required String oauthToken,
    required String tokenType, // 'google' or 'apple'
    required String? email,
  }) async {
    try {
      // This assumes your homeserver supports OAuth token exchange
      // If not, you'll need to implement custom authentication
      
      // Option 1: Direct Matrix login with email
      if (email != null) {
        await matrixClient.login(
          LoginType.mLoginPassword,
          identifier: AuthenticationThirdPartyIdentifier(
            medium: 'email',
            address: email,
          ),
          // Note: This won't work directly - you'd need server support
          // This is a placeholder for OAuth integration
        );
      }
    } catch (e) {
      print('Matrix OAuth login error: $e');
      rethrow;
    }
  }

  /// Get platform-specific OAuth button label
  static String getOAuthButtonLabel(String platform) {
    switch (platform) {
      case 'google':
        return 'Sign in with Google';
      case 'apple':
        return 'Sign in with Apple';
      default:
        return 'Sign in';
    }
  }

  /// Get platform-specific OAuth button icon
  static String getOAuthButtonIcon(String platform) {
    switch (platform) {
      case 'google':
        return '🔍'; // Google icon
      case 'apple':
        return '🍎'; // Apple icon
      default:
        return '→';
    }
  }
}

/// OAuth token container
class OAuthToken {
  final String token;
  final String tokenType; // 'google' or 'apple'
  final String? email;
  final DateTime expiresAt;

  const OAuthToken({
    required this.token,
    required this.tokenType,
    this.email,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
    'token': token,
    'tokenType': tokenType,
    'email': email,
    'expiresAt': expiresAt.toIso8601String(),
  };

  factory OAuthToken.fromJson(Map<String, dynamic> json) => OAuthToken(
    token: json['token'] as String,
    tokenType: json['tokenType'] as String,
    email: json['email'] as String?,
    expiresAt: DateTime.parse(json['expiresAt'] as String),
  );
}

import 'package:matrix/matrix.dart';

extension OidcSessionJsonExtension on OidcLoginSession {
  static const String storeKey = 'oidc_session';
  static const String homeserverStoreKey = 'oidc_stored_homeserver';
  Map<String, Object?> toJson() => {
    'oidc_client_data': oidcClientData.toJson(),
    'authentication_uri': authenticationUri.toString(),
    'redirect_uri': redirectUri.toString(),
    'code_verifier': codeVerifier,
    'state': state,
  };

  static OidcLoginSession fromJson(Map<String, Object?> json) =>
      OidcLoginSession(
        oidcClientData: OidcClientData.fromJson(
          json['oidc_client_data'] as Map<String, Object?>,
        ),
        authenticationUri: Uri.parse(json['authentication_uri'] as String),
        redirectUri: Uri.parse(json['redirect_uri'] as String),
        codeVerifier: json['code_verifier'] as String,
        state: json['state'] as String,
      );
}

import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';

/// Utility to save and read data both in the matrix profile (this is the default
/// behavior) and in the local storage (local needs to be specificied). An
/// instance of this class is created in the PangeaController.
class PStore {
  final GetStorage _box = GetStorage();
  final PangeaController pangeaController;

  PStore({required this.pangeaController});

  /// Saves the provided [data] with the specified [key] in the local storage.
  ///
  /// By default, the [data] is considered as account data, but you can set
  /// [isAccountData] to false if it's not account-related data.
  ///
  /// Example usage:
  /// ```dart
  /// await save('user', {'name': 'John Doe', 'age': 25});
  /// ```
  Future<void> save(
    String key,
    dynamic data, {
    bool isAccountData = true,
  }) async {
    await _box.write(_key(key, isAccountData: isAccountData), data);
  }

  /// Reads the value associated with the given [key] from the local store.
  ///
  /// If [isAccountData] is true, tries to find key assosiated with the logged in user.
  /// Otherwise, it is read from the general store.
  ///
  /// Returns the value associated with the [key], or
  /// null if the user ID is null or value hasn't been set.
  dynamic read(String key, {bool isAccountData = true}) {
    return pangeaController.matrixState.client.userID != null
        ? _box.read(_key(key, isAccountData: isAccountData))
        : null;
  }

  /// Deletes the value associated with the given [key] from the local store.
  ///
  /// If [isAccountData] is true (default), will try to use key assosiated with the logged in user's ID
  ///
  /// Returns a [Future] that completes when the value is successfully deleted.
  /// If the user is not logged in, the value will not be deleted and the [Future] will complete with null.
  Future<void> delete(String key, {bool isAccountData = true}) async {
    return pangeaController.matrixState.client.userID != null
        ? _box.remove(_key(key, isAccountData: isAccountData))
        : null;
  }

  /// Returns the key for storing data in the pangea store.
  ///
  /// The [key] parameter represents the base key for the data.
  /// The [isAccountData] parameter indicates whether the data is account-specific.
  /// If [isAccountData] is true, the account-specific key is returned by appending the user ID to the base key.
  /// If [isAccountData] is false, the base key is returned as is.
  String _key(String key, {bool isAccountData = true}) {
    return isAccountData
        ? pangeaController.matrixState.client.userID! + key
        : key;
  }

  /// Clears the storage by erasing all data in the box.
  void clearStorage() {
    // this could potenitally be interfering with openning database
    // at the start of the session, which is causing auto log outs on iOS
    Sentry.addBreadcrumb(Breadcrumb(message: 'Clearing local storage'));
    _box.erase();
  }
}

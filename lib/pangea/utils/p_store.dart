import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:matrix/matrix.dart';

class PLocalStore {
  final GetStorage _box = GetStorage();
  final PangeaController pangeaController;

  PLocalStore({required this.pangeaController});

  /// save data in local
  Future<void> save(
    String key,
    dynamic data, {
    bool addClientIdToKey = true,
    bool local = false,
  }) async {
    local
        ? await saveLocal(
            key,
            data,
            addClientIdToKey: addClientIdToKey,
          )
        : await saveProfile(key, data);
  }

  /// fetch data from local
  dynamic read(
    String key, {
    bool addClientIdToKey = true,
    local = false,
  }) {
    return local
        ? readLocal(
            key,
            addClientIdToKey: addClientIdToKey,
          )
        : readProfile(key);
  }

  /// delete data from local
  Future<void> delete(
    String key, {
    bool addClientIdToKey = true,
    local = false,
  }) async {
    return local
        ? deleteLocal(
            key,
            addClientIdToKey: addClientIdToKey,
          )
        : deleteProfile(key);
  }

  /// save data in local
  Future<void> saveLocal(
    String key,
    dynamic data, {
    bool addClientIdToKey = true,
  }) async {
    await _box.write(_key(key, addClientIdToKey: addClientIdToKey), data);
  }

  Future<void> saveProfile(
    String key,
    dynamic data,
  ) async {
    final waitForAccountSync =
        pangeaController.matrixState.client.onSync.stream.firstWhere(
      (sync) =>
          sync.accountData != null &&
          sync.accountData!.any(
            (event) => event.content.keys.any(
              (k) => k == key,
            ),
          ),
    );
    await pangeaController.matrixState.client.setAccountData(
      pangeaController.matrixState.client.userID!,
      key,
      {key: data},
    );
    await waitForAccountSync;
    await pangeaController.matrixState.client.onSyncStatus.stream.firstWhere(
      (syncStatus) => syncStatus.status == SyncStatus.finished,
    );
  }

  /// fetch data from local
  dynamic readLocal(String key, {bool addClientIdToKey = true}) {
    return pangeaController.matrixState.client.userID != null
        ? _box.read(_key(key, addClientIdToKey: addClientIdToKey))
        : null;
  }

  dynamic readProfile(String key) {
    try {
      return pangeaController.matrixState.client.accountData[key]?.content[key];
    } catch (err) {
      ErrorHandler.logError(e: err);
      return null;
    }
  }

  /// delete data from local
  Future<void> deleteLocal(String key, {bool addClientIdToKey = true}) async {
    return pangeaController.matrixState.client.userID != null
        ? _box.remove(_key(key, addClientIdToKey: addClientIdToKey))
        : null;
  }

  Future<void> deleteProfile(key) async {
    return pangeaController.matrixState.client.userID != null
        ? pangeaController.matrixState.client.setAccountData(
            pangeaController.matrixState.client.userID!,
            key,
            {key: null},
          )
        : null;
  }

  _key(String key, {bool addClientIdToKey = true}) {
    return addClientIdToKey
        ? pangeaController.matrixState.client.userID! + key
        : key;
  }

  /// clear all local storage
  clearStorage() {
    _box.erase();
  }
}

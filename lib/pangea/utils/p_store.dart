// Package imports:
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';

class PLocalStore {
  final GetStorage _box = GetStorage();
  final PangeaController pangeaController;

  PLocalStore({required this.pangeaController});

  /// save data in local
  Future<void> save(String key, dynamic data,
      {bool addClientIdToKey = true}) async {
    await _box.write(_key(key, addClientIdToKey: addClientIdToKey), data);
  }

  /// fetch data from local
  dynamic read(String key, {bool addClientIdToKey = true}) {
    return pangeaController.matrixState.client.userID != null
        ? _box.read(_key(key, addClientIdToKey: addClientIdToKey))
        : null;
  }

  /// delete data from local
  Future<void> delete(String key, {bool addClientIdToKey = true}) async {
    return pangeaController.matrixState.client.userID != null
        ? _box.remove(_key(key, addClientIdToKey: addClientIdToKey))
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

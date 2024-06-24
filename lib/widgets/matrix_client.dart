import 'package:matrix/matrix.dart';

class MatrixClient {
  bool _isInitialized = false;
  bool _isSyncComplete = false;

  Client _client;

  MatrixClient(this._client);

  Future<void> initialize() async {
    if (_client.isLogged()) {
      print('Matrix client already logged in');
      _isInitialized = true;
      return;
    }

    await _client.init(
      waitForFirstSync:
          true, // Ensure that the first synchronization is complete
    );
    _isInitialized = true;
    print('Matrix client initialized');
  }

  Future<void> synchronize() async {
    await _client
        .firstSyncReceived; // Wait for the first synchronization to be received
    _isSyncComplete = true;
    print('Matrix client synchronized');
  }

  Future<void> ensureInitializationComplete() async {
    while (!_isInitialized || !_isSyncComplete) {
      await Future.delayed(const Duration(
          milliseconds:
              100)); // Wait until client is fully initialized
    }
  }

  Future<void> start() async {
    await initialize();
    await synchronize();
  }

  bool get isInitialized => _isInitialized && _isSyncComplete;
}

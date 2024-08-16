import 'package:matrix/matrix.dart';

/// A wrapper class for the Matrix [Client] to handle initialization and synchronization.
class MatrixClientWrapper {
  bool _isInitialized = false;
  bool _isSyncComplete = false;

  final Client _client;

  /// Constructor for [MatrixClientWrapper], takes a [Client] instance.
  MatrixClientWrapper(this._client);

  /// Initializes the Matrix client.
  /// If the client is already logged in, it sets the `_isInitialized` flag to true.
  /// Otherwise, it initializes the client and waits for the first sync to complete.
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

  /// Waits for the first synchronization to complete.
  Future<void> synchronize() async {
    await _client
        .firstSyncReceived; // Wait for the first synchronization to be received
    _isSyncComplete = true;
    print('Matrix client synchronized');
  }

  /// Ensures that both initialization and synchronization are complete.
  /// This method keeps checking the flags `_isInitialized` and `_isSyncComplete`
  /// and waits until both are true.
  Future<void> ensureInitializationComplete() async {
    while (!_isInitialized || !_isSyncComplete) {
      await Future.delayed(const Duration(
          milliseconds: 100)); // Wait until client is fully initialized
    }
  }

  /// Starts the client by initializing it and then synchronizing it.
  Future<void> start() async {
    await initialize();
    await synchronize();
  }

  /// Returns true if both initialization and synchronization are complete.
  bool get isInitialized => _isInitialized && _isSyncComplete;
}

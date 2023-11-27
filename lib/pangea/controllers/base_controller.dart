// Dart imports:
import 'dart:async';

class BaseController {
  final StreamController stateListener = StreamController();
  late Stream stateStream;

  BaseController() {
    stateStream = stateListener.stream.asBroadcastStream();
  }

  dispose() {
    stateListener.close();
  }

  setState({dynamic data}) {
    stateListener.add(data);
  }
}

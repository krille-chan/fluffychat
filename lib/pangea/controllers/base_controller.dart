import 'dart:async';

class BaseController<T> {
  final StreamController<T> stateListener = StreamController<T>();
  late Stream<T> stateStream;

  BaseController() {
    stateStream = stateListener.stream.asBroadcastStream();
  }

  dispose() {
    stateListener.close();
  }

  setState(T data) {
    stateListener.add(data);
  }
}

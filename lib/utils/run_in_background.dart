import 'dart:async';

import 'package:isolate/isolate.dart';

Future<T> runInBackground<T, U>(
    FutureOr<T> Function(U arg) function, U arg) async {
  final isolate = await IsolateRunner.spawn();
  try {
    return await isolate.run(function, arg);
  } finally {
    await isolate.close();
  }
}

import 'package:matrix/matrix.dart';

import 'dsl_message.dart';
import 'dsl_render_result.dart';

abstract class DSLHandler {
  String get type;
  int get version;

  bool canHandle(DSLMessage msg) =>
      msg.type == type && msg.version == version;

  DSLRenderResult render(Event event, DSLMessage msg);
}
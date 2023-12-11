import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/widgets/layouts/empty_page.dart';
import '../../../widgets/matrix.dart';
import '../../utils/error_handler.dart';
import '../../utils/set_class_name.dart';
import '../../widgets/space/class_settings.dart';
import 'class_settings_view.dart';
import 'p_class_widgets/room_rules_editor.dart';

class ClassSettingsPage extends StatefulWidget {
  const ClassSettingsPage({super.key});

  @override
  State<ClassSettingsPage> createState() => ClassSettingsController();
}

class ClassSettingsController extends State<ClassSettingsPage> {
  PangeaController pangeaController = MatrixState.pangeaController;

  final GlobalKey<RoomRulesState> rulesEditorKey = GlobalKey<RoomRulesState>();
  final GlobalKey<ClassSettingsState> classSettingsKey =
      GlobalKey<ClassSettingsState>();

  Room? room;

  String? get roomId => GoRouterState.of(context).pathParameters['roomid'];

  Future<void> handleSave(BuildContext context) async {
    if (classSettingsKey.currentState!.sameLanguages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.noIdenticalLanguages),
        ),
      );
      return;
    }
    if (rulesEditorKey.currentState != null) {
      await rulesEditorKey.currentState?.setRoomRules(roomId!);
    } else {
      debugger(when: kDebugMode);
      ErrorHandler.logError(m: "Null rules editor state");
    }
    if (classSettingsKey.currentState != null) {
      await classSettingsKey.currentState?.setClassSettings(
        roomId!,
      );
    } else {
      debugger(when: kDebugMode);
      ErrorHandler.logError(m: "Null class settings state");
    }
  }

  void goback(BuildContext context) {
    context.push("/spaces/$roomId");
  }

  String get className =>
      Matrix.of(context).client.getRoomById(roomId!)?.name ?? '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      room = Matrix.of(context).client.getRoomById(roomId!);
      if (room == null) {
        debugger(when: kDebugMode);
        context.pop();
      }
      setState(() {});
    });
  }
  //PTODO - show loading widget

  void setDisplaynameAction() => setClassDisplayname(context, roomId);

  bool showEditNameIcon = false;
  void hoverEditNameIcon(bool hovering) =>
      setState(() => showEditNameIcon = !showEditNameIcon);

  @override
  Widget build(BuildContext context) => room != null
      ? ClassSettingsPageView(controller: this)
      : const EmptyPage();
}

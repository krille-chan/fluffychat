// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pangea/pages/new_class/new_class_view.dart';
import 'package:fluffychat/pangea/utils/class_code.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../controllers/pangea_controller.dart';
import '../../widgets/space/class_settings.dart';
import '../class_settings/p_class_widgets/room_rules_editor.dart';

class NewClass extends StatefulWidget {
  const NewClass({Key? key}) : super(key: key);

  @override
  NewClassController createState() => NewClassController();
}

class NewClassController extends State<NewClass> {
  TextEditingController controller = TextEditingController();

  final PangeaController pangeaController = MatrixState.pangeaController;
  final GlobalKey<RoomRulesState> rulesEditorKey = GlobalKey<RoomRulesState>();
  final GlobalKey<ClassSettingsState> classSettingsKey =
      GlobalKey<ClassSettingsState>();

  void submitAction([_]) async {
    //TODO: validate that object is complete
    final matrix = Matrix.of(context);
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.classNameRequired),
        ),
      );
      return;
    }
    if (classSettingsKey.currentState == null) {
      debugger(when: kDebugMode);
    }
    if (classSettingsKey.currentState!.sameLanguages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.noIdenticalLanguages),
        ),
      );
      return;
    }

    final roomID = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final String roomID = await matrix.client.createRoom(
          //PTODO - investigate effects of changing visibility from public
          preset: sdk.CreateRoomPreset.publicChat,
          creationContent: {
            'type': RoomCreationTypes.mSpace,
          },
          visibility: sdk.Visibility.public,
          // roomAliasName: controller.text.isNotEmpty
          //     ? "${matrix.client.userID!.localpart}-${controller.text.trim().toLowerCase().replaceAll(' ', '_')}"
          //     : null,
          roomAliasName: ClassCodeUtil.generateClassCode(),
          name: controller.text.isNotEmpty ? controller.text : null,
        );

        if (rulesEditorKey.currentState != null) {
          await rulesEditorKey.currentState!.setRoomRules(roomID);
        } else {
          debugger(when: kDebugMode);
          ErrorHandler.logError(m: "Null rules editor state");
        }
        if (classSettingsKey.currentState != null) {
          await classSettingsKey.currentState!.setClassSettings(
            roomID,
          );
        } else {
          debugger(when: kDebugMode);
          ErrorHandler.logError(m: "Null class settings state");
        }
        return roomID;
      },
      onError: (e) {
        debugger(when: kDebugMode);
        return e;
      },
    );

    if (roomID.error == null && roomID.result is String) {
      pangeaController.classController.setActiveSpaceIdInChatListController(
        roomID.result!,
      );
      context.push('/spaces/${roomID.result!}');
    } else {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: roomID.error, s: StackTrace.current);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NewSpaceView(this);
}

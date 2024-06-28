import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/controllers/language_list_controller.dart';
import 'package:fluffychat/pangea/enum/bar_chart_view_enum.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/widgets/common/list_placeholder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../../widgets/matrix.dart';
import '../../../controllers/pangea_controller.dart';
import '../../../utils/sync_status_util_v2.dart';
import '../base_analytics.dart';
import 'student_analytics_view.dart';

class StudentAnalyticsPage extends StatefulWidget {
  final BarChartViewSelection? selectedView;
  const StudentAnalyticsPage({super.key, this.selectedView});

  @override
  State<StudentAnalyticsPage> createState() => StudentAnalyticsController();
}

class StudentAnalyticsController extends State<StudentAnalyticsPage> {
  final PangeaController _pangeaController = MatrixState.pangeaController;
  AnalyticsSelected? selected;
  StreamSubscription? stateSub;

  @override
  void initState() {
    super.initState();

    final listFutures = [
      _pangeaController.myAnalytics.setStudentChats(),
      _pangeaController.myAnalytics.setStudentSpaces(),
    ];
    Future.wait(listFutures).then((_) => setState(() {}));

    stateSub = _pangeaController.myAnalytics.stateStream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    stateSub?.cancel();
    super.dispose();
  }

  List<Room> get chats {
    if (_pangeaController.myAnalytics.studentChats.isEmpty) {
      _pangeaController.myAnalytics.setStudentChats().then((_) {
        if (_pangeaController.myAnalytics.studentChats.isNotEmpty) {
          setState(() {});
        }
      });
    }
    return _pangeaController.myAnalytics.studentChats;
  }

  List<Room> get spaces {
    if (_pangeaController.myAnalytics.studentSpaces.isEmpty) {
      _pangeaController.myAnalytics.setStudentSpaces().then((_) {
        if (_pangeaController.myAnalytics.studentSpaces.isNotEmpty) {
          setState(() {});
        }
      });
    }
    return _pangeaController.myAnalytics.studentSpaces;
  }

  String? get userId {
    final id = _pangeaController.matrixState.client.userID;
    debugger(when: kDebugMode && id == null);
    return id;
  }

  List<LanguageModel> get targetLanguages {
    final LanguageModel? l2 =
        _pangeaController.languageController.activeL2Model();
    final List<LanguageModel> analyticsRoomLangs =
        _pangeaController.matrixState.client.allMyAnalyticsRooms
            .map((analyticsRoom) => analyticsRoom.madeForLang)
            .where((langCode) => langCode != null)
            .map((langCode) => PangeaLanguage.byLangCode(langCode!))
            .where(
              (langModel) => langModel.langCode != LanguageKeys.unknownLanguage,
            )
            .toList();
    if (l2 != null) {
      analyticsRoomLangs.add(l2);
    }
    return analyticsRoomLangs.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return PLoadingStatusV2(
      // if we everr want it rebuild the whole thing each time (and run initState again)
      // but this is computationally expensive!
      // key: UniqueKey(),
      shimmerChild: const ListPlaceholder(),
      // onFinish: initialize,
      child: StudentAnalyticsView(this),
    );
  }
}

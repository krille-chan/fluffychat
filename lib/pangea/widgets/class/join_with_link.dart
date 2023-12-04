import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/constants/url_query_parameter_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/utils/class_code.dart';
import 'package:fluffychat/widgets/layouts/empty_page.dart';
import '../../../widgets/matrix.dart';
import '../../constants/local.key.dart';
import '../../utils/error_handler.dart';

//if on home with classcode in url and not logged in, then save it soemhow and after llogin, join class automatically
//if on home with classcode in url and logged in, then join class automatically
class JoinClassWithLink extends StatefulWidget {
  const JoinClassWithLink({super.key});

  @override
  State<JoinClassWithLink> createState() => _JoinClassWithLinkState();
}

//PTODO - show class info in field so they know they're joining the right class
class _JoinClassWithLinkState extends State<JoinClassWithLink> {
  String? classCode;
  final PangeaController _pangeaController = MatrixState.pangeaController;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      classCode = GoRouterState.of(context)
          .uri
          .queryParameters[UrlQueryParameterKeys.classCode];

      if (classCode == null) {
        return ClassCodeUtil.messageDialog(
          context,
          L10n.of(context)!.unableToFindClassCode,
          () => context.go("/rooms"),
        );
      }

      if (!Matrix.of(context).client.isLogged()) {
        return ClassCodeUtil.messageDialog(
            context, L10n.of(context)!.pleaseLoginFirst, () async {
          await _pangeaController.pStoreService.save(
            PLocalKey.cachedClassCodeToJoin,
            classCode,
            addClientIdToKey: false,
          );
          context.go("/home");
        });
      }

      _pangeaController.classController
          .joinClasswithCode(
            context,
            classCode!,
          )
          .onError(
            (error, stackTrace) => ClassCodeUtil.messageSnack(
              context,
              ErrorCopy(context, error).body,
            ),
          )
          .whenComplete(
            () => context.go("/rooms"),
          );
    });
  }

  @override
  Widget build(BuildContext context) => const EmptyPage();
}

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/widgets/matrix.dart';

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
  final PangeaController pangeaController = MatrixState.pangeaController;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      classCode = GoRouterState.of(context)
          .uri
          .queryParameters[SpaceConstants.classCode];

      if (classCode == null) {
        Sentry.addBreadcrumb(
          Breadcrumb(
            message:
                "Navigated to join_with_link without class code query parameter",
          ),
        );
        return;
      }
      await MatrixState.pangeaController.classController.linkBox.write(
        PLocalKey.cachedClassCodeToJoin,
        classCode,
      );
      context.go("/home");
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

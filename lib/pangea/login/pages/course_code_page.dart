import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/login/pages/add_course_page.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseCodePage extends StatefulWidget {
  const CourseCodePage({
    super.key,
  });

  @override
  State<CourseCodePage> createState() => CourseCodePageState();
}

class CourseCodePageState extends State<CourseCodePage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String get _code => _codeController.text.trim();

  Future<void> _submit() async {
    if (_code.isEmpty) {
      return;
    }

    final roomId = await MatrixState.pangeaController.spaceCodeController
        .joinSpaceWithCode(
      context,
      _code,
    );

    if (roomId != null) {
      final room = Matrix.of(context).client.getRoomById(roomId);
      room?.isSpace ?? true
          ? context.go('/rooms/spaces/$roomId/details')
          : context.go('/rooms/$roomId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).joinWithCode),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            constraints: const BoxConstraints(
              maxWidth: 350,
              maxHeight: 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.network(
                  "${AppConfig.assetsBaseURL}/${AddCoursePage.mapUnlockFileName}",
                  width: 100.0,
                  height: 100.0,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
                Column(
                  spacing: 16.0,
                  children: [
                    Text(
                      L10n.of(context).enterCodeToJoin,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        hintText: L10n.of(context).courseCodeHint,
                      ),
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    ElevatedButton(
                      onPressed: _code.isNotEmpty ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(L10n.of(context).submit),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

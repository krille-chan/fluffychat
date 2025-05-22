import 'package:flutter/material.dart';

import 'package:fluffychat/widgets/matrix.dart';

class LevelDisplayName extends StatelessWidget {
  final String userId;
  final TextStyle? textStyle;
  final double? iconSize;

  const LevelDisplayName({
    required this.userId,
    this.textStyle,
    this.iconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 2.0,
      ),
      child: FutureBuilder(
        future: MatrixState.pangeaController.userController
            .getPublicProfile(userId),
        builder: (context, snapshot) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (!snapshot.hasData)
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: 12.0,
                    height: 12.0,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              else if (snapshot.hasError || snapshot.data == null)
                const SizedBox()
              else
                Row(
                  children: [
                    if (snapshot.data?.baseLanguage != null &&
                        snapshot.data?.targetLanguage != null)
                      Text(
                        snapshot.data!.baseLanguage!.langCodeShort
                            .toUpperCase(),
                        style: textStyle ??
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    if (snapshot.data?.baseLanguage != null &&
                        snapshot.data?.targetLanguage != null)
                      Icon(
                        Icons.chevron_right_outlined,
                        size: iconSize ?? 16.0,
                      ),
                    if (snapshot.data?.targetLanguage != null)
                      Text(
                        snapshot.data!.targetLanguage!.langCodeShort
                            .toUpperCase(),
                        style: textStyle ??
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    const SizedBox(width: 4.0),
                    if (snapshot.data?.level != null)
                      Text(
                        "⭐",
                        style: textStyle,
                      ),
                    if (snapshot.data?.level != null)
                      Text(
                        "${snapshot.data!.level!}",
                        style: textStyle ??
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

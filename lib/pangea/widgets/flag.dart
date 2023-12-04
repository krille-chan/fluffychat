import 'package:flutter/material.dart';

import 'package:fluffychat/widgets/avatar.dart';
import '../models/language_model.dart';

class LanguageFlag extends StatelessWidget {
  final LanguageModel? language;
  final double size;
  const LanguageFlag({
    Key? key,
    required this.language,
    this.size = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Avatar(
      name: language?.langCode,
      size: size,
    );

    //   return Center(
    //     child: Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(size / 2),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.grey.withOpacity(0.2),
    //             spreadRadius: 1,
    //             blurRadius: 15,
    //             offset: const Offset(0, 4), // changes position of shadow
    //           ),
    //         ],
    //       ),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(50),
    //         child: SizedBox(
    //           height: size,
    //           width: size,
    //           child: language?.languageFlag != null
    //               ? language!.languageFlag.contains("media/flags")
    //                   ? Image.network(language!.languageFlag)
    //                   : Image.asset(
    //                       language!.languageFlag,
    //                       width: size,
    //                       height: size,
    //                     )
    //               : const SizedBox.expand(),
    //         ),
    //       ),
    //     ),
    //   );
  }
}

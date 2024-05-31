import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:lottie/lottie.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'package:tawkie/utils/platform_size.dart';

class LinkedinConnectionExplain extends StatelessWidget {
  const LinkedinConnectionExplain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context)!.linkedinExplainTitle),
      ),
      body: Center(
        child: SizedBox(
          width: PlatformInfos.isWeb ? PlatformWidth.webWidth : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/js/lottie/system_update.json',
                  repeat: true,
                  reverse: false,
                  animate: true,
                  width: 250,
                  height: 250,
                ),
              ),
              Text(
                L10n.of(context)!.linkedinExplainInstruction,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                L10n.of(context)!.linkedinExplainOne,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

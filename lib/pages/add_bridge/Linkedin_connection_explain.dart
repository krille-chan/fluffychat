import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'package:tawkie/utils/platform_size.dart';

class LinkedinConnectionExplain extends StatelessWidget {
  const LinkedinConnectionExplain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context)!.linkedinExplain_title),
      ),
      body: Center(
        child: SizedBox(
          width: PlatformInfos.isWeb ? PlatformWidth.webWidth : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                L10n.of(context)!.linkedinExplain_instruction,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                L10n.of(context)!.linkedinExplain_one,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                L10n.of(context)!.linkedinExplain_two,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

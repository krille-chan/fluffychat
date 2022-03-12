import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';
import 'package:url_launcher/link.dart';

import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';

class HomeserverTile extends StatelessWidget {
  final HomeserverBenchmarkResult benchmark;
  final HomeserverPickerController controller;

  const HomeserverTile(
      {Key? key, required this.benchmark, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final domain = benchmark.homeserver.baseUrl.host;
    return ExpansionTile(
      leading: Radio(
          value: domain,
          groupValue: controller.domain,
          onChanged: controller.domain == domain
              ? (s) => controller.unsetDomain
              : controller.setDomain),
      onExpansionChanged: controller.domain == domain
          ? (o) => controller.unsetDomain()
          : (o) => controller.setDomain(domain),
      title: Text(benchmark.homeserver.baseUrl.host),
      subtitle: benchmark.homeserver.description != null
          ? Text(benchmark.homeserver.description!)
          : null,
      children: [
        benchmark.homeserver.antiFeatures != null &&
                benchmark.homeserver.antiFeatures!.isNotEmpty
            ? ListTile(
                leading: const Icon(Icons.thumb_down),
                title: Text(benchmark.homeserver.antiFeatures!),
                subtitle: Text(L10n.of(context)!.antiFeatures),
              )
            : ListTile(
                leading: const Icon(Icons.recommend),
                title: Text(L10n.of(context)!.noAntiFeaturesRecorded),
              ),
        if (benchmark.homeserver.jurisdiction != null)
          ListTile(
            leading: const Icon(Icons.public),
            title: Text(benchmark.homeserver.jurisdiction!),
            subtitle: Text(L10n.of(context)!.jurisdiction),
          ),
        ListTile(
          leading: const Icon(Icons.speed),
          title: Text("${benchmark.responseTime!.inMilliseconds} ms"),
          subtitle: Text(L10n.of(context)!.responseTime),
        ),
        ButtonBar(
          /* spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center, */
          children: [
            if (benchmark.homeserver.privacyPolicy != null)
              Link(
                uri: benchmark.homeserver.privacyPolicy!,
                target: LinkTarget.blank,
                builder: (context, callback) => TextButton(
                  onPressed: callback,
                  child: Text(L10n.of(context)!.privacy),
                ),
              ),
            if (benchmark.homeserver.rules != null)
              Link(
                uri: benchmark.homeserver.rules!,
                target: LinkTarget.blank,
                builder: (context, callback) => TextButton(
                  onPressed: callback,
                  child: Text(L10n.of(context)!.serverRules),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class CustomHomeserverTile extends StatelessWidget {
  final String domain;
  final VoidCallback onSelect;

  const CustomHomeserverTile(
      {Key? key, required this.domain, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(domain),
      subtitle: Text(L10n.of(context)!.customHomeserver),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: onSelect,
      ),
    );
  }
}

class JoinMatrixAttributionTile extends StatelessWidget {
  final parser = JoinmatrixOrgParser();

  JoinMatrixAttributionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(L10n.of(context)!.serverListJoinMatrix),
      subtitle: ButtonBar(children: [
        Link(
          uri: parser.externalUri,
          target: LinkTarget.blank,
          builder: (context, callback) => TextButton(
            onPressed: callback,
            child: Text(L10n.of(context)!.openServerList),
          ),
        ),
        Link(
          uri: parser.errorReportUrl,
          target: LinkTarget.blank,
          builder: (context, callback) => TextButton(
            onPressed: callback,
            child: Text(L10n.of(context)!.reportServerListProblem),
          ),
        ),
      ]),
    );
  }
}

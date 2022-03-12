import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';
import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/localized_exception_extension.dart';

class HomeserverPicker extends StatefulWidget {
  const HomeserverPicker({Key? key}) : super(key: key);

  @override
  HomeserverPickerController createState() => HomeserverPickerController();
}

class HomeserverPickerController extends State<HomeserverPicker> {
  bool isLoading = true;

  String? domain;
  List<HomeserverBenchmarkResult>? benchmarkResults;

  TextEditingController? homeserverController;

  StreamSubscription? _intentDataStreamSubscription;
  String? error;
  Timer? _coolDown;

  late HomeserverListProvider parser;

  bool customHomeserverLoading = false;

  bool get foundCustomHomeserver => benchmarkResults!
      .where((element) => element.homeserver.baseUrl.host == searchTerm)
      .isEmpty;

  String? searchTerm;

  List<HomeserverBenchmarkResult> get filteredHomeservers =>
      searchTerm == null || searchTerm!.isEmpty
          ? benchmarkResults!
          : benchmarkResults!
              .where((element) =>
                  element.homeserver.baseUrl.host.contains(searchTerm!) ||
                  (element.homeserver.description?.contains(searchTerm!) ??
                      false))
              .toList();

  get homeserverCount =>
      filteredHomeservers.length +
      ((customHomeserverLoading || foundCustomHomeserver) ? 1 : 0);

  @override
  void initState() {
    super.initState();
    benchmarkHomeServers();
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription?.cancel();
  }

  void signUpAction() => VRouter.of(context).to(
        'connect',
        queryParameters: {'domain': domain!},
      );

  @override
  Widget build(BuildContext context) {
    Matrix.of(context).navigatorContext = context;
    return HomeserverPickerView(this);
  }

  Future<void> benchmarkHomeServers() async {
    try {
      parser = JoinmatrixOrgParser();
      final homeserverList = await parser.fetchHomeservers();
      final benchmark = await HomeserverListProvider.benchmarkHomeserver(
        homeserverList,
        timeout: const Duration(seconds: 10),
        // TODO: do not rely on the homeserver list information telling the server supports registration
      );

      if (benchmark.isEmpty) {
        throw NullThrownError();
      }

      // trying to use server without anti-features
      final goodServers = <HomeserverBenchmarkResult>[];
      final badServers = <HomeserverBenchmarkResult>[];
      for (final result in benchmark) {
        if (result.homeserver.antiFeatures == null) {
          goodServers.add(result);
        } else {
          badServers.add(result);
        }
      }

      goodServers.sort();
      badServers.sort();

      benchmarkResults = List.from([...goodServers, ...badServers]);
      bool foundRegistrationSupported = false;
      domain = benchmarkResults!.first.homeserver.baseUrl.host;
      int counter = 0;
      // iterating up to first homeserver supporting registration
      while (foundRegistrationSupported == false) {
        try {
          var homeserver = domain;

          if (!homeserver!.startsWith('https://')) {
            homeserver = 'https://$homeserver';
          }
          final loginClient = Matrix.of(context).getLoginClient();
          await loginClient.checkHomeserver(homeserver);
          await loginClient.register();
          foundRegistrationSupported = true;
        } on MatrixException catch (e) {
          if (e.requireAdditionalAuthentication) {
            foundRegistrationSupported = true;
          } else {
            Logs().d(e.toString());
            foundRegistrationSupported = false;
            counter++;
            domain = benchmarkResults![counter].homeserver.baseUrl.host;
          }
        }
        setState(() {
          isLoading = false;
        });
      }
    } on Exception catch (e, s) {
      Logs().e('Homeserver benchmark failed', e, s);
      domain = AppConfig.defaultHomeserver;
    } finally {
      homeserverController = TextEditingController();
    }
  }

  Future<void> setHomeserver(String homeserver) async {
    domain = homeserver;
    signUpAction();
  }

  Future<void> checkHomeserverAction(String homeserver) async {
    setState(() {
      error = null;
      customHomeserverLoading = true;
    });

    try {
      await Matrix.of(context).getLoginClient().checkHomeserver(homeserver);
      setState(() {
        domain = homeserver;
      });
    } catch (e) {
      setState(() => error = (e).toLocalizedString(context));
    } finally {
      if (mounted) {
        customHomeserverLoading = false;
        setState(() => isLoading = false);
      }
    }
  }

  void searchHomeserver(String searchTerm) {
    setState(() {
      searchTerm = searchTerm;

      error = null;
    });

    if (searchTerm.length >= 3) {
      var homeserver = searchTerm;
      if (!homeserver.startsWith('https://')) {
        homeserver = 'https://$homeserver';
      }
      if (Uri.tryParse(homeserver) != null) {
        _coolDown?.cancel();
        _coolDown = Timer(
          const Duration(milliseconds: 500),
          () => checkHomeserverAction(homeserver),
        );
      } else {
        setState(() {
          customHomeserverLoading = false;
        });
      }
    } else {
      setState(() {
        customHomeserverLoading = false;
      });
    }
  }

  void setDomain(String? domain) => setState(() => this.domain = domain);

  void unsetDomain() => setState(() => domain = null);
}

class IdentityProvider {
  final String? id;
  final String? name;
  final String? icon;
  final String? brand;

  IdentityProvider({this.id, this.name, this.icon, this.brand});

  factory IdentityProvider.fromJson(Map<String, dynamic> json) =>
      IdentityProvider(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        brand: json['brand'],
      );
}

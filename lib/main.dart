import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/error_widget.dart';
import 'config/setting_keys.dart';
import 'utils/background_push.dart';
import 'widgets/fluffy_chat_app.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


void main() async {
  Logs().i('Welcome to ${AppConfig.applicationName} <3');

  WidgetsFlutterBinding.ensureInitialized();

  Logs().nativeColors = !PlatformInfos.isIOS;
  final store = await SharedPreferences.getInstance();
  final clients = await ClientManager.getClients(store: store);

  if (PlatformInfos.isAndroid &&
      AppLifecycleState.detached == WidgetsBinding.instance.lifecycleState) {
    for (final client in clients) {
      client.backgroundSync = false;
      client.syncPresence = PresenceType.offline;
    }

    BackgroundPush.clientOnly(clients.first);
    WidgetsBinding.instance.addObserver(AppStarter(clients, store));
    Logs().i(
      '${AppConfig.applicationName} started in background-fetch mode. No GUI will be created unless the app is no longer detached.',
    );
    return;
  }

  Logs().i(
    '${AppConfig.applicationName} started in foreground mode. Rendering GUI...',
  );
  runApp(MyApp(clients: clients, store: store));
}

class MyApp extends StatelessWidget {
  final List<Client> clients;
  final SharedPreferences store;

  MyApp({required this.clients, required this.store});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.applicationName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WizardPage(clients: clients, store: store),
    );
  }
}

class WizardPage extends StatefulWidget {
  final List<Client> clients;
  final SharedPreferences store;

  WizardPage({required this.clients, required this.store});

  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppConfig.applicationName} '),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                getWizardStep(0),
                getWizardStep(1),
                getWizardStep(2),
                getWizardStep(3),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: 4,
            effect: WormEffect(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Back'),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentStep < 3) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingPage(
                              clients: widget.clients, store: widget.store),
                        ),
                      );
                    }
                  },
                  child: Text(_currentStep < 3 ? 'Next' : 'Vamos lá'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getWizardStep(int step) {
    switch (step) {
      case 0:
        return buildStep(
          'assets/salas_transparent.png',
          'Bem-vindo ao Salas, o lugar perfeito para se conectar de forma fácil com seu ecossistema.',
        );
      case 1:
        return buildStep(
          'assets/chat.png',
          'Na Salas, você pode gerenciar todos os seus assuntos e arquivos de maneira simples e eficiente.',
        );
      case 2:
        return buildStep(
          'assets/password.png',
          'No Salas, você desfruta de uma conexão rápida e segura.',
        );
      case 3:
        return buildStep(
          'assets/dance.png',
          'Aproveite para criar suas salas e convidar sua turma a se juntar a você.',
          isLastStep: true,
        );
      default:
        return Container();
    }
  }

  Widget buildStep(String imagePath, String text, {bool isLastStep = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 250, fit: BoxFit.cover),
        SizedBox(height: 20),
        Center(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child:Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )
        ),
        if (isLastStep)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoadingPage(
                        clients: widget.clients, store: widget.store),
                  ),
                );
              },
              child: Text('Vamos lá'),
            ),
          ),
      ],
    );
  }
}

class LoadingPage extends StatelessWidget {
  final List<Client> clients;
  final SharedPreferences store;

  LoadingPage({required this.clients, required this.store});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: startGui(clients, store),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FluffyChatApp(
              clients: clients, pincode: snapshot.data, store: store);
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

Future<String?> startGui(List<Client> clients, SharedPreferences store) async {
  String? pin;
  if (PlatformInfos.isMobile) {
    try {
      pin = await const FlutterSecureStorage().read(key: SettingKeys.appLockKey);
    } catch (e, s) {
      Logs().d('Unable to read PIN from Secure storage', e, s);
    }
  }

  final firstClient = clients.firstOrNull;
  await firstClient?.roomsLoading;
  await firstClient?.accountDataLoading;

  ErrorWidget.builder = (details) => FluffyChatErrorWidget(details);
  return pin;
}

class AppStarter with WidgetsBindingObserver {
  final List<Client> clients;
  final SharedPreferences store;
  bool guiStarted = false;

  AppStarter(this.clients, this.store);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (guiStarted) return;
    if (state == AppLifecycleState.detached) return;

    Logs().i(
      '${AppConfig.applicationName} switches from the detached background-fetch mode to ${state.name} mode. Rendering GUI...',
    );
    for (final client in clients) {
      client.backgroundSync = true;
      client.syncPresence = PresenceType.online;
    }
    startGui(clients, store);
    guiStarted = true;
  }
}

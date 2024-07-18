import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tawkie/pages/add_bridge/add_bridge.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';

class QRCodeConnectPage extends StatefulWidget {
  final String qrCode;
  final String code;
  final BotController botConnection;
  final SocialNetwork socialNetwork;

  const QRCodeConnectPage({
    super.key,
    required this.qrCode,
    required this.code,
    required this.botConnection,
    required this.socialNetwork,
  });

  @override
  State<QRCodeConnectPage> createState() => _QRCodeConnectPageState();
}

class _QRCodeConnectPageState extends State<QRCodeConnectPage> {
  late Future<String> responseFuture;

  @override
  void initState() {
    super.initState();

    widget.botConnection.continueProcess = true;

    responseFuture = widget.botConnection.fetchDataWhatsApp();
  }

  @override
  void dispose() {
    widget.botConnection.stopProcess();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${L10n.of(context)!.connectYourSocialAccount} ${widget.socialNetwork.name}",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QRExplanation(
                network: widget.socialNetwork,
                qrCode: widget.qrCode,
                code: widget.code,
              ),
              const SizedBox(height: 16),
              QRFutureBuilder(
                responseFuture: responseFuture,
                network: widget.socialNetwork,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Connection explanation section
class QRExplanation extends StatelessWidget {
  final SocialNetwork network;
  final String qrCode;
  final String code;

  const QRExplanation({
    super.key,
    required this.network,
    required this.qrCode,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    Widget qrWidget;

    String qrExplainOne = "";
    String qrExplainTwo = "";
    String qrExplainThree = "";
    String qrExplainFour = "";
    String qrExplainFive = "";
    String qrExplainSix = "";
    String qrExplainSeven = "";
    String qrExplainEight = "";
    String qrExplainNine = "";

    switch (network.name) {
      case "WhatsApp":
        qrExplainOne = L10n.of(context)!.whatsAppQrExplainOne;
        qrExplainTwo = L10n.of(context)!.whatsAppQrExplainTwo;
        qrExplainThree = L10n.of(context)!.whatsAppQrExplainTree;
        qrExplainFour = L10n.of(context)!.whatsAppQrExplainFour;
        qrExplainFive = L10n.of(context)!.whatsAppQrExplainFive;
        qrExplainSix = L10n.of(context)!.whatsAppQrExplainSix;
        qrExplainSeven = L10n.of(context)!.whatsAppQrExplainSeven;
        qrExplainEight = L10n.of(context)!.whatsAppQrExplainEight;
        qrExplainNine = L10n.of(context)!.whatsAppQrExplainNine;

        qrWidget = QrImageView(
          data: qrCode,
          version: QrVersions.auto,
          size: 300,
        );
        break;
      default:
        qrWidget = QrImageView(
          data: qrCode,
          version: QrVersions.auto,
          size: 300,
        );
        break;
    }

    return Column(
      children: [
        Text(
          qrExplainOne,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          qrExplainTwo,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          qrExplainThree,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          qrExplainFour,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          qrExplainFive,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code));
            final SnackBar snackBar =
                SnackBar(content: Text(L10n.of(context)!.codeCopy));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              code,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: null,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(
          color: Colors.grey,
          height: 20,
        ),
        Text(
          qrExplainSix,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              qrExplainSeven,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              qrExplainEight,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          qrExplainNine,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        qrWidget,
      ],
    );
  }
}

// FutureBuilder part listening to responses in real time
class QRFutureBuilder extends StatelessWidget {
  final Future<String> responseFuture;
  final SocialNetwork network;

  const QRFutureBuilder({
    super.key,
    required this.responseFuture,
    required this.network,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: responseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return Text('${L10n.of(context)!.err_} ${snapshot.error}');
        } else {
          return buildAlertDialog(context, snapshot.data as String, network);
        }
      },
    );
  }

  // AlertDialog displayed when an error or success occurs, listening directly to the response
  Widget buildAlertDialog(
      BuildContext context, String result, SocialNetwork network) {
    if (result == "success") {
      Future.microtask(() {
        // Call function to display success dialog box
        showSuccessDialog(context, network);
      });
    } else if (result == "loginTimedOut") {
      Future.microtask(() {
        // Call the function to display the "Elapsed time" dialog box
        showTimeoutDialog(context, network);
      });
    }

    return Container();
  }

  // showDialog of a success message when connecting and updating socialNetwork
  Future<void> showSuccessDialog(
      BuildContext context, SocialNetwork network) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            L10n.of(context)!.wellDone,
          ),
          content: Text(
            L10n.of(context)!.whatsAppConnectedText,
          ),
          actions: [
            TextButton(
              onPressed: () {
                // SocialNetwork network update
                SocialNetworkManager.socialNetworks
                    .firstWhere((element) => element.name == network.name)
                    .connected = true;

                Navigator.of(context).pop();
              },
              child: Text(
                L10n.of(context)!.ok,
              ),
            ),
          ],
        );
      },
    );
  }

  // showDialog of elapsed time error message
  Future<void> showTimeoutDialog(
      BuildContext context, SocialNetwork network) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            L10n.of(context)!.errElapsedTime,
          ),
          content: Text(
            L10n.of(context)!.errExpiredSession,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                L10n.of(context)!.ok,
              ),
            ),
          ],
        );
      },
    );
  }
}

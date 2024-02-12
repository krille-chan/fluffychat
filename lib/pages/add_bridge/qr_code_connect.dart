import 'package:tawkie/pages/add_bridge/model/social_network.dart';
import 'package:tawkie/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class QRCodeConnectPage extends StatefulWidget {
  final String qrCode;
  final String code;
  final BotBridgeConnection botConnection;

  const QRCodeConnectPage({
    super.key,
    required this.qrCode,
    required this.code,
    required this.botConnection,
  });

  @override
  State<QRCodeConnectPage> createState() => _QRCodeConnectPageState();
}

class _QRCodeConnectPageState extends State<QRCodeConnectPage> {
  late Future<String> responseFuture;

  @override
  void initState() {
    super.initState();

    // To make sure the continueProcess variable is true
    // (in case you've already left the page before coming back)
    widget.botConnection.continueProcess = true;

    responseFuture = widget.botConnection.fetchDataWhatsApp();
  }

  @override
  void dispose() {
    // To stop listening to received messages if the page is exited
    widget.botConnection.stopProcess();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.whatsApp_qrTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WhatsAppQRExplanation(
                qrCode: widget.qrCode,
                code: widget.code,
              ),
              const SizedBox(height: 16),
              WhatsAppQRFutureBuilder(
                responseFuture: responseFuture,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Connection explanation section
class WhatsAppQRExplanation extends StatelessWidget {
  final String qrCode;
  final String code;
  const WhatsAppQRExplanation(
      {super.key, required this.qrCode, required this.code});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          L10n.of(context)!.whatsApp_qrExplainOne,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          L10n.of(context)!.whatsApp_qrExplainTwo,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          L10n.of(context)!.whatsApp_qrExplainTree,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          L10n.of(context)!.whatsApp_qrExplainFour,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          L10n.of(context)!.whatsApp_qrExplainFive,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code));

            final SnackBar snackBar = SnackBar(
                content: Text(
              L10n.of(context)!.codeCopy,
            ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              code,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
          L10n.of(context)!.whatsApp_qrExplainSix,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(L10n.of(context)!.whatsApp_qrExplainSeven,
                style: const TextStyle(
                  fontSize: 16,
                )),
            Text(
              L10n.of(context)!.whatsApp_qrExplainEight,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          L10n.of(context)!.whatsApp_qrExplainTen,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        QrImageView(
          data: qrCode,
          version: QrVersions.auto,
          size: 300,
        ),
      ],
    );
  }
}

// FutureBuilder part listening to responses in real time
class WhatsAppQRFutureBuilder extends StatelessWidget {
  final Future<String> responseFuture;

  const WhatsAppQRFutureBuilder({
    super.key,
    required this.responseFuture,
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
          return buildAlertDialog(context, snapshot.data as String);
        }
      },
    );
  }

// AlertDialog displayed when an error or success occurs, listening directly to the response
  Widget buildAlertDialog(BuildContext context, String result) {
    if (result == "success") {
      Future.microtask(() {
        // Call function to display success dialog box
        showSuccessDialog(context);
      });
    } else if (result == "loginTimedOut") {
      Future.microtask(() {
        // Call the function to display the "Elapsed time" dialog box
        showTimeoutDialog(context);
      });
    }

    return Container();
  }

// showDialog of a success message when connecting and updating socialNetwork
  Future<void> showSuccessDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            L10n.of(context)!.wellDone,
          ),
          content: Text(
            L10n.of(context)!.whatsApp_connectedText,
          ),
          actions: [
            TextButton(
              onPressed: () {
                // SocialNetwork network update
                socialNetwork
                    .firstWhere((element) => element.name == "WhatsApp")
                    .connected = true;

                Navigator.of(context).pop();
                // Goes back twice (closes current and previous pages)
                Navigator.pop(context, true);
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
  Future<void> showTimeoutDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            L10n.of(context)!.err_elapsedTime,
          ),
          content: Text(
            L10n.of(context)!.err_expiredSession,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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

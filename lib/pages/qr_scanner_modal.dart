import 'dart:async';
import 'dart:io';

import 'package:fluffychat/utils/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class QrScannerModal extends StatefulWidget {
  const QrScannerModal({Key key}) : super(key: key);

  @override
  _QrScannerModalState createState() => _QrScannerModalState();
}

class _QrScannerModalState extends State<QrScannerModal> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: Navigator.of(context).pop,
          tooltip: L10n.of(context).close,
        ),
        title: Text(L10n.of(context).scanQrCode),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Theme.of(context).primaryColor,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 8,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    StreamSubscription sub;
    sub = controller.scannedDataStream.listen((scanData) {
      sub.cancel();
      Navigator.of(context).pop();
      UrlLauncher(context, scanData.code).openMatrixToUrl();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

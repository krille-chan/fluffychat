import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'package:url_launcher/url_launcher.dart';

class BetaJoinPage extends StatelessWidget {
  const BetaJoinPage({super.key});

  Future<bool> _launchUrl(String url, BuildContext context) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching URL: $e');
      }
      final snackBar = SnackBar(content: Text(L10n.of(context)!.tryAgain));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (kDebugMode) {
        print('Error launching Apple Beta URL: $e');
      }
    }
    return false;
  }

  Future<void> joinGroup({
    required BuildContext context,
  }) async {
    final client = Matrix.of(context).client;
    const String roomAlias = AppConfig.roomAlias;

    try {
      if (kDebugMode) {
        print('Attempting to join room: $roomAlias');
      }

      // Get room ID from alias
      final roomAliasResult = await client.getRoomIdByAlias(roomAlias);
      final roomId = roomAliasResult.roomId;

      if (roomId == null) {
        final errorMsg = L10n.of(context)!.failedToJoinRoom +
            L10n.of(context)!.roomIdNullError +
            roomAlias;
        if (kDebugMode) {
          print(errorMsg);
        }
        throw Exception(errorMsg);
      }

      // Check if the user is already a member of the room
      final room = client.getRoomById(roomId);
      if (room != null && room.membership == Membership.join) {
        // Navigate directly to the room
        context.go('/rooms/$roomId');
        return;
      }

      final result = await showFutureLoadingDialog<String>(
        context: context,
        future: () async {
          try {
            final waitForRoom = client.waitForRoomInSync(roomId, join: true);

            await client.joinRoom(roomId);
            await waitForRoom;

            return roomId;
          } catch (e) {
            final errorMsg = L10n.of(context)!.failedToJoinRoom + e.toString();
            if (kDebugMode) {
              print(errorMsg);
            }
            throw Exception(errorMsg);
          }
        },
      );

      if (result.error == null) {
        Navigator.of(context).pop();

        final joinedRoom = client.getRoomById(result.result!);
        if (joinedRoom == null) {
          final errorMsg = L10n.of(context)!.failedToJoinRoom +
              L10n.of(context)!.roomNotFoundError;
          if (kDebugMode) {
            print(errorMsg);
          }
          throw Exception(errorMsg);
        }

        // Navigate to the room
        context.go('/rooms/${result.result!}');
      } else {
        final errorMsg =
            L10n.of(context)!.failedToJoinRoom + result.error.toString();
        if (kDebugMode) {
          print(errorMsg);
        }
        final snackBar = SnackBar(content: Text(errorMsg));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final errorMsg = L10n.of(context)!.joinBetaError + e.toString();
      if (kDebugMode) {
        print(errorMsg);
      }
      final snackBar = SnackBar(content: Text(errorMsg));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.joinBetaTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              L10n.of(context)!.betaJoinExplanation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text(
              L10n.of(context)!.betaJoinBenefit,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20.0),
            if (Platform.isIOS) _buildIOSInstructions(context),
            if (Platform.isAndroid) _buildAndroidInstructions(context),
            const SizedBox(height: 10.0),
            ElevatedButton.icon(
              onPressed: () async {
                await joinGroup(context: context);
              },
              icon: const Icon(Icons.new_releases),
              label: Text(L10n.of(context)!.joinBetaButtonLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIOSInstructions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.of(context)!.iosInstructionsTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          L10n.of(context)!.installTestflight,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () async {
            await _launchUrl(AppConfig.testflightAppUrl, context);
          },
          child: Text(L10n.of(context)!.downloadTestflightButton),
        ),
        const Divider(thickness: 1),
        Text(
          L10n.of(context)!.joinBetaTitle,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () async {
            await _launchUrl(AppConfig.appleBetaUrl, context);
          },
          child: Text(L10n.of(context)!.downloadBetaIOSButton),
        ),
        const Divider(thickness: 1),
        Text(
          L10n.of(context)!.joinBetaGroup,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAndroidInstructions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.of(context)!.androidInstructionsTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          L10n.of(context)!.joinBetaPlayStore,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () async {
            bool success = await _launchUrl(AppConfig.playStoreUrl, context);
            if (!success) {
              await _launchUrl(AppConfig.androidBetaUrl, context);
            }
          },
          child: Text(L10n.of(context)!.downloadBetaAndroidButton),
        ),
        const Divider(thickness: 1),
        Text(
          L10n.of(context)!.joinBetaGroup,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

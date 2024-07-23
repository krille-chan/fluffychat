import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/widgets/matrix.dart';

import 'android_instructions.dart';
import 'ios_instructions.dart';

class BetaJoinPage extends StatelessWidget {
  const BetaJoinPage({super.key});

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
            if (Platform.isIOS) const IOSInstructions(),
            if (Platform.isAndroid) const AndroidInstructions(),
            const Divider(thickness: 1),
            Text(
              L10n.of(context)!.joinBetaGroup,
              style: const TextStyle(fontSize: 16),
            ),
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
}

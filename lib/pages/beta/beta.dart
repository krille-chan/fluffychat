import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/matrix_api_lite.dart' as MatrixLite;
import 'package:tawkie/widgets/matrix.dart';
import 'package:url_launcher/url_launcher.dart';

class BetaJoinPage extends StatelessWidget {
  // URLs
  final String testflightAppUrl =
      'https://apps.apple.com/us/app/testflight/id899247664';
  final String appleBetaUrl = 'https://testflight.apple.com/join/daXe0NfW';
  final String playStoreUrl =
      'https://play.google.com/store/apps/details?id=fr.tawkie.app';
  final String androidBetaUrl =
      'https://play.google.com/apps/testing/fr.tawkie.app';

  const BetaJoinPage({super.key});

  void joinBeta() async {
    if (Platform.isIOS) {
      final String appStoreUrl =
          'itms-apps://itunes.apple.com/app/id899247664'; // Direct link to the TestFlight app
      if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
        await launchUrl(Uri.parse(appStoreUrl));
      } else if (await canLaunchUrl(Uri.parse(appleBetaUrl))) {
        await launchUrl(Uri.parse(appleBetaUrl));
      } else {
        throw 'Could not launch $appleBetaUrl';
      }
    } else if (Platform.isAndroid) {
      final String playStoreUrl =
          'market://details?id=fr.tawkie.app'; // Direct link to the Play Store app
      if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
        await launchUrl(Uri.parse(playStoreUrl));
      } else if (await canLaunchUrl(Uri.parse(androidBetaUrl))) {
        await launchUrl(Uri.parse(androidBetaUrl));
      } else {
        throw 'Could not launch $androidBetaUrl';
      }
    }
  }

  Future<void> createAndJoinRoom({
    required BuildContext context,
  }) async {
    final client = Matrix.of(context).client;
    final String roomAliasName = 'testTree'; // L'alias local de la room
    final String roomAlias = '#$roomAliasName:staging.tawkie.fr';

    try {
      final createRoomResult = await showFutureLoadingDialog<String>(
        context: context,
        future: () async {
          try {
            print('Creating room'); // Log pour diagnostiquer

            // Créer la room
            final roomId = await client.createRoom(
              name: 'testTree Room',
              topic: 'Room for testTree',
              visibility: MatrixLite.Visibility.public,
              roomAliasName: roomAliasName,
              preset: CreateRoomPreset.publicChat,
              // Utiliser le preset pour les rooms publiques
              initialState: [
                StateEvent(
                  type: 'm.room.join_rules',
                  stateKey: '',
                  content: {
                    'join_rule': 'public',
                  },
                ),
                StateEvent(
                  type: 'm.room.history_visibility',
                  stateKey: '',
                  content: {
                    'history_visibility': 'shared',
                  },
                ),
              ],
            );

            if (roomId == null) {
              print('Failed to create room');
              throw Exception('Failed to create room');
            }

            print('Room created with ID: $roomId');
            return roomId;
          } catch (e) {
            // Gérer les exceptions pendant la création de la room
            print('Error creating room: $e'); // Log pour diagnostiquer
            throw Exception('Failed to create room: $e');
          }
        },
      );

      if (createRoomResult.error == null) {
        final roomId = createRoomResult.result!;
        print('Room created successfully: $roomId');

        final joinResult = await showFutureLoadingDialog<String>(
          context: context,
          future: () async {
            try {
              print(
                  'Attempting to join room: $roomAlias'); // Log pour diagnostiquer

              // Obtenir l'ID de la room à partir de l'alias
              final id = await client.getRoomIdByAlias(roomAlias);
              if (id == null) {
                print('Room ID is null');
                throw Exception('Failed to get room ID for alias: $roomAlias');
              }
              print('Room ID: ${id.roomId}');

              final waitForRoom = client.waitForRoomInSync(
                id.roomId!,
                join: true,
              );

              await client
                  .joinRoom(id.roomId!, serverName: ['staging.tawkie.fr']);
              await waitForRoom;

              return id.roomId!; // Retourner l'ID de la room
            } catch (e) {
              // Gérer les exceptions pendant la tentative de rejoindre la room
              print('Error joining room: $e'); // Log pour diagnostiquer
              throw Exception('Failed to join room: $e');
            }
          },
        );

        if (joinResult.error == null) {
          // Fermer la boîte de dialogue
          Navigator.of(context).pop();

          final joinedRoom = client.getRoomById(joinResult.result!);
          if (joinedRoom == null) {
            print('Room not found after joining');
            throw Exception('Room not found after joining');
          }

          // Vérifier si la room est un espace et naviguer vers la room si ce n'est pas le cas
          if (!joinedRoom.isSpace) {
            context.go('/rooms/${joinResult.result!}');
          }
        } else {
          // Gérer l'erreur si l'adhésion à la room échoue
          print(
              'Failed to join room: ${joinResult.error}'); // Log pour diagnostiquer
          final snackBar = SnackBar(
              content: Text('Failed to join room: ${joinResult.error}'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        print(
            'Failed to create room: ${createRoomResult.error}'); // Log pour diagnostiquer
        final snackBar = SnackBar(
            content: Text('Failed to create room: ${createRoomResult.error}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      // Afficher un message d'erreur général si une exception est levée
      print('Something went wrong: $e'); // Log pour diagnostiquer
      final snackBar = SnackBar(content: Text('Something went wrong: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> joinGroup({
    required BuildContext context,
  }) async {
    final client = Matrix.of(context).client;
    final String roomAlias = '#testTree:staging.tawkie.fr';
    final List<String> serverName = [
      'staging.tawkie.fr'
    ]; // Liste des serveurs à contacter

    try {
      final result = await showFutureLoadingDialog<String>(
        context: context,
        future: () async {
          try {
            print(
                'Attempting to join room: $roomAlias'); // Log pour diagnostiquer

            // Obtenir l'ID de la room à partir de l'alias
            final roomAliasResult = await client.getRoomIdByAlias(roomAlias);

            final roomId = roomAliasResult.roomId;
            if (roomId == null) {
              print('Room ID is null');
              throw Exception('Room ID is null for alias: $roomAlias');
            }

            final joinResult = await showFutureLoadingDialog<String>(
              context: context,
              future: () async {
                try {
                  print(
                      'Attempting to join room: $roomAlias'); // Log pour diagnostiquer

                  client.clearArchivesFromCache();

                  // Obtenir l'ID de la room à partir de l'alias
                  final id = await client.getRoomIdByAlias(roomAlias);
                  if (id == null) {
                    print('Room ID is null');
                    throw Exception(
                        'Failed to get room ID for alias: $roomAlias');
                  }
                  print('Room ID: ${id.roomId}');

                  await client
                      .joinRoom(id.roomId!, serverName: ['staging.tawkie.fr']);

                  return id.roomId!; // Retourner l'ID de la room
                } catch (e) {
                  // Gérer les exceptions pendant la tentative de rejoindre la room
                  print('Error joining room: $e'); // Log pour diagnostiquer
                  throw Exception('Failed to join room: $e');
                }
              },
            );

            if (joinResult.error == null) {
              // Fermer la boîte de dialogue
              Navigator.of(context).pop();

              final joinedRoom = client.getRoomById(joinResult.result!);
              if (joinedRoom == null) {
                print('Room not found after joining');
                throw Exception('Room not found after joining');
              }

              // Vérifier si la room est un espace et naviguer vers la room si ce n'est pas le cas
              if (!joinedRoom.isSpace) {
                context.go('/rooms/${joinResult.result!}');
              }
            }

            return roomId; // Retourner l'ID de la room
          } catch (e) {
            // Gérer les exceptions pendant la tentative de rejoindre la room
            print('Error joining room: $e'); // Log pour diagnostiquer
            throw Exception('Failed to join room: $e');
          }
        },
      );

      if (result.error == null) {
        // Fermer la boîte de dialogue
        Navigator.of(context).pop();

        final room = client.getRoomById(result.result!);
        if (room == null) {
          print('Room not found after joining');
          throw Exception('Room not found after joining');
        }

        // Vérifier si la room est un espace et naviguer vers la room si ce n'est pas le cas
        if (!room.isSpace) {
          context.go('/rooms/${result.result!}');
        }
      } else {
        // Gérer l'erreur si l'adhésion à la room échoue
        print('Failed to join room: ${result.error}'); // Log pour diagnostiquer
        final snackBar =
            SnackBar(content: Text('Failed to join room: ${result.error}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      // Afficher un message d'erreur général si une exception est levée
      print('Something went wrong: $e'); // Log pour diagnostiquer
      final snackBar = SnackBar(content: Text('Something went wrong: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rejoindre la Bêta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              '## Comment tester la version Beta et accéder aux nouvelles fonctionnalités en avance ?\n',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Participer à la Beta permet d\'avoir accès aux mises à jour de l\'application en avance et tester en premier.ère les nouvelles fonctionnalités !\n',
              style: TextStyle(fontSize: 16),
            ),
            if (Platform.isIOS) ...[
              Text(
                'Sous iOS :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '- Installer Apple Testflight',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(testflightAppUrl))) {
                    await launchUrl(Uri.parse(testflightAppUrl));
                  } else {
                    throw 'Could not launch $testflightAppUrl';
                  }
                },
                child: Text('Télécharger Apple Testflight'),
              ),
              Divider(thickness: 1),
              Text(
                '- Rejoindre la Beta',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(appleBetaUrl))) {
                    await launchUrl(Uri.parse(appleBetaUrl));
                  } else {
                    throw 'Could not launch $appleBetaUrl';
                  }
                },
                child: Text('Télécharger la Beta iOS'),
              ),
              Divider(thickness: 1),
              Text(
                '- Rejoindre le groupe Tawkie de la Beta : #beta:alpha.tawkie.fr\n',
                style: TextStyle(fontSize: 16),
              ),
            ],
            if (Platform.isAndroid) ...[
              Text(
                'Sous Android :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '- Rejoindre la Beta depuis le Play Store ou en ligne',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () async {
                  final String playStoreUrl =
                      'market://details?id=fr.tawkie.app';
                  if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
                    await launchUrl(Uri.parse(playStoreUrl));
                  } else if (await canLaunchUrl(Uri.parse(androidBetaUrl))) {
                    await launchUrl(Uri.parse(androidBetaUrl));
                  } else {
                    throw 'Could not launch $androidBetaUrl';
                  }
                },
                child: Text('Télécharger la Beta Android'),
              ),
              Divider(thickness: 1),
              Text(
                '- Rejoindre le groupe Tawkie de la Beta : #beta:alpha.tawkie.fr\n',
                style: TextStyle(fontSize: 16),
              ),
            ],
            ElevatedButton.icon(
              onPressed: () async {
                //await createAndJoinRoom(context: context);
                await joinGroup(context: context);
              },
              icon: Icon(Icons.new_releases),
              label: Text('Rejoindre le groupe Beta'),
            ),
          ],
        ),
      ),
    );
  }
}

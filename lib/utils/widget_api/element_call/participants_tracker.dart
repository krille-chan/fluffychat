// ignore_for_file: require_trailing_commas

import 'dart:async';

import 'package:matrix/matrix.dart';

/// Track Element Call participants
class ParticipantsTracker {
  ParticipantsTracker(this.room) {
    Logs().i('[WidgetAPI.ParticipantsTracker] constructor: roomId=${room.id}');
    _sub = room.client.onSync.stream
        .where((sync) => sync.rooms?.join?[room.id] != null)
        .listen((_) {
      Logs().v('[WidgetAPI.ParticipantsTracker] onSync: updating participants');
      _updateParticipants();
    });
    _updateParticipants();
  }

  final Room room;
  StreamSubscription? _sub;

  final _participantsController = StreamController<List<User>>.broadcast();

  /// Stream of participants
  Stream<List<User>> get participants => _participantsController.stream;

  List<User> _currentParticipants = [];

  /// Get current participants
  List<User> get currentParticipants => List.unmodifiable(_currentParticipants);

  void _updateParticipants() {
    Logs().v('[WidgetAPI.ParticipantsTracker] _updateParticipants: updating');
    final participants = <User>[];

    // Get all call.member state events
    final callMembers = room.states['org.matrix.msc3401.call.member'];

    if (callMembers != null) {
      Logs().v(
          '[WidgetAPI.ParticipantsTracker] _updateParticipants: found ${callMembers.length} call.member states');
      for (final event in callMembers.values) {
        // Check if member is active in call
        final devices = event.content['devices'] as List?;
        if (devices != null && devices.isNotEmpty) {
          final userId = event.stateKey;
          if (userId != null) {
            Logs().v(
                '[WidgetAPI.ParticipantsTracker] _updateParticipants: adding participant=$userId with ${devices.length} devices');
            final user = room.unsafeGetUserFromMemoryOrFallback(userId);
            participants.add(user);
          }
        }
      }
    } else {
      Logs().v(
          '[WidgetAPI.ParticipantsTracker] _updateParticipants: no call.member states');
    }

    _currentParticipants = participants;
    _participantsController.add(participants);
    Logs().d(
        '[WidgetAPI.ParticipantsTracker] _updateParticipants: found ${participants.length} participants');
  }

  void dispose() {
    Logs().i('[WidgetAPI.ParticipantsTracker] dispose: cleaning up');
    _sub?.cancel();
    _participantsController.close();
  }
}

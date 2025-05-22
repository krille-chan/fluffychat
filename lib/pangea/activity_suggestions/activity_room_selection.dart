import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/chat_settings/constants/bot_mode.dart';
import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class ActivityRoomSelection extends StatefulWidget {
  final ActivityPlannerBuilderState controller;
  final Widget backButton;

  const ActivityRoomSelection({
    super.key,
    required this.controller,
    required this.backButton,
  });

  @override
  State<ActivityRoomSelection> createState() => ActivityRoomSelectionState();
}

class ActivityRoomSelectionState extends State<ActivityRoomSelection> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  bool _loading = false;
  bool _complete = false;

  bool _hasBotDM = true;
  List<Room> _launchableRooms = [];
  final List<String> _selectedRooms = [];

  @override
  void initState() {
    super.initState();
    _launchableRooms = Matrix.of(context)
        .client
        .rooms
        .where((room) {
          return room.canSendDefaultStates &&
              !room.isSpace &&
              !room.isAnalyticsRoom;
        })
        .toList()
        .sorted((a, b) {
          final aIsBotDM = a.directChatMatrixID == BotName.byEnvironment;
          final bIsBotDM = b.directChatMatrixID == BotName.byEnvironment;
          if (aIsBotDM && !bIsBotDM) return -1;
          if (!aIsBotDM && bIsBotDM) return 1;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

    _hasBotDM = Matrix.of(context).client.rooms.any((room) {
      if (room.isDirectChat &&
          room.directChatMatrixID == BotName.byEnvironment) {
        return true;
      }
      if (room.botOptions?.mode == BotMode.directChat) {
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  List<Room> get _filteredRooms {
    final searchText = searchController.text.toLowerCase();
    return _launchableRooms.where((room) {
      return room.name.toLowerCase().contains(searchText);
    }).toList();
  }

  void _toggleRoomSelection(String roomId) {
    _selectedRooms.contains(roomId)
        ? _selectedRooms.remove(roomId)
        : _selectedRooms.add(roomId);
    if (_selectedRooms.contains(roomId)) {
      _complete = false;
    }

    setState(() {});
  }

  Map<String, Room> get _spaceDelegateCandidates {
    final spaces = Matrix.of(context).client.rooms.where((r) => r.isSpace);
    final candidates = <String, Room>{};
    for (final space in spaces) {
      for (final spaceChild in space.spaceChildren) {
        final roomId = spaceChild.roomId;
        if (roomId == null) continue;
        candidates[roomId] = space;
      }
    }
    return candidates;
  }

  final Map<String, int> _launchStatus = {};

  Future<void> _sendActivityPlan(Room room) async {
    try {
      setState(() => _launchStatus[room.id] = 0);
      await room.sendActivityPlan(
        widget.controller.updatedActivity,
        avatar: widget.controller.avatar,
        filename: widget.controller.filename,
        avatarURL: widget.controller.imageURL,
      );
      _launchStatus[room.id] = 1;
    } catch (e, s) {
      _launchStatus[room.id] = -1;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": room.id,
          "activity": widget.controller.updatedActivity.toJson(),
          "filename": widget.controller.filename,
          "avatarURL": widget.controller.imageURL,
        },
      );
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<String?> _launchBotDM() async {
    try {
      setState(() => _launchStatus["placeholder"] = 0);

      Uri? avatarUrl;
      final imageUrl = widget.controller.imageURL ??
          widget.controller.updatedActivity.imageURL;

      Uint8List? avatar = widget.controller.avatar;
      if (avatar != null) {
        avatarUrl = await Matrix.of(context).client.uploadContent(
              widget.controller.avatar!,
            );
      } else if (imageUrl != null) {
        final Response response = await http.get(Uri.parse(imageUrl));
        avatar = response.bodyBytes;
        avatarUrl = await Matrix.of(context).client.uploadContent(
              avatar,
            );
      }

      // avatar == null ? null : await client.uploadContent(avatar);
      final roomId = await Matrix.of(context).client.createRoom(
            name: widget.controller.updatedActivity.title,
            invite: [BotName.byEnvironment],
            isDirect: true,
            preset: CreateRoomPreset.trustedPrivateChat,
            initialState: [
              BotOptionsModel(mode: BotMode.directChat).toStateEvent,
              StateEvent(
                type: EventTypes.RoomPowerLevels,
                stateKey: '',
                content: defaultPowerLevels(
                  Matrix.of(context).client.userID!,
                ),
              ),
              if (avatar != null && avatarUrl != null)
                StateEvent(
                  type: EventTypes.RoomAvatar,
                  content: {'url': avatarUrl.toString()},
                ),
            ],
          );
      Room? room = Matrix.of(context).client.getRoomById(roomId);
      if (room == null) {
        await Matrix.of(context).client.waitForRoomInSync(
              roomId,
              join: true,
            );

        room = Matrix.of(context).client.getRoomById(roomId);
        if (room == null) {
          throw Exception("Room not found");
        }

        await room.sendActivityPlan(
          widget.controller.updatedActivity,
          avatar: widget.controller.avatar,
          filename: widget.controller.filename,
          avatarURL: widget.controller.imageURL,
        );
      }
      _launchStatus["placeholder"] = 1;
      return roomId;
    } catch (e, s) {
      _launchStatus["placeholder"] = -1;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "activity": widget.controller.updatedActivity.toJson(),
          "filename": widget.controller.filename,
          "avatarURL": widget.controller.imageURL,
        },
      );
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
    return null;
  }

  Future<void> _launch() async {
    setState(() => _loading = true);
    try {
      final List<Future> futures = [];
      for (final roomId in _selectedRooms) {
        if (_launchStatus[roomId] == 1) {
          continue;
        }

        final Room? room = _launchableRooms.firstWhereOrNull(
          (r) => r.id == roomId,
        );
        if (room == null) {
          if (roomId == 'placeholder') futures.add(_launchBotDM());
        } else {
          futures.add(_sendActivityPlan(room));
        }
      }

      final resp = await Future.wait(futures);
      _complete = true;
      if (!mounted) return;
      if (_selectedRooms.length == 1 &&
          _launchStatus[_selectedRooms.first] == 1) {
        if (_selectedRooms.first == 'placeholder' && resp.first != null) {
          context.go("/rooms/${resp.first}");
          Navigator.of(context).pop();
        } else if (_selectedRooms.first != 'placeholder') {
          context.go('/rooms/${_selectedRooms.first}');
          Navigator.of(context).pop();
        }
      }
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "activity": widget.controller.updatedActivity.toJson(),
          "filename": widget.controller.filename,
          "avatarURL": widget.controller.imageURL,
        },
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _tooltip(String roomId) {
    final status = _launchStatus[roomId];
    if (status == 0) {
      return "Sending...";
    } else if (status == 1) {
      return "Go to chat";
    } else if (status == -1) {
      return "Failed to send";
    }
    return "";
  }

  void _onTap(Room room) {
    final status = _launchStatus[room.id];
    if (status == 0) {
      return;
    } else if (status == 1) {
      context.go('/rooms/${room.id}');
      Navigator.of(context).pop();
    } else if (status == -1) {
      return;
    }

    debugPrint("Toggling room selection for ${room.id}");
    _toggleRoomSelection(room.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).selectChats),
        leading: widget.backButton,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          spacing: 16.0,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                textInputAction: TextInputAction.search,
                onChanged: (text) => setState(() {}),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.secondaryContainer,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  hintText: L10n.of(context).searchChats,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.normal,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          tooltip: L10n.of(context).cancel,
                          icon: const Icon(Icons.close_outlined),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              searchFocusNode.unfocus();
                            });
                          },
                          color: theme.colorScheme.onPrimaryContainer,
                        )
                      : IconButton(
                          onPressed: () => searchFocusNode.requestFocus(),
                          icon: Icon(
                            Icons.search_outlined,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredRooms.length + (_hasBotDM ? 0 : 1),
                itemBuilder: (context, index) {
                  if (!_hasBotDM && index == 0) {
                    return ChatActivityPlaceholder(
                      activity: widget.controller.updatedActivity,
                      selected: _selectedRooms.contains("placeholder"),
                      onTap: () {
                        _toggleRoomSelection("placeholder");
                      },
                      tooltip: _tooltip("placeholder"),
                      status: _launchStatus["placeholder"],
                      avatar: widget.controller.avatar,
                    );
                  }
                  if (!_hasBotDM) index--;

                  final room = _filteredRooms[index];
                  final displayname = room.getLocalizedDisplayname(
                    MatrixLocals(L10n.of(context)),
                  );
                  final space = _spaceDelegateCandidates[room.id];
                  return Tooltip(
                    message: _tooltip(room.id),
                    child: ListTile(
                      title: Text(displayname),
                      leading: SizedBox(
                        width: Avatar.defaultSize,
                        height: Avatar.defaultSize,
                        child: Stack(
                          children: [
                            if (space != null)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Avatar(
                                  border: BorderSide(
                                    width: 2,
                                    color: theme.colorScheme.surface,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppConfig.borderRadius / 4,
                                  ),
                                  mxContent: space.avatar,
                                  size: Avatar.defaultSize * 0.75,
                                  name: space.getLocalizedDisplayname(),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Avatar(
                                border: space == null
                                    ? room.isSpace
                                        ? BorderSide(
                                            width: 1,
                                            color: theme.dividerColor,
                                          )
                                        : null
                                    : BorderSide(
                                        width: 2,
                                        color: theme.colorScheme.surface,
                                      ),
                                mxContent: room.avatar,
                                size: Avatar.defaultSize * 0.75,
                                name: displayname,
                                presenceUserId: room.directChatMatrixID,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Container(
                        width: 30.0,
                        height: 30.0,
                        alignment: Alignment.center,
                        child: Builder(
                          builder: (context) {
                            final status = _launchStatus[room.id];

                            if (status == 0) {
                              return const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else if (status == 1) {
                              return const Icon(
                                Icons.check_circle_outline,
                                color: AppConfig.success,
                              );
                            } else if (status == -1) {
                              return Icon(
                                Icons.error_outline,
                                color: theme.colorScheme.error,
                              );
                            }

                            return Checkbox(
                              value: _selectedRooms.contains(room.id),
                              onChanged: (_) => _onTap(room),
                            );
                          },
                        ),
                      ),
                      onTap: () => _onTap(room),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _complete
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(L10n.of(context).selectChatToStart),
                    )
                  : ElevatedButton(
                      onPressed: _selectedRooms.isNotEmpty ? _launch : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.all(6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        disabledBackgroundColor: theme.colorScheme.primary,
                        disabledForegroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _loading
                              ? const Expanded(
                                  child: SizedBox(
                                    height: 10,
                                    child: LinearProgressIndicator(),
                                  ),
                                )
                              : Text(
                                  L10n.of(context).launchActivityToChats,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatActivityPlaceholder extends StatelessWidget {
  final ActivityPlanModel activity;
  final bool selected;
  final VoidCallback onTap;
  final String tooltip;
  final Uint8List? avatar;
  final int? status;

  const ChatActivityPlaceholder({
    required this.activity,
    required this.selected,
    required this.onTap,
    required this.tooltip,
    required this.status,
    this.avatar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const size = Avatar.defaultSize * 0.75;
    return Tooltip(
      message: tooltip,
      child: ListTile(
        title: Text(activity.title),
        leading: SizedBox(
          width: Avatar.defaultSize,
          height: Avatar.defaultSize,
          child: SizedBox(
            width: size,
            height: size,
            child: Material(
              color: theme.brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size / 2),
                side: BorderSide.none,
              ),
              clipBehavior: Clip.hardEdge,
              child: avatar != null
                  ? Image.memory(avatar!)
                  : activity.imageURL != null
                      ? activity.imageURL!.startsWith('mxc')
                          ? MxcImage(
                              uri: Uri.parse(activity.imageURL!),
                              width: size,
                              height: size,
                              cacheKey: activity.bookmarkId,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: activity.imageURL!,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const SizedBox(),
                              fit: BoxFit.cover,
                            )
                      : const SizedBox(),
            ),
          ),
        ),
        trailing: Container(
          width: 30.0,
          height: 30.0,
          alignment: Alignment.center,
          child: Builder(
            builder: (context) {
              if (status == 0) {
                return const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (status == 1) {
                return const Icon(
                  Icons.check_circle_outline,
                  color: AppConfig.success,
                );
              } else if (status == -1) {
                return Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.error,
                );
              }

              return Checkbox(
                value: selected,
                onChanged: (_) => onTap(),
              );
            },
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

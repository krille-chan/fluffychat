import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:slugify/slugify.dart';
import 'avatar.dart';
import 'matrix.dart';

class InputBar extends StatelessWidget {
  final Room room;
  final int minLines;
  final int maxLines;
  final TextInputType keyboardType;
  final ValueChanged<String> onSubmitted;
  final FocusNode focusNode;
  final TextEditingController controller;
  final InputDecoration decoration;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  InputBar({
    this.room,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.onSubmitted,
    this.focusNode,
    this.controller,
    this.decoration,
    this.onChanged,
    this.autofocus,
  });

  List<Map<String, String>> getSuggestions(String text) {
    if (controller.selection.baseOffset != controller.selection.extentOffset ||
        controller.selection.baseOffset < 0) {
      return []; // no entries if there is selected text
    }
    final searchText =
        controller.text.substring(0, controller.selection.baseOffset);
    final ret = <Map<String, String>>[];
    const maxResults = 10;

    final commandMatch = RegExp(r'^\/([\w]*)$').firstMatch(searchText);
    if (commandMatch != null) {
      final commandSearch = commandMatch[1].toLowerCase();
      for (final command in room.client.commands.keys) {
        if (command.contains(commandSearch)) {
          ret.add({
            'type': 'command',
            'name': command,
          });
        }

        if (ret.length > maxResults) return ret;
      }
    }
    final emojiMatch =
        RegExp(r'(?:\s|^):(?:([-\w]+)~)?([-\w]+)$').firstMatch(searchText);
    if (emojiMatch != null) {
      final packSearch = emojiMatch[1];
      final emoteSearch = emojiMatch[2].toLowerCase();
      final emotePacks = room.getImagePacks(ImagePackUsage.emoticon);
      if (packSearch == null || packSearch.isEmpty) {
        for (final pack in emotePacks.entries) {
          for (final emote in pack.value.images.entries) {
            if (emote.key.toLowerCase().contains(emoteSearch)) {
              ret.add({
                'type': 'emote',
                'name': emote.key,
                'pack': pack.key,
                'pack_avatar_url': pack.value.pack.avatarUrl?.toString(),
                'pack_display_name': pack.value.pack.displayName ?? pack.key,
                'mxc': emote.value.url.toString(),
              });
            }
            if (ret.length > maxResults) {
              break;
            }
          }
          if (ret.length > maxResults) {
            break;
          }
        }
      } else if (emotePacks[packSearch] != null) {
        for (final emote in emotePacks[packSearch].images.entries) {
          if (emote.key.toLowerCase().contains(emoteSearch)) {
            ret.add({
              'type': 'emote',
              'name': emote.key,
              'pack': packSearch,
              'pack_avatar_url':
                  emotePacks[packSearch].pack.avatarUrl?.toString(),
              'pack_display_name':
                  emotePacks[packSearch].pack.displayName ?? packSearch,
              'mxc': emote.value.url.toString(),
            });
          }
          if (ret.length > maxResults) {
            break;
          }
        }
      }
    }
    final userMatch = RegExp(r'(?:\s|^)@([-\w]+)$').firstMatch(searchText);
    if (userMatch != null) {
      final userSearch = userMatch[1].toLowerCase();
      for (final user in room.getParticipants()) {
        if ((user.displayName != null &&
                (user.displayName.toLowerCase().contains(userSearch) ||
                    slugify(user.displayName.toLowerCase())
                        .contains(userSearch))) ||
            user.id.split(':')[0].toLowerCase().contains(userSearch)) {
          ret.add({
            'type': 'user',
            'mxid': user.id,
            'mention': user.mention,
            'displayname': user.displayName,
            'avatar_url': user.avatarUrl?.toString(),
          });
        }
        if (ret.length > maxResults) {
          break;
        }
      }
    }
    final roomMatch = RegExp(r'(?:\s|^)#([-\w]+)$').firstMatch(searchText);
    if (roomMatch != null) {
      final roomSearch = roomMatch[1].toLowerCase();
      for (final r in room.client.rooms) {
        if (r.getState(EventTypes.RoomTombstone) != null) {
          continue; // we don't care about tombstoned rooms
        }
        final state = r.getState(EventTypes.RoomCanonicalAlias);
        if ((state != null &&
                ((state.content['alias'] is String &&
                        state.content['alias']
                            .split(':')[0]
                            .toLowerCase()
                            .contains(roomSearch)) ||
                    (state.content['alt_aliases'] is List &&
                        state.content['alt_aliases'].any((l) =>
                            l is String &&
                            l
                                .split(':')[0]
                                .toLowerCase()
                                .contains(roomSearch))))) ||
            (r.name != null && r.name.toLowerCase().contains(roomSearch))) {
          ret.add({
            'type': 'room',
            'mxid': (r.canonicalAlias != null && r.canonicalAlias.isNotEmpty)
                ? r.canonicalAlias
                : r.id,
            'displayname': r.displayname,
            'avatar_url': r.avatar?.toString(),
          });
        }
        if (ret.length > maxResults) {
          break;
        }
      }
    }
    return ret;
  }

  String _commandHint(L10n l10n, String command) {
    switch (command) {
      case 'send':
        return l10n.commandHintSend;
      case 'me':
        return l10n.commandHintMe;
      case 'plain':
        return l10n.commandHintPlain;
      case 'html':
        return l10n.commandHintHtml;
      case 'react':
        return l10n.commandHintReact;
      case 'join':
        return l10n.commandHintJoin;
      case 'leave':
        return l10n.commandHintLeave;
      case 'op':
        return l10n.commandHintOp;
      case 'kick':
        return l10n.commandHintKick;
      case 'ban':
        return l10n.commandHintBan;
      case 'unban':
        return l10n.commandHintUnBan;
      case 'invite':
        return l10n.commandHintInvite;
      case 'myroomnick':
        return l10n.commandHintMyRoomNick;
      case 'myroomavatar':
        return l10n.commandHintMyRoomAvatar;
      default:
        return '';
    }
  }

  Widget buildSuggestion(
    BuildContext context,
    Map<String, String> suggestion,
    Client client,
  ) {
    const size = 30.0;
    const padding = EdgeInsets.all(4.0);
    if (suggestion['type'] == 'command') {
      final command = suggestion['name'];
      return Container(
        padding: padding,
        height: size + padding.bottom + padding.top,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('/' + command, style: TextStyle(fontFamily: 'monospace')),
            Text(_commandHint(L10n.of(context), command),
                style: Theme.of(context).textTheme.caption),
          ],
        ),
      );
    }
    if (suggestion['type'] == 'emote') {
      final ratio = MediaQuery.of(context).devicePixelRatio;
      final url = Uri.parse(suggestion['mxc'] ?? '')?.getThumbnail(
        room.client,
        width: size * ratio,
        height: size * ratio,
        method: ThumbnailMethod.scale,
        animated: true,
      );
      return Container(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: url.toString(),
              width: size,
              height: size,
            ),
            SizedBox(width: 6),
            Text(suggestion['name']),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Opacity(
                  opacity: suggestion['pack_avatar_url'] != null ? 0.8 : 0.5,
                  child: suggestion['pack_avatar_url'] != null
                      ? Avatar(
                          Uri.parse(suggestion['pack_avatar_url']),
                          suggestion['pack_display_name'],
                          size: size * 0.9,
                          client: client,
                        )
                      : Text(suggestion['pack_display_name']),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (suggestion['type'] == 'user' || suggestion['type'] == 'room') {
      final url = Uri.parse(suggestion['avatar_url'] ?? '');
      return Container(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Avatar(
              url,
              suggestion['displayname'] ?? suggestion['mxid'],
              size: size,
              client: client,
            ),
            SizedBox(width: 6),
            Text(suggestion['displayname'] ?? suggestion['mxid']),
          ],
        ),
      );
    }
    return Container();
  }

  void insertSuggestion(BuildContext context, Map<String, String> suggestion) {
    final replaceText =
        controller.text.substring(0, controller.selection.baseOffset);
    var startText = '';
    final afterText = replaceText == controller.text
        ? ''
        : controller.text.substring(controller.selection.baseOffset + 1);
    var insertText = '';
    if (suggestion['type'] == 'command') {
      insertText = suggestion['name'] + ' ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'^(\/[\w]*)$'),
        (Match m) => '/' + insertText,
      );
    }
    if (suggestion['type'] == 'emote') {
      var isUnique = true;
      final insertEmote = suggestion['name'];
      final insertPack = suggestion['pack'];
      final emotePacks = room.getImagePacks(ImagePackUsage.emoticon);
      for (final pack in emotePacks.entries) {
        if (pack.key == insertPack) {
          continue;
        }
        for (final emote in pack.value.images.entries) {
          if (emote.key == insertEmote) {
            isUnique = false;
            break;
          }
        }
        if (!isUnique) {
          break;
        }
      }
      insertText = ':${isUnique ? '' : insertPack + '~'}$insertEmote: ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'(\s|^)(:(?:[-\w]+~)?[-\w]+)$'),
        (Match m) => '${m[1]}$insertText',
      );
    }
    if (suggestion['type'] == 'user') {
      insertText = suggestion['mention'] + ' ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'(\s|^)(@[-\w]+)$'),
        (Match m) => '${m[1]}$insertText',
      );
    }
    if (suggestion['type'] == 'room') {
      insertText = suggestion['mxid'] + ' ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'(\s|^)(#[-\w]+)$'),
        (Match m) => '${m[1]}$insertText',
      );
    }
    if (insertText.isNotEmpty && startText.isNotEmpty) {
      controller.text = startText + afterText;
      controller.selection = TextSelection(
        baseOffset: startText.length,
        extentOffset: startText.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final useShortCuts = (PlatformInfos.isWeb || PlatformInfos.isDesktop);
    return Shortcuts(
      shortcuts: !useShortCuts
          ? {}
          : {
              LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.enter):
                  NewLineIntent(),
              LogicalKeySet(LogicalKeyboardKey.enter): SubmitLineIntent(),
            },
      child: Actions(
        actions: !useShortCuts
            ? {}
            : {
                NewLineIntent: CallbackAction(onInvoke: (i) {
                  final val = controller.value;
                  final selection = val.selection.start;
                  final messageWithoutNewLine =
                      controller.text.substring(0, val.selection.start) +
                          '\n' +
                          controller.text.substring(val.selection.end);
                  controller.value = TextEditingValue(
                    text: messageWithoutNewLine,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: selection + 1),
                    ),
                  );
                  return null;
                }),
                SubmitLineIntent: CallbackAction(onInvoke: (i) {
                  onSubmitted(controller.text);
                  return null;
                }),
              },
        child: TypeAheadField<Map<String, String>>(
          direction: AxisDirection.up,
          hideOnEmpty: true,
          hideOnLoading: true,
          keepSuggestionsOnSuggestionSelected: true,
          debounceDuration: Duration(
              milliseconds:
                  50), // show suggestions after 50ms idle time (default is 300)
          textFieldConfiguration: TextFieldConfiguration(
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: keyboardType,
            autofocus: autofocus,
            onSubmitted: (text) {
              // fix for library for now
              // it sets the types for the callback incorrectly
              onSubmitted(text);
            },
            //focusNode: focusNode,
            controller: controller,
            decoration: decoration,
            focusNode: focusNode,
            onChanged: (text) {
              // fix for the library for now
              // it sets the types for the callback incorrectly
              onChanged(text);
            },
            textCapitalization: TextCapitalization.sentences,
          ),
          suggestionsCallback: getSuggestions,
          itemBuilder: (c, s) =>
              buildSuggestion(c, s, Matrix.of(context).client),
          onSuggestionSelected: (Map<String, String> suggestion) =>
              insertSuggestion(context, suggestion),
          errorBuilder: (BuildContext context, Object error) => Container(),
          loadingBuilder: (BuildContext context) =>
              Container(), // fix loading briefly flickering a dark box
          noItemsFoundBuilder: (BuildContext context) =>
              Container(), // fix loading briefly showing no suggestions
        ),
      ),
    );
  }
}

class NewLineIntent extends Intent {}

class SubmitLineIntent extends Intent {}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

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
  });

  Map<String, Map<String, String>> getEmotePacks() {
    final emotePacks = <String, Map<String, String>>{};
    final addEmotePack = (String packName, Map<String, dynamic> content) {
      emotePacks[packName] = <String, String>{};
      content.forEach((key, value) {
        if (key is String && value is String && value.startsWith('mxc://')) {
          emotePacks[packName][key] = value;
        }
      });
    };
    final roomEmotes = room.getState('im.ponies.room_emotes');
    final userEmotes = room.client.accountData['im.ponies.user_emotes'];
    if (roomEmotes != null && roomEmotes.content['short'] is Map) {
      addEmotePack('room', roomEmotes.content['short']);
    }
    if (userEmotes != null && userEmotes.content['short'] is Map) {
      addEmotePack('user', userEmotes.content['short']);
    }
    return emotePacks;
  }

  List<Map<String, String>> getSuggestions(String text) {
    if (controller.selection.baseOffset != controller.selection.extentOffset || controller.selection.baseOffset < 0) {
      return []; // no entries if there is selected text
    }
    final searchText = controller.text.substring(0, controller.selection.baseOffset);
    final ret = <Map<String, String>>[];
    final emojiMatch = RegExp(r'(?:\s|^):(?:([-\w]+)~)?([-\w]+)$').firstMatch(searchText);
    if (emojiMatch != null) {
      final packSearch = emojiMatch[1];
      final emoteSearch = emojiMatch[2].toLowerCase();
      var results = 0;
      final emotePacks = getEmotePacks();
      if (packSearch == null || packSearch.isEmpty) {
        for (final pack in emotePacks.entries) {
          for (final emote in pack.value.entries) {
            if (emote.key.toLowerCase().contains(emoteSearch)) {
              ret.add({
                'type': 'emote',
                'name': emote.key,
                'pack': pack.key,
                'mxc': emote.value,
              });
              results++;
            }
            if (results > 10) {
              break;
            }
          }
          if (results > 10) {
            break;
          }
        }
      } else if (emotePacks[packSearch] != null) {
        for (final emote in emotePacks[packSearch].entries) {
          if (emote.key.toLowerCase().contains(emoteSearch)) {
            ret.add({
              'type': 'emote',
              'name': emote.key,
              'pack': packSearch,
              'mxc': emote.value,
            });
            results++;
          }
          if (results > 10) {
            break;
          }
        }
      }
    }
    return ret;
  }

  Widget buildSuggestion(BuildContext context, Map<String, String> suggestion) {
    if (suggestion['type'] == 'emote') {
      final size = 30.0;
      final ratio = MediaQuery.of(context).devicePixelRatio;
      final url = Uri.parse(suggestion['mxc'] ?? '')?.getThumbnail(
        room.client,
        width: size * ratio,
        height: size * ratio,
        method: ThumbnailMethod.scale,
      );
      return Container(
        padding: EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: kIsWeb
                ? NetworkImage(url)
                : AdvancedNetworkImage(url, useDiskCache: true),
              width: size,
              height: size,
            ),
            SizedBox(width: 6),
            Text(suggestion['name']),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Opacity(
                  opacity: 0.5,
                  child: Text(suggestion['pack']),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  void insertSuggestion(BuildContext context, Map<String, String> suggestion) {
    if (suggestion['type'] == 'emote') {
      var isUnique = true;
      final insertEmote = suggestion['name'];
      final insertPack = suggestion['pack'];
      final emotePacks = getEmotePacks();
      for (final pack in emotePacks.entries) {
        if (pack.key == insertPack) {
          continue;
        }
        for (final emote in pack.value.entries) {
          if (emote.key == insertEmote) {
            isUnique = false;
            break;
          }
        }
        if (!isUnique) {
          break;
        }
      }
      final insertText = isUnique ? insertEmote : ':${insertPack}~${insertEmote.substring(1)}';
      final replaceText = controller.text.substring(0, controller.selection.baseOffset);
      final afterText = replaceText == controller.text ? '' : controller.text.substring(controller.selection.baseOffset + 1);
      final startText = replaceText.replaceAllMapped(
        RegExp(r'(\s|^)(:(?:[-\w]+~)?[-\w]+)$'),
        (Match m) => '${m[1]}${insertText} ',
      );
      controller.text = startText + afterText;
      if (startText == insertText + ' ') {
        // stupid fix for now
        FocusScope.of(context).requestFocus(FocusNode());
        Future.delayed(Duration(milliseconds: 1)).then((res) {
          focusNode.requestFocus();
          controller.selection = TextSelection(
            baseOffset: startText.length,
            extentOffset: startText.length,
          );
        });
      } else {
        controller.selection = TextSelection(
          baseOffset: startText.length,
          extentOffset: startText.length,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Map<String, String>>(
      direction: AxisDirection.up,
      hideOnEmpty: true,
      hideOnLoading: true,
      keepSuggestionsOnSuggestionSelected: true,
      debounceDuration: Duration(milliseconds: 50), // show suggestions after 50ms idle time (default is 300)
      textFieldConfiguration: TextFieldConfiguration(
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onSubmitted: (text) { // fix for library for now
          onSubmitted(text);
        },
        focusNode: focusNode,
        controller: controller,
        decoration: decoration,
        onChanged: (text) {
          onChanged(text);
        },
      ),
      suggestionsCallback: getSuggestions,
      itemBuilder: buildSuggestion,
      onSuggestionSelected: (Map<String, String> suggestion) => insertSuggestion(context, suggestion),
      errorBuilder: (BuildContext context, Object error) => Container(),
      loadingBuilder: (BuildContext context) => Container(), // fix loading briefly flickering a dark box
      noItemsFoundBuilder: (BuildContext context) => Container(), // fix loading briefly showing no suggestions
    );
  }
}

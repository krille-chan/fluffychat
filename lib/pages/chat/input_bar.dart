import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:matrix/matrix.dart';
import 'package:slugify/slugify.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/choreographer/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_state_model.dart';
import 'package:fluffychat/pangea/choreographer/text_editing/pangea_text_controller.dart';
import 'package:fluffychat/pangea/common/widgets/shrinkable_text.dart';
import 'package:fluffychat/pangea/learning_settings/tool_settings_enum.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/subscription/widgets/paywall_card.dart';
import 'package:fluffychat/utils/markdown_context_builder.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import '../../widgets/avatar.dart';
import '../../widgets/matrix.dart';
import 'command_hints.dart';

class InputBar extends StatelessWidget {
  final Room room;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<Uint8List?>? onSubmitImage;
  final FocusNode? focusNode;
  // #Pangea
  // final TextEditingController? controller;
  final PangeaTextController? controller;
  final Choreographer choreographer;
  final Function(PangeaMatchState) showMatch;
  final Future Function(String) onFeedbackSubmitted;
  // Pangea#
  final InputDecoration decoration;
  final ValueChanged<String>? onChanged;
  final bool? autofocus;
  final bool readOnly;
  final List<Emoji> suggestionEmojis;

  const InputBar({
    required this.room,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.onSubmitted,
    this.onSubmitImage,
    this.focusNode,
    this.controller,
    required this.decoration,
    this.onChanged,
    this.autofocus,
    this.textInputAction,
    this.readOnly = false,
    required this.suggestionEmojis,
    // #Pangea
    required this.choreographer,
    required this.showMatch,
    required this.onFeedbackSubmitted,
    // Pangea#
    super.key,
  });

  List<Map<String, String?>> getSuggestions(TextEditingValue text) {
    if (text.selection.baseOffset != text.selection.extentOffset ||
        text.selection.baseOffset < 0) {
      return []; // no entries if there is selected text
    }
    final searchText = text.text.substring(0, text.selection.baseOffset);
    final ret = <Map<String, String?>>[];
    const maxResults = 30;

    // #Pangea
    // final commandMatch = RegExp(r'^/(\w*)$').firstMatch(searchText);
    // if (commandMatch != null) {
    //   final commandSearch = commandMatch[1]!.toLowerCase();
    //   for (final command in room.client.commands.keys) {
    //     if (command.contains(commandSearch)) {
    //       ret.add({'type': 'command', 'name': command});
    //     }

    //     if (ret.length > maxResults) return ret;
    //   }
    // }
    // Pangea#
    final emojiMatch = RegExp(
      r'(?:\s|^):(?:([\p{L}\p{N}_-]+)~)?([\p{L}\p{N}_-]+)$',
      unicode: true,
    ).firstMatch(searchText);
    if (emojiMatch != null) {
      final packSearch = emojiMatch[1];
      final emoteSearch = emojiMatch[2]!.toLowerCase();
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
        for (final emote in emotePacks[packSearch]!.images.entries) {
          if (emote.key.toLowerCase().contains(emoteSearch)) {
            ret.add({
              'type': 'emote',
              'name': emote.key,
              'pack': packSearch,
              'pack_avatar_url': emotePacks[packSearch]!.pack.avatarUrl
                  ?.toString(),
              'pack_display_name':
                  emotePacks[packSearch]!.pack.displayName ?? packSearch,
              'mxc': emote.value.url.toString(),
            });
          }
          if (ret.length > maxResults) {
            break;
          }
        }
      }

      // aside of emote packs, also propose normal (tm) unicode emojis
      final matchingUnicodeEmojis = suggestionEmojis
          .where((emoji) => emoji.name.toLowerCase().contains(emoteSearch))
          .toList();

      // sort by the index of the search term in the name in order to have
      // best matches first
      // (thanks for the hint by github.com/nextcloud/circles devs)
      matchingUnicodeEmojis.sort((a, b) {
        final indexA = a.name.indexOf(emoteSearch);
        final indexB = b.name.indexOf(emoteSearch);
        if (indexA == -1 || indexB == -1) {
          if (indexA == indexB) return 0;
          if (indexA == -1) {
            return 1;
          } else {
            return 0;
          }
        }
        return indexA.compareTo(indexB);
      });
      for (final emoji in matchingUnicodeEmojis) {
        ret.add({
          'type': 'emoji',
          'emoji': emoji.emoji,
          'label': emoji.name,
          'current_word': ':$emoteSearch',
        });
        if (ret.length > maxResults) {
          break;
        }
      }
    }
    final userMatch = RegExp(r'(?:\s|^)@([-\w]+)$').firstMatch(searchText);
    if (userMatch != null) {
      final userSearch = userMatch[1]!.toLowerCase();
      for (final user in room.getParticipants()) {
        if ((user.displayName != null &&
                (user.displayName!.toLowerCase().contains(userSearch) ||
                    slugify(
                      user.displayName!.toLowerCase(),
                    ).contains(userSearch))) ||
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
      final roomSearch = roomMatch[1]!.toLowerCase();
      for (final r in room.client.rooms) {
        if (r.getState(EventTypes.RoomTombstone) != null) {
          continue; // we don't care about tombstoned rooms
        }
        final state = r.getState(EventTypes.RoomCanonicalAlias);
        if ((state != null &&
                ((state.content['alias'] is String &&
                        state.content
                            .tryGet<String>('alias')!
                            .split(':')[0]
                            .toLowerCase()
                            .contains(roomSearch)) ||
                    (state.content['alt_aliases'] is List &&
                        (state.content['alt_aliases'] as List).any(
                          (l) =>
                              l is String &&
                              l
                                  .split(':')[0]
                                  .toLowerCase()
                                  .contains(roomSearch),
                        )))) ||
            (r.name.toLowerCase().contains(roomSearch))) {
          ret.add({
            'type': 'room',
            'mxid': (r.canonicalAlias.isNotEmpty) ? r.canonicalAlias : r.id,
            'displayname': r.getLocalizedDisplayname(),
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

  Widget buildSuggestion(
    BuildContext context,
    Map<String, String?> suggestion,
    void Function(Map<String, String?>) onSelected,
    Client? client,
  ) {
    final theme = Theme.of(context);
    const size = 30.0;
    if (suggestion['type'] == 'command') {
      final command = suggestion['name']!;
      final hint = commandHint(L10n.of(context), command);
      return Tooltip(
        message: hint,
        waitDuration: const Duration(days: 1), // don't show on hover
        child: ListTile(
          onTap: () => onSelected(suggestion),
          title: Text(
            commandExample(command),
            style: const TextStyle(fontFamily: 'RobotoMono'),
          ),
          subtitle: Text(
            hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ),
      );
    }
    if (suggestion['type'] == 'emoji') {
      final label = suggestion['label']!;
      return Tooltip(
        message: label,
        waitDuration: const Duration(days: 1), // don't show on hover
        child: ListTile(
          onTap: () => onSelected(suggestion),
          leading: SizedBox.square(
            dimension: size,
            child: Text(
              suggestion['emoji']!,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      );
    }
    if (suggestion['type'] == 'emote') {
      return ListTile(
        onTap: () => onSelected(suggestion),
        leading: MxcImage(
          // ensure proper ordering ...
          key: ValueKey(suggestion['name']),
          uri: suggestion['mxc'] is String
              ? Uri.parse(suggestion['mxc'] ?? '')
              : null,
          width: size,
          height: size,
          isThumbnail: false,
        ),
        title: Row(
          crossAxisAlignment: .center,
          children: <Widget>[
            Text(suggestion['name']!),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Opacity(
                  opacity: suggestion['pack_avatar_url'] != null ? 0.8 : 0.5,
                  child: suggestion['pack_avatar_url'] != null
                      ? Avatar(
                          mxContent: Uri.tryParse(
                            suggestion.tryGet<String>('pack_avatar_url') ?? '',
                          ),
                          name: suggestion.tryGet<String>('pack_display_name'),
                          size: size * 0.9,
                          client: client,
                        )
                      : Text(suggestion['pack_display_name']!),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (suggestion['type'] == 'user' || suggestion['type'] == 'room') {
      final url = Uri.parse(suggestion['avatar_url'] ?? '');
      return ListTile(
        onTap: () => onSelected(suggestion),
        leading: Avatar(
          mxContent: url,
          name:
              suggestion.tryGet<String>('displayname') ??
              suggestion.tryGet<String>('mxid'),
          size: size,
          client: client,
        ),
        title: Text(suggestion['displayname'] ?? suggestion['mxid']!),
      );
    }
    return const SizedBox.shrink();
  }

  String insertSuggestion(Map<String, String?> suggestion) {
    final replaceText = controller!.text.substring(
      0,
      controller!.selection.baseOffset,
    );
    var startText = '';
    final afterText = replaceText == controller!.text
        ? ''
        : controller!.text.substring(controller!.selection.baseOffset + 1);
    var insertText = '';
    if (suggestion['type'] == 'command') {
      insertText = '${suggestion['name']!} ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'^(/\w*)$'),
        (Match m) => '/$insertText',
      );
    }
    if (suggestion['type'] == 'emoji') {
      insertText = '${suggestion['emoji']!} ';
      startText = replaceText.replaceAllMapped(
        // #Pangea
        RegExp(suggestion['current_word']!, caseSensitive: false),
        // suggestion['current_word']!,
        // Pangea#
        (Match m) => insertText,
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
      insertText = ':${isUnique ? '' : '${insertPack!}~'}$insertEmote: ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'(\s|^)(:(?:[-\w]+~)?[-\w]+)$'),
        (Match m) => '${m[1]}$insertText',
      );
    }
    if (suggestion['type'] == 'user') {
      insertText = '${suggestion['mention']!} ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'(\s|^)(@[-\w]+)$'),
        (Match m) => '${m[1]}$insertText',
      );
    }
    if (suggestion['type'] == 'room') {
      insertText = '${suggestion['mxid']!} ';
      startText = replaceText.replaceAllMapped(
        RegExp(r'(\s|^)(#[-\w]+)$'),
        (Match m) => '${m[1]}$insertText',
      );
    }

    return startText + afterText;
  }

  // #Pangea
  SubscriptionStatus get _subscriptionStatus =>
      MatrixState.pangeaController.subscriptionController.subscriptionStatus;

  String _defaultHintText(BuildContext context) {
    return MatrixState.pangeaController.userController.languagesSet
        ? L10n.of(context).writeAMessageLangCodes(
            MatrixState.pangeaController.userController.userL1!.displayName,
            MatrixState.pangeaController.userController.userL2!.displayName,
          )
        : L10n.of(context).writeAMessage;
  }

  void _onInputTap(BuildContext context) {
    if (_shouldShowPaywall(context)) return;

    final baseOffset = controller!.selection.baseOffset;
    final adjustedOffset = _adjustOffsetForNormalization(baseOffset);
    final match = choreographer.igcController.getMatchByOffset(adjustedOffset);
    if (match == null) return;
    showMatch(match);

    choreographer.textController.selection = TextSelection.collapsed(
      offset: baseOffset,
    );
  }

  bool _shouldShowPaywall(BuildContext context) {
    if (_subscriptionStatus == SubscriptionStatus.shouldShowPaywall) {
      PaywallCard.show(context, ChoreoConstants.inputTransformTargetKey);
      return true;
    }
    return false;
  }

  int _adjustOffsetForNormalization(int baseOffset) {
    int adjustedOffset = baseOffset;
    final corrections =
        choreographer.igcController.closedNormalizationCorrections;

    for (final correction in corrections) {
      final match = correction.updatedMatch.match;
      if (match.offset < adjustedOffset && match.length > 0) {
        adjustedOffset += (match.length - 1);
      }
    }
    return adjustedOffset;
  }
  // Pangea#

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Autocomplete<Map<String, String?>>(
      focusNode: focusNode,
      textEditingController: controller,
      optionsBuilder: getSuggestions,
      // #Pangea
      // fieldViewBuilder: (context, controller, focusNode, _) => TextField(
      fieldViewBuilder: (context, _, focusNode, _) => ListenableBuilder(
        listenable: Listenable.merge([
          choreographer,
          choreographer.igcController.activeMatch,
        ]),
        builder: (context, _) {
          return TextField(
            // Pangea#
            controller: controller,
            focusNode: focusNode,
            // #Pangea
            // readOnly: readOnly,
            // contextMenuBuilder: (c, e) =>
            //     markdownContextBuilder(c, e, controller),
            contextMenuBuilder: (c, e) =>
                markdownContextBuilder(c, e, controller!),
            onTap: () => _onInputTap(context),
            autocorrect: MatrixState.pangeaController.userController
                .isToolEnabled(ToolSetting.enableAutocorrect),
            // Pangea#
            contentInsertionConfiguration: ContentInsertionConfiguration(
              onContentInserted: (KeyboardInsertedContent content) {
                final data = content.data;
                if (data == null) return;

                final file = MatrixFile(
                  mimeType: content.mimeType,
                  bytes: data,
                  name: content.uri.split('/').last,
                );
                room.sendFileEvent(file, shrinkImageMaxDimension: 1600);
              },
            ),
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: keyboardType!,
            textInputAction: textInputAction,
            autofocus: autofocus!,
            inputFormatters: [
              // #Pangea
              //LengthLimitingTextInputFormatter((maxPDUSize / 3).floor()),
              //setting max character count to 1000
              //after max, nothing else can be typed
              LengthLimitingTextInputFormatter(1000),
              // Pangea#
            ],
            onSubmitted: (text) {
              // fix for library for now
              // it sets the types for the callback incorrectly
              onSubmitted!(text);
            },
            // #Pangea
            // maxLength: AppSettings.textMessageMaxLength.value,
            // decoration: decoration,
            decoration: decoration.copyWith(
              hint: StreamBuilder(
                stream: MatrixState
                    .pangeaController
                    .userController
                    .languageStream
                    .stream,
                builder: (context, _) => SizedBox(
                  height: 24,
                  child: ShrinkableText(
                    text: _defaultHintText(context),
                    maxWidth: double.infinity,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
              ),
            ),
            // Pangea#
            onChanged: (text) {
              // fix for the library for now
              // it sets the types for the callback incorrectly
              onChanged!(text);
            },
            textCapitalization: TextCapitalization.sentences,
          );
        },
      ),
      optionsViewBuilder: (c, onSelected, s) {
        final suggestions = s.toList();
        return Material(
          elevation: theme.appBarTheme.scrolledUnderElevation ?? 4,
          shadowColor: theme.appBarTheme.shadowColor,
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          clipBehavior: Clip.hardEdge,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, i) => buildSuggestion(
              c,
              suggestions[i],
              onSelected,
              Matrix.of(context).client,
            ),
          ),
        );
      },
      displayStringForOption: insertSuggestion,
      optionsViewOpenDirection: OptionsViewOpenDirection.up,
    );
  }
}

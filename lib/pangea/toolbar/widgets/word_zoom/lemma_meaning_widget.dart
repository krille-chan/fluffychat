import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_repo.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_zoom_activity_button.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaMeaningWidget extends StatefulWidget {
  final ConstructUses constructUse;
  final String langCode;
  final TextStyle? style;
  final InlineSpan? leading;

  /// These are not present if this widget is used outside the chat
  /// (e.g. in the vocab details view)
  /// TODO: let the user assign the meaning in the vocab details view
  final MessageOverlayController? controller;
  final PangeaToken? token;

  const LemmaMeaningWidget({
    super.key,
    required this.constructUse,
    required this.langCode,
    required this.controller,
    required this.token,
    this.style,
    this.leading,
  });

  @override
  LemmaMeaningWidgetState createState() => LemmaMeaningWidgetState();
}

class LemmaMeaningWidgetState extends State<LemmaMeaningWidget> {
  bool _editMode = false;
  late TextEditingController _controller;
  LemmaInfoResponse? _lemmaInfo;
  bool _isLoading = true;
  String? _error;

  String get _lemma => widget.constructUse.lemma;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _fetchLemmaMeaning();
  }

  @override
  void didUpdateWidget(covariant LemmaMeaningWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.constructUse != widget.constructUse ||
        oldWidget.langCode != widget.langCode) {
      _fetchLemmaMeaning();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  LemmaInfoRequest get _request => LemmaInfoRequest(
        lemma: _lemma,
        partOfSpeech: widget.constructUse.category,

        /// This assumes that the user's L2 is the language of the lemma
        lemmaLang: widget.langCode,
        userL1:
            MatrixState.pangeaController.languageController.userL1?.langCode ??
                LanguageKeys.defaultLanguage,
      );

  Future<void> _fetchLemmaMeaning() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      _lemmaInfo = await LemmaInfoRepo.get(_request);
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleEditMode(bool value) => setState(() => _editMode = value);

  Future<void> editLemmaMeaning(String userEdit) async {
    final originalMeaning = _lemmaInfo;

    if (originalMeaning != null) {
      LemmaInfoRepo.set(
        _request,
        LemmaInfoResponse(emoji: originalMeaning.emoji, meaning: userEdit),
      );

      _toggleEditMode(false);
      _fetchLemmaMeaning();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.token != null &&
        widget.controller?.practiceSelection != null &&
        widget.controller!.practiceSelection!.hasActiveActivityByToken(
          ActivityTypeEnum.wordMeaning,
          widget.token!,
        )) {
      return WordZoomActivityButton(
        icon: const Icon(Symbols.dictionary),
        isSelected: widget.controller?.toolbarMode == MessageMode.wordMeaning,
        onPressed: widget.controller != null
            ? () {
                // TODO: it would be better to explicitly set to wordMeaningChoice here
                widget.controller!.updateToolbarMode(MessageMode.wordMeaning);
              }
            : () => {},
        opacity:
            widget.controller?.toolbarMode == MessageMode.wordMeaning ? 1 : 0.4,
      );
    }

    if (_isLoading) {
      return const TextLoadingShimmer();
    }

    if (_error != null) {
      debugger(when: kDebugMode);
      return Text(
        L10n.of(context).oopsSomethingWentWrong,
        textAlign: TextAlign.center,
      );
    }

    if (_editMode) {
      _controller.text = _lemmaInfo?.meaning ?? "";
      return Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).whatIsMeaning(_lemma, widget.constructUse.category)}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                minLines: 1,
                maxLines: 3,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: _lemmaInfo?.meaning,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleEditMode(false),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Text(L10n.of(context).cancel),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _controller.text != _lemmaInfo?.meaning &&
                          _controller.text.isNotEmpty
                      ? editLemmaMeaning(_controller.text)
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Text(L10n.of(context).saveChanges),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: L10n.of(context).doubleClickToEdit,
            child: GestureDetector(
              onLongPress: () => _toggleEditMode(true),
              onDoubleTap: () => _toggleEditMode(true),
              child: RichText(
                text: TextSpan(
                  style: widget.style?.copyWith(
                    color: widget.controller?.toolbarMode ==
                            MessageMode.wordMeaning
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  children: [
                    if (widget.leading != null) widget.leading!,
                    if (widget.leading != null)
                      const WidgetSpan(child: SizedBox(width: 6.0)),
                    TextSpan(
                      text: _lemmaInfo?.meaning,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

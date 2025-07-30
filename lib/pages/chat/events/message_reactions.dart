import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/reaction_burst.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class MessageReactions extends StatefulWidget {
  final Event event;
  final Timeline timeline;
  final ChatController controller;

  const MessageReactions(this.event, this.timeline, this.controller,
      {super.key});

  @override
  State<MessageReactions> createState() => _MessageReactionsState();
}

class _MessageReactionsState extends State<MessageReactions> {
  StreamSubscription? _reactionSubscription;
  Map<String, _ReactionEntry> _reactionMap = {};
  Set<String> _newlyAddedReactions = {};
  late Client client;

  @override
  void initState() {
    super.initState();
    client = Matrix.of(context).client;
    _updateReactionMap();
    _setupReactionStream();
  }

  void _setupReactionStream() {
    //listen for new reaction events to know when to trigger reaction
    _reactionSubscription = widget.controller.room.client.onSync.stream.where(
      (update) {
        final room = widget.controller.room;
        final timelineEvents = update.rooms?.join?[room.id]?.timeline?.events;
        if (timelineEvents == null) return false;

        final eventID = widget.event.eventId;
        return timelineEvents.any(
          (e) =>
              e.type == EventTypes.Redaction ||
              (e.type == EventTypes.Reaction &&
                  Event.fromMatrixEvent(e, room).relationshipEventId ==
                      eventID),
        );
      },
    ).listen(_onReactionUpdate);
  }

  void _onReactionUpdate(SyncUpdate update) {
    //Identifies newly added reactions so they can be animated on arrival
    final previousReactions = Set<String>.from(_reactionMap.keys);
    _updateReactionMap();
    final currentReactions = Set<String>.from(_reactionMap.keys);
    _newlyAddedReactions = currentReactions.difference(previousReactions);

    if (mounted) {
      setState(() {});
    }
  }

  void _updateReactionMap() {
    final allReactionEvents = widget.event
        .aggregatedEvents(widget.timeline, RelationshipTypes.reaction);
    final newReactionMap = <String, _ReactionEntry>{};
    for (final e in allReactionEvents) {
      final key = e.content
          .tryGetMap<String, dynamic>('m.relates_to')
          ?.tryGet<String>('key');
      if (key != null) {
        if (!newReactionMap.containsKey(key)) {
          newReactionMap[key] = _ReactionEntry(
            key: key,
            count: 0,
            reacted: false,
            reactors: [],
          );
        }
        newReactionMap[key]!.count++;
        newReactionMap[key]!.reactors!.add(e.senderFromMemoryOrFallback);
        newReactionMap[key]!.reacted |= e.senderId == client.userID;
      }
    }

    _reactionMap = newReactionMap;
  }

  @override
  void dispose() {
    _reactionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reactionList = _reactionMap.values.toList();
    reactionList.sort((a, b) => b.count - a.count > 0 ? 1 : -1);
    final ownMessage = widget.event.senderId == widget.event.room.client.userID;
    final allReactionEvents = widget.event
        .aggregatedEvents(widget.timeline, RelationshipTypes.reaction)
        .toList();

    //directionality handles wrap and loading position of own and other messages
    return Directionality(
      textDirection: ownMessage ? TextDirection.rtl : TextDirection.ltr,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 4.0,
        alignment: WrapAlignment.start,
        children: [
          ...reactionList.map(
            (r) => _Reaction(
              key: ValueKey(r.key),
              firstReact: _newlyAddedReactions.contains(r.key),
              reactionKey: r.key,
              count: r.count,
              reacted: r.reacted,
              onTap: () => _handleReactionTap(r, allReactionEvents),
              onLongPress: () async => await _AdaptableReactorsDialog(
                client: client,
                reactionEntry: r,
              ).show(context),
            ),
          ),
          if (allReactionEvents.any((e) => e.status.isSending))
            const SizedBox(
              width: 24,
              height: 24,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: CircularProgressIndicator.adaptive(strokeWidth: 1),
              ),
            ),
        ],
      ),
    );
  }

  void _handleReactionTap(
    _ReactionEntry reaction,
    List<Event> allReactionEvents,
  ) {
    if (reaction.reacted) {
      final evt = allReactionEvents.firstWhereOrNull(
        (e) =>
            e.senderId == e.room.client.userID &&
            e.content.tryGetMap('m.relates_to')?['key'] == reaction.key,
      );
      if (evt != null) {
        showFutureLoadingDialog(
          context: context,
          future: () => evt.redactEvent(),
        );
      }
    } else {
      widget.event.room.sendReaction(widget.event.eventId, reaction.key);
    }
  }
}

class _Reaction extends StatefulWidget {
  final String reactionKey;
  final int count;
  final bool? reacted;
  final bool firstReact;
  final Function()? onTap;
  final void Function()? onLongPress;

  const _Reaction({
    required super.key,
    required this.reactionKey,
    required this.count,
    required this.reacted,
    required this.firstReact,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_Reaction> createState() => _ReactionState();
}

class _ReactionState extends State<_Reaction> with TickerProviderStateMixin {
  late AnimationController _bounceOutController;
  late Animation<double> _bounceOutAnimation;
  late AnimationController _burstController;
  late Animation<double> _burstAnimation;
  late AnimationController _growController;
  late Animation<double> _growScale;
  late Animation<double> _growOffset;
  late AnimationController _feedbackBounceController;
  late Animation<double> _feedbackBounceAnimation;

  final List<BurstParticle> _burstParticles = [];
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _bounceOutController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bounceOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _bounceOutController,
        curve: Curves.easeInBack,
      ),
    );

    _burstController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _burstAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _burstController,
        curve: Curves.easeOutQuint,
      ),
    );

    _growController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _growScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 1.18)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.18, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_growController);
    _growOffset = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -10.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_growController);

    _feedbackBounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _feedbackBounceAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.65)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.65, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
    ]).animate(_feedbackBounceController);

    if (widget.firstReact) {
      _growController.forward();
    }
  }

  @override
  void dispose() {
    _bounceOutController.dispose();
    _burstController.dispose();
    _growController.dispose();
    _feedbackBounceController.dispose();
    super.dispose();
  }

  void resetState() {
    _bounceOutController.reset();
    _burstController.reset();
    _growController.reset();
    _feedbackBounceController.reset();
  }

  _animateAndReact() async {
    resetState();
    final wasReacted = widget.reacted;
    final wasSingle = (widget.count == 1);

    if (wasReacted == true) {
      if (wasSingle) {
        await _bounceOutController.forward();
        await _triggerBurstAnimation();
      } else {
        _triggerBurstAnimation();
        _feedbackBounceController.forward();
      }
    }

    //execute actual reaction event and wait to finish
    if (widget.onTap != null) {
      if (!wasReacted!) {
        await _growController.forward();
      }
      widget.onTap!();
    }
  }

  Future<void> _triggerBurstAnimation() async {
    _burstParticles.clear();
    final random = Random();
    for (int i = 0; i < 8; i++) {
      _burstParticles.add(
        BurstParticle(
          angle: (i * 45.0) + random.nextDouble() * 30 - 15,
          distance: 20 + random.nextDouble() * 30,
          scale: 0.6 + random.nextDouble() * 0.4,
          rotation: random.nextDouble() * 360,
        ),
      );
    }

    _burstController.reset();
    await _burstController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content;
    if (widget.reactionKey.startsWith('mxc://')) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MxcImage(
            uri: Uri.parse(widget.reactionKey),
            width: 20,
            height: 20,
            animated: false,
            isThumbnail: false,
          ),
          if (widget.count > 1) ...[
            const SizedBox(width: 4),
            Text(
              widget.count.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: DefaultTextStyle.of(context).style.fontSize,
              ),
            ),
          ],
        ],
      );
    } else {
      var renderKey = Characters(widget.reactionKey);
      if (renderKey.length > 10) {
        renderKey = renderKey.getRange(0, 9) + Characters('…');
      }
      content = Text(
        renderKey.toString() + (widget.count > 1 ? ' ${widget.count}' : ''),
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: DefaultTextStyle.of(context).style.fontSize,
        ),
      );
    }
    //Burst should continue/overflow after emoji shrinks away
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([
            _bounceOutAnimation,
            _growController,
            _feedbackBounceController
          ]),
          builder: (context, child) {
            final isGrowing = _growController.isAnimating ||
                (_growController.value > 0 && _growController.value < 1.0);
            final isBouncing = _bounceOutController.isAnimating;
            final isFeedbackBouncing = _feedbackBounceController.isAnimating;

            double scale;
            if (isGrowing) {
              scale = _growScale.value;
            } else if (isFeedbackBouncing) {
              scale = _feedbackBounceAnimation.value;
            } else {
              scale = _bounceOutAnimation.value;
            }

            final offsetY = isGrowing ? _growOffset.value : 0.0;

            return AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              child: Opacity(
                opacity: scale.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, offsetY),
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.center,
                    child: scale > 0.01
                        ? Padding(
                            padding: const EdgeInsets.only(left: 2, right: 2),
                            child: InkWell(
                              onTap: () async {
                                if (_isBusy ||
                                    isBouncing ||
                                    isGrowing ||
                                    isFeedbackBouncing) {
                                  return;
                                }
                                _isBusy = true;
                                try {
                                  await _animateAndReact();
                                } finally {
                                  if (mounted) setState(() => _isBusy = false);
                                }
                              },
                              onLongPress: () => widget.onLongPress != null
                                  ? widget.onLongPress!()
                                  : null,
                              borderRadius: BorderRadius.circular(
                                AppConfig.borderRadius / 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: widget.reacted == true
                                        ? theme.colorScheme.primaryContainer
                                        : theme
                                            .colorScheme.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius / 2,
                                    ),
                                    border: Border.all(
                                      color: widget.reacted == true
                                          ? theme.colorScheme.primary
                                          : theme
                                              .colorScheme.surfaceContainerHigh,
                                      width: 1,
                                    )),
                                padding: PlatformInfos.isIOS
                                    ? const EdgeInsets.fromLTRB(5.5, 1, 3, 2.5)
                                    : const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                child: content,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _burstAnimation,
          builder: (context, child) {
            if (_burstAnimation.value == 0.0) return const SizedBox.shrink();
            return Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: BurstPainter(
                      particles: _burstParticles,
                      progress: _burstAnimation.value,
                      particleColor: theme.colorScheme.primary),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ReactionEntry {
  String key;
  int count;
  bool reacted;
  List<User>? reactors;

  _ReactionEntry({
    required this.key,
    required this.count,
    required this.reacted,
    this.reactors,
  });
}

class _AdaptableReactorsDialog extends StatelessWidget {
  final Client? client;
  final _ReactionEntry? reactionEntry;

  const _AdaptableReactorsDialog({
    this.client,
    this.reactionEntry,
  });

  Future<bool?> show(BuildContext context) => showAdaptiveDialog(
        context: context,
        builder: (context) => this,
        barrierDismissible: true,
        useRootNavigator: false,
      );

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: <Widget>[
          for (final reactor in reactionEntry!.reactors!)
            Chip(
              avatar: Avatar(
                mxContent: reactor.avatarUrl,
                name: reactor.displayName,
                client: client,
                presenceUserId: reactor.stateKey,
              ),
              label: Text(reactor.displayName!),
            ),
        ],
      ),
    );

    final title = Center(child: Text(reactionEntry!.key));

    return AlertDialog.adaptive(
      title: title,
      content: body,
    );
  }
}

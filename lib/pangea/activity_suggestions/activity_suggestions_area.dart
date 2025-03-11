// shows n rows of activity suggestions vertically, where n is the number of rows
// as the user tries to scroll horizontally to the right, the client will fetch more activity suggestions

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_plan_search_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/create_chat_card.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivitySuggestionsArea extends StatefulWidget {
  const ActivitySuggestionsArea({super.key});

  @override
  ActivitySuggestionsAreaState createState() => ActivitySuggestionsAreaState();
}

class ActivitySuggestionsAreaState extends State<ActivitySuggestionsArea> {
  @override
  void initState() {
    super.initState();
    _setActivityItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ActivityPlanModel? selectedActivity;
  bool isEditing = false;
  Uint8List? avatar;
  final List<ActivityPlanModel> _activityItems = [];
  final ScrollController _scrollController = ScrollController();

  final double cardHeight = 275.0;
  final double cardWidth = 250.0;

  void _scrollToItem(int index) {
    final viewportDimension = _scrollController.position.viewportDimension;
    final double scrollOffset = FluffyThemes.isColumnMode(context)
        ? index * cardWidth - (viewportDimension / 2) + (cardWidth / 2)
        : (index + 1) * (cardHeight + 8.0);

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final safeOffset = scrollOffset.clamp(0.0, maxScrollExtent);

    if (safeOffset == _scrollController.offset) {
      return;
    }

    _scrollController.animateTo(
      safeOffset,
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
    );
  }

  Future<void> _setActivityItems() async {
    final ActivityPlanRequest request = ActivityPlanRequest(
      topic: "",
      mode: "",
      objective: "",
      media: MediaEnum.nan,
      cefrLevel: LanguageLevelTypeEnum.a1,
      languageOfInstructions: LanguageKeys.defaultLanguage,
      targetLanguage:
          MatrixState.pangeaController.languageController.userL2?.langCode ??
              LanguageKeys.defaultLanguage,
      numberOfParticipants: 3,
      count: 5,
    );
    final resp = await ActivitySearchRepo.get(request);
    _activityItems.addAll(resp.activityPlans);
    setState(() {});
  }

  void setSelectedActivity(ActivityPlanModel? activity) {
    selectedActivity = activity;
    isEditing = false;
    if (mounted) setState(() {});
  }

  void setEditting(bool editting) {
    if (selectedActivity == null) return;
    isEditing = editting;
    if (mounted) setState(() {});
  }

  void selectPhoto() async {
    final photo = await selectFiles(
      context,
      type: FileSelectorType.images,
      allowMultiple: false,
    );
    final bytes = await photo.singleOrNull?.readAsBytes();

    setState(() {
      avatar = bytes;
    });
  }

  void updateActivity(
    ActivityPlanModel Function(ActivityPlanModel) update,
  ) {
    if (selectedActivity == null) return;
    update(selectedActivity!);
    if (mounted) setState(() {});
  }

  Future<String?> _getAvatarURL(ActivityPlanModel activity) async {
    if (activity.imageURL == null && avatar == null) return null;
    try {
      if (avatar == null) {
        final Response response = await http.get(Uri.parse(activity.imageURL!));
        avatar = response.bodyBytes;
      }
      return (await Matrix.of(context).client.uploadContent(avatar!))
          .toString();
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          "imageURL": activity.imageURL,
        },
      );
    }
    return null;
  }

  Future<void> onLaunch(ActivityPlanModel activity) async {
    final client = Matrix.of(context).client;

    await showFutureLoadingDialog(
      context: context,
      future: () async {
        final avatarURL = await _getAvatarURL(activity);
        final roomId = await client.createGroupChat(
          preset: CreateRoomPreset.publicChat,
          visibility: sdk.Visibility.private,
          groupName: activity.title,
          initialState: [
            if (avatarURL != null)
              StateEvent(
                type: EventTypes.RoomAvatar,
                content: {'url': avatarURL.toString()},
              ),
            StateEvent(
              type: EventTypes.RoomPowerLevels,
              stateKey: '',
              content: defaultPowerLevels(client.userID!),
            ),
          ],
          enableEncryption: false,
        );

        Room? room = Matrix.of(context).client.getRoomById(roomId);
        if (room == null) {
          await client.waitForRoomInSync(roomId);
          room = Matrix.of(context).client.getRoomById(roomId);
          if (room == null) return;
        }

        final eventId = await room.pangeaSendTextEvent(
          activity.markdown,
          messageTag: ModelKey.messageTagActivityPlan,
        );

        if (eventId == null) {
          debugger(when: kDebugMode);
          return;
        }

        await room.setPinnedEvents([eventId]);
        context.go("/rooms/$roomId/invite");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = _activityItems
        .mapIndexed((i, activity) {
          return ActivitySuggestionCard(
            activity: activity,
            controller: this,
            onPressed: () {
              if (isEditing && selectedActivity == activity) {
                setEditting(false);
              } else if (selectedActivity == activity) {
                setSelectedActivity(null);
              } else {
                setSelectedActivity(activity);
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToItem(i);
              });
            },
            width: cardWidth,
            height: cardHeight,
          );
        })
        .cast<Widget>()
        .toList();

    cards.insert(
      0,
      CreateChatCard(
        width: cardWidth,
        height: cardHeight,
      ),
    );

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(16.0),
      child: FluffyThemes.isColumnMode(context)
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              itemBuilder: (context, index) => cards[index],
              controller: _scrollController,
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Wrap(
                children: cards,
              ),
            ),
    );
  }
}

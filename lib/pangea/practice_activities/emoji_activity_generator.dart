import 'package:fluffychat/pangea/constructs/construct_form.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_match.dart';

class EmojiActivityGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
  ) async {
    if (req.targetTokens.length <= 1) {
      throw Exception("Emoji activity requires at least 2 tokens");
    }

    return _matchActivity(req);
  }

  Future<MessageActivityResponse> _matchActivity(
    MessageActivityRequest req,
  ) async {
    final Map<ConstructForm, List<String>> matchInfo = {};
    final List<PangeaToken> missingEmojis = [];

    final List<String> usedEmojis = [];
    for (final token in req.targetTokens) {
      final List<String> userSavedEmojis = token.vocabConstructID.userSetEmoji;
      if (userSavedEmojis.isNotEmpty &&
          !usedEmojis.contains(userSavedEmojis.first)) {
        matchInfo[token.vocabForm] = [userSavedEmojis.first];
        usedEmojis.add(userSavedEmojis.first);
      } else {
        missingEmojis.add(token);
      }
    }

    final List<Future<LemmaInfoResponse>> lemmaInfoFutures = missingEmojis
        .map((token) => token.vocabConstructID.getLemmaInfo())
        .toList();

    final List<LemmaInfoResponse> lemmaInfos =
        await Future.wait(lemmaInfoFutures);

    for (int i = 0; i < missingEmojis.length; i++) {
      final e = lemmaInfos[i].emoji.firstWhere(
            (e) => !usedEmojis.contains(e),
            orElse: () => throw Exception(
              "Not enough unique emojis for tokens in message",
            ),
          );

      final token = missingEmojis[i];
      matchInfo[token.vocabForm] ??= [];
      matchInfo[token.vocabForm]!.add(e);
      usedEmojis.add(e);
    }

    return MessageActivityResponse(
      activity: PracticeActivityModel(
        activityType: ActivityTypeEnum.emoji,
        targetTokens: req.targetTokens,
        langCode: req.userL2,
        matchContent: PracticeMatchActivity(
          matchInfo: matchInfo,
        ),
      ),
    );
  }
}

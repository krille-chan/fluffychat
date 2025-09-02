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
    for (final token in req.targetTokens) {
      final List<String> userSavedEmojis = token.vocabConstructID.userSetEmoji;
      if (userSavedEmojis.isNotEmpty) {
        matchInfo[token.vocabForm] = [userSavedEmojis.first];
      } else {
        missingEmojis.add(token);
      }
    }

    final List<Future<LemmaInfoResponse>> lemmaInfoFutures = missingEmojis
        .map((token) => token.vocabConstructID.getLemmaInfo())
        .toList();

    final List<LemmaInfoResponse> lemmaInfos =
        await Future.wait(lemmaInfoFutures);

    for (int i = 0; i < req.targetTokens.length; i++) {
      final formKey = req.targetTokens[i].vocabForm;
      if (matchInfo[formKey] != null && matchInfo[formKey]!.isNotEmpty) {
        continue; // Skip if user has already set emojis
      }

      matchInfo[formKey] ??= [];
      matchInfo[formKey]!.add(lemmaInfos[i].emoji.first);
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

// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

class RobustPollAnswer {
  final String id;
  final String text;
  const RobustPollAnswer({required this.id, required this.text});
}

class RobustPollContent {
  final String question;
  final List<RobustPollAnswer> answers;
  final int maxSelections;
  final bool disclosed;

  const RobustPollContent({
    required this.question,
    required this.answers,
    required this.maxSelections,
    required this.disclosed,
  });
}

class RobustPollParser {
  static RobustPollContent? parseRobustPollContent(
    Map<String, dynamic> content,
  ) {
    final pollStartMap =
        content['m.poll'] ?? content['org.matrix.msc3381.poll.start'];
    if (pollStartMap is! Map) {
      return null;
    }

    final questionMap = pollStartMap['question'];
    var question = '';
    if (questionMap is Map) {
      final textObj =
          questionMap['m.text'] ??
          questionMap['org.matrix.msc1767.text'] ??
          questionMap['body'];
      question = extractText(textObj);
    }

    final answersList = pollStartMap['answers'];
    final answers = <RobustPollAnswer>[];
    if (answersList is List) {
      for (final answerObj in answersList) {
        if (answerObj is Map) {
          final id =
              answerObj['m.id']?.toString() ?? answerObj['id']?.toString();
          final textObj =
              answerObj['m.text'] ?? answerObj['org.matrix.msc1767.text'];
          final text = extractText(textObj);
          if (id != null && text.isNotEmpty) {
            answers.add(RobustPollAnswer(id: id, text: text));
          }
        }
      }
    }

    final maxSelections =
        pollStartMap['max_selections'] ?? pollStartMap['maxSelections'] ?? 1;

    final kind = pollStartMap['kind'];
    final disclosed =
        kind == 'm.disclosed' ||
        kind == 'org.matrix.msc3381.poll.disclosed' ||
        kind == 'disclosed' ||
        kind == null;

    return RobustPollContent(
      question: question,
      answers: answers,
      maxSelections: maxSelections is int ? maxSelections : 1,
      disclosed: disclosed,
    );
  }

  static String extractText(dynamic textObj) {
    if (textObj is String) return textObj;
    if (textObj is Map) {
      return textObj['body']?.toString() ??
          textObj['org.matrix.msc1767.text']?.toString() ??
          '';
    }
    if (textObj is List && textObj.isNotEmpty) {
      final first = textObj.first;
      if (first is Map) {
        return first['body']?.toString() ?? '';
      }
      if (first is String) return first;
    }
    return '';
  }
}

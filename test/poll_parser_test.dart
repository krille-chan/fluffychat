// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/robust_poll_parser.dart';
import 'package:test/test.dart';

void main() {
  group('RobustPollParser Tests', () {
    test('Parse unstable MSC3381 poll start event', () {
      final eventContent = <String, dynamic>{
        'org.matrix.msc1767.text': 'What should we order?\n1. Pizza\n2. Pasta',
        'org.matrix.msc3381.poll.start': {
          'question': {'org.matrix.msc1767.text': 'What should we order?'},
          'kind': 'org.matrix.msc3381.poll.disclosed',
          'max_selections': 2,
          'answers': [
            {'id': 'option_1', 'org.matrix.msc1767.text': 'Pizza'},
            {'id': 'option_2', 'org.matrix.msc1767.text': 'Pasta'},
          ],
        },
      };

      final poll = RobustPollParser.parseRobustPollContent(eventContent);
      expect(poll, isNotNull);
      expect(poll!.question, equals('What should we order?'));
      expect(poll.maxSelections, equals(2));
      expect(poll.disclosed, isTrue);
      expect(poll.answers.length, equals(2));
      expect(poll.answers[0].id, equals('option_1'));
      expect(poll.answers[0].text, equals('Pizza'));
      expect(poll.answers[1].id, equals('option_2'));
      expect(poll.answers[1].text, equals('Pasta'));
    });

    test('Parse stable Matrix v1.7 poll start event', () {
      final eventContent = <String, dynamic>{
        'm.text': 'What should we order?\n1. Pizza\n2. Pasta',
        'm.poll': {
          'question': {'m.text': 'What should we order?'},
          'kind': 'm.disclosed',
          'max_selections': 3,
          'answers': [
            {'m.id': 'opt_pizza', 'm.text': 'Pizza'},
            {'m.id': 'opt_pasta', 'm.text': 'Pasta'},
          ],
        },
      };

      final poll = RobustPollParser.parseRobustPollContent(eventContent);
      expect(poll, isNotNull);
      expect(poll!.question, equals('What should we order?'));
      expect(poll.maxSelections, equals(3));
      expect(poll.disclosed, isTrue);
      expect(poll.answers.length, equals(2));
      expect(poll.answers[0].id, equals('opt_pizza'));
      expect(poll.answers[0].text, equals('Pizza'));
      expect(poll.answers[1].id, equals('opt_pasta'));
      expect(poll.answers[1].text, equals('Pasta'));
    });

    test('Parse empty or invalid format returns null', () {
      final eventContent = <String, dynamic>{'body': 'Just a text message'};

      final poll = RobustPollParser.parseRobustPollContent(eventContent);
      expect(poll, isNull);
    });
  });
}

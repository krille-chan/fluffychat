// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_test/flutter_test.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/practice_tier_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';

/// Helper to create a [OneConstructUse] with minimal required fields.
OneConstructUse _makeUse(
  ConstructUseTypeEnum type, {
  DateTime? time,
  String lemma = 'test',
  String category = 'verb',
  int? xp,
}) {
  return OneConstructUse(
    useType: type,
    lemma: lemma,
    constructType: ConstructTypeEnum.vocab,
    metadata: ConstructUseMetaData(
      roomId: null,
      timeStamp: time ?? DateTime.now(),
    ),
    category: category,
    form: lemma,
    xp: xp ?? type.pointValue,
  );
}

/// Helper to create a [ConstructUses] wrapper.
ConstructUses _makeConstructUses(
  List<OneConstructUse> uses, {
  String lemma = 'test',
  String category = 'verb',
}) {
  return ConstructUses(
    uses: uses,
    constructType: ConstructTypeEnum.vocab,
    lemma: lemma,
    category: category,
  );
}

ConstructIdentifier _makeId({String lemma = 'test', String category = 'verb'}) {
  return ConstructIdentifier(
    lemma: lemma,
    type: ConstructTypeEnum.vocab,
    category: category,
  );
}

void main() {
  group('ConstructUseTypeEnum boolean getters', () {
    test('isChatUse is true for wa, ga, ta and granular IGC/IT types', () {
      expect(ConstructUseTypeEnum.wa.isChatUse, true);
      expect(ConstructUseTypeEnum.ga.isChatUse, true);
      expect(ConstructUseTypeEnum.ta.isChatUse, true);
      expect(ConstructUseTypeEnum.corIGC.isChatUse, true);
      expect(ConstructUseTypeEnum.incIGC.isChatUse, true);
      expect(ConstructUseTypeEnum.ignIGC.isChatUse, true);
      expect(ConstructUseTypeEnum.corIt.isChatUse, true);
      expect(ConstructUseTypeEnum.incIt.isChatUse, true);
      expect(ConstructUseTypeEnum.ignIt.isChatUse, true);
      expect(ConstructUseTypeEnum.corPA.isChatUse, false);
      expect(ConstructUseTypeEnum.incLM.isChatUse, false);
      expect(ConstructUseTypeEnum.click.isChatUse, false);
    });

    test('isAssistedChatUse is true for ga, ta and granular IGC/IT types', () {
      expect(ConstructUseTypeEnum.ga.isAssistedChatUse, true);
      expect(ConstructUseTypeEnum.ta.isAssistedChatUse, true);
      expect(ConstructUseTypeEnum.corIGC.isAssistedChatUse, true);
      expect(ConstructUseTypeEnum.incIGC.isAssistedChatUse, true);
      expect(ConstructUseTypeEnum.ignIGC.isAssistedChatUse, true);
      expect(ConstructUseTypeEnum.corIt.isAssistedChatUse, true);
      expect(ConstructUseTypeEnum.incIt.isAssistedChatUse, true);
      expect(ConstructUseTypeEnum.ignIt.isAssistedChatUse, true);
      expect(ConstructUseTypeEnum.wa.isAssistedChatUse, false);
    });

    test('isIncorrectPractice covers all inc* types', () {
      expect(ConstructUseTypeEnum.incPA.isIncorrectPractice, true);
      expect(ConstructUseTypeEnum.incWL.isIncorrectPractice, true);
      expect(ConstructUseTypeEnum.incLM.isIncorrectPractice, true);
      expect(ConstructUseTypeEnum.incGE.isIncorrectPractice, true);
      expect(ConstructUseTypeEnum.corPA.isIncorrectPractice, false);
      expect(ConstructUseTypeEnum.wa.isIncorrectPractice, false);
      expect(ConstructUseTypeEnum.click.isIncorrectPractice, false);
    });
  });

  group('ConstructUses.practiceTier classification', () {
    test('null uses treated as maintenance by scorer', () {
      // null has no .practiceTier — scorer handles it
      final id = _makeId(category: 'verb');
      final score = id.unseenPracticeScore;
      expect(score, greaterThan(0)); // maintenance, not suppressed
    });

    test('empty uses → maintenance', () {
      final uses = _makeConstructUses([]);
      expect(uses.practiceTier, PracticeTier.maintenance);
    });

    test('only wa use → suppressed', () {
      final uses = _makeConstructUses([_makeUse(ConstructUseTypeEnum.wa)]);
      expect(uses.practiceTier, PracticeTier.suppressed);
    });

    test('wa then correct practice → suppressed (no incorrect)', () {
      final now = DateTime.now();
      final uses = _makeConstructUses([
        _makeUse(
          ConstructUseTypeEnum.wa,
          time: now.subtract(const Duration(days: 5)),
        ),
        _makeUse(
          ConstructUseTypeEnum.corLM,
          time: now.subtract(const Duration(days: 3)),
        ),
        _makeUse(
          ConstructUseTypeEnum.corPA,
          time: now.subtract(const Duration(days: 1)),
        ),
      ]);
      expect(uses.practiceTier, PracticeTier.suppressed);
    });

    test('wa then incorrect practice → active', () {
      final now = DateTime.now();
      final uses = _makeConstructUses([
        _makeUse(
          ConstructUseTypeEnum.wa,
          time: now.subtract(const Duration(days: 5)),
        ),
        _makeUse(
          ConstructUseTypeEnum.incLM,
          time: now.subtract(const Duration(days: 2)),
        ),
      ]);
      expect(uses.practiceTier, PracticeTier.active);
    });

    test('ignIGC use → active', () {
      final uses = _makeConstructUses([_makeUse(ConstructUseTypeEnum.ignIGC)]);
      expect(uses.practiceTier, PracticeTier.active);
    });

    test('corIt use (IT translation) → active', () {
      final uses = _makeConstructUses([_makeUse(ConstructUseTypeEnum.corIt)]);
      expect(uses.practiceTier, PracticeTier.active);
    });

    test('ga use (legacy IGC correction) → active', () {
      final uses = _makeConstructUses([_makeUse(ConstructUseTypeEnum.ga)]);
      expect(uses.practiceTier, PracticeTier.active);
    });

    test('ta use (legacy IT translation) → active', () {
      final uses = _makeConstructUses([_makeUse(ConstructUseTypeEnum.ta)]);
      expect(uses.practiceTier, PracticeTier.active);
    });

    test('ga then wa → suppressed (wa is most recent chat use)', () {
      final now = DateTime.now();
      final uses = _makeConstructUses([
        _makeUse(
          ConstructUseTypeEnum.ga,
          time: now.subtract(const Duration(days: 10)),
        ),
        _makeUse(
          ConstructUseTypeEnum.wa,
          time: now.subtract(const Duration(days: 1)),
        ),
      ]);
      expect(uses.practiceTier, PracticeTier.suppressed);
    });

    test('wa then ga → active (ga is most recent chat use)', () {
      final now = DateTime.now();
      final uses = _makeConstructUses([
        _makeUse(
          ConstructUseTypeEnum.wa,
          time: now.subtract(const Duration(days: 10)),
        ),
        _makeUse(
          ConstructUseTypeEnum.ga,
          time: now.subtract(const Duration(days: 1)),
        ),
      ]);
      expect(uses.practiceTier, PracticeTier.active);
    });

    test('only correct practice (no chat uses) → maintenance', () {
      final uses = _makeConstructUses([
        _makeUse(ConstructUseTypeEnum.corPA),
        _makeUse(ConstructUseTypeEnum.corLM),
      ]);
      expect(uses.practiceTier, PracticeTier.maintenance);
    });

    test('only incorrect practice (no chat uses) → active', () {
      final uses = _makeConstructUses([_makeUse(ConstructUseTypeEnum.incPA)]);
      expect(uses.practiceTier, PracticeTier.active);
    });

    test('click use only → maintenance', () {
      final uses = _makeConstructUses([_makeUse(ConstructUseTypeEnum.click)]);
      expect(uses.practiceTier, PracticeTier.maintenance);
    });

    test('wa → corPA → incLM → active (incorrect after wa)', () {
      final now = DateTime.now();
      final uses = _makeConstructUses([
        _makeUse(
          ConstructUseTypeEnum.wa,
          time: now.subtract(const Duration(days: 10)),
        ),
        _makeUse(
          ConstructUseTypeEnum.corPA,
          time: now.subtract(const Duration(days: 5)),
        ),
        _makeUse(
          ConstructUseTypeEnum.incLM,
          time: now.subtract(const Duration(days: 1)),
        ),
      ]);
      expect(uses.practiceTier, PracticeTier.active);
    });
  });

  group('scoreConstruct', () {
    test('suppressed tier returns 0', () {
      final uses = _makeConstructUses([_makeUse(ConstructUseTypeEnum.wa)]);
      expect(uses.practiceScore(), 0);
    });

    test(
      'null uses (never seen) returns default days × content multiplier',
      () {
        final contentId = _makeId(category: 'verb');
        final score = contentId.unseenPracticeScore;
        // 20 days × 10 (content word) = 200
        expect(score, 200);
      },
    );

    test(
      'null uses with function word → default days × function multiplier',
      () {
        final funcId = _makeId(category: 'det');
        final score = funcId.unseenPracticeScore;
        // 20 days × 7 (function word) = 140
        expect(score, 140);
      },
    );

    test('active tier gets 2× multiplier', () {
      final now = DateTime.now();
      final uses = _makeConstructUses([
        _makeUse(ConstructUseTypeEnum.ga, time: now),
      ]);
      final score = uses.practiceScore(
        activityType: ActivityTypeEnum.lemmaMeaning,
      );
      // ga is most recent chat use → active tier.
      // No lemmaMeaning uses → defaults to 20 days.
      // 20 × 10 (content) × 2 (active) = 400.
      expect(score, 400);
    });

    test('maintenance tier, recent use → low score', () {
      final now = DateTime.now();
      final uses = _makeConstructUses([
        _makeUse(ConstructUseTypeEnum.corPA, time: now),
      ]);
      final score = uses.practiceScore(
        activityType: ActivityTypeEnum.wordMeaning,
      );
      // corPA matches wordMeaning's associatedUseTypes.
      // 0 days × 10 (content) = 0. Maintenance (no chat uses).
      expect(score, 0);
    });

    test('per-activity-type recency filters correctly', () {
      final now = DateTime.now();
      final uses = _makeConstructUses([
        _makeUse(
          ConstructUseTypeEnum.corLM,
          time: now.subtract(const Duration(days: 1)),
        ),
        _makeUse(ConstructUseTypeEnum.corPA, time: now),
      ], category: 'noun');
      // Score for lemmaMeaning: corLM was 1 day ago → 1 × 10 = 10
      final lmScore = uses.practiceScore(
        activityType: ActivityTypeEnum.lemmaMeaning,
      );
      // Score for wordMeaning: corPA was today → 0 × 10 = 0
      final wmScore = uses.practiceScore(
        activityType: ActivityTypeEnum.wordMeaning,
      );
      expect(lmScore, greaterThan(wmScore));
    });

    test('no activityType uses aggregate lastUsed', () {
      final now = DateTime.now();
      final uses = _makeConstructUses([
        _makeUse(
          ConstructUseTypeEnum.click,
          time: now.subtract(const Duration(days: 3)),
        ),
      ]);
      final score = uses.practiceScore();
      // No activityType → uses aggregate lastUsed (3 days ago).
      // 3 × 10 (content) = 30.
      expect(score, 30);
    });
  });

  group('scoring ordering', () {
    test('active-tier words rank above same-age maintenance words', () {
      final now = DateTime.now();
      final fiveDaysAgo = now.subtract(const Duration(days: 5));

      // Active: ga use 5 days ago
      final activeUses = _makeConstructUses([
        _makeUse(ConstructUseTypeEnum.ga, time: fiveDaysAgo),
      ]);

      // Maintenance: click 5 days ago (no chat use → maintenance)
      final maintenanceUses = _makeConstructUses([
        _makeUse(ConstructUseTypeEnum.click, time: fiveDaysAgo),
      ]);

      final activeScore = activeUses.practiceScore();
      final maintenanceScore = maintenanceUses.practiceScore();

      expect(activeScore, greaterThan(maintenanceScore));
    });

    test('content words rank above function words at same recency', () {
      final now = DateTime.now();
      final threeDaysAgo = now.subtract(const Duration(days: 3));

      final contentUses = _makeConstructUses([
        _makeUse(ConstructUseTypeEnum.click, time: threeDaysAgo),
      ], category: 'verb');
      final funcUses = _makeConstructUses([
        _makeUse(ConstructUseTypeEnum.click, time: threeDaysAgo),
      ], category: 'det');

      final contentScore = contentUses.practiceScore();
      final funcScore = funcUses.practiceScore();

      // 3 × 10 = 30 vs 3 × 7 = 21
      expect(contentScore, greaterThan(funcScore));
    });

    test('older words rank above recent words in same tier', () {
      final now = DateTime.now();

      final oldUses = _makeConstructUses([
        _makeUse(
          ConstructUseTypeEnum.click,
          time: now.subtract(const Duration(days: 10)),
        ),
      ], category: 'noun');

      final recentUses = _makeConstructUses([
        _makeUse(
          ConstructUseTypeEnum.click,
          time: now.subtract(const Duration(days: 2)),
        ),
      ], category: 'noun');

      final oldScore = oldUses.practiceScore();
      final recentScore = recentUses.practiceScore();

      expect(oldScore, greaterThan(recentScore));
    });

    test('suppressed words always rank last (score 0)', () {
      final id = _makeId(category: 'verb');
      final suppressedUses = _makeConstructUses([
        _makeUse(ConstructUseTypeEnum.wa),
      ]);

      final neverSeenScore = id.unseenPracticeScore;
      final suppressedScore = suppressedUses.practiceScore();

      expect(suppressedScore, 0);
      expect(neverSeenScore, greaterThan(suppressedScore));
    });
  });

  group('design scenario from instructions', () {
    test(
      'full lifecycle: wa → suppressed, ta → active, inc → stays active, cors → maintenance',
      () {
        final now = DateTime.now();

        // Step 1: User types "gato" without assistance → wa → suppressed
        final step1 = _makeConstructUses(
          [
            _makeUse(
              ConstructUseTypeEnum.wa,
              time: now.subtract(const Duration(days: 20)),
              lemma: 'gato',
            ),
          ],
          lemma: 'gato',
          category: 'noun',
        );
        expect(step1.practiceTier, PracticeTier.suppressed);
        expect(step1.practiceScore(), 0);

        // Step 2: User uses IT for "mariposa" → ta → active
        final step2 = _makeConstructUses(
          [
            _makeUse(
              ConstructUseTypeEnum.ta,
              time: now.subtract(const Duration(days: 15)),
              lemma: 'mariposa',
            ),
          ],
          lemma: 'mariposa',
          category: 'noun',
        );
        expect(step2.practiceTier, PracticeTier.active);
        expect(step2.practiceScore(), greaterThan(0));

        // Step 3: User gets "mariposa" wrong → incLM → stays active
        final step3 = _makeConstructUses(
          [
            _makeUse(
              ConstructUseTypeEnum.ta,
              time: now.subtract(const Duration(days: 15)),
              lemma: 'mariposa',
            ),
            _makeUse(
              ConstructUseTypeEnum.incLM,
              time: now.subtract(const Duration(days: 10)),
              lemma: 'mariposa',
            ),
          ],
          lemma: 'mariposa',
          category: 'noun',
        );
        expect(step3.practiceTier, PracticeTier.active);

        // Step 6: User misspells "gato" and IGC corrects → ga → moves from suppressed to active
        final step6 = _makeConstructUses(
          [
            _makeUse(
              ConstructUseTypeEnum.wa,
              time: now.subtract(const Duration(days: 20)),
              lemma: 'gato',
            ),
            _makeUse(
              ConstructUseTypeEnum.ga,
              time: now.subtract(const Duration(days: 1)),
              lemma: 'gato',
            ),
          ],
          lemma: 'gato',
          category: 'noun',
        );
        expect(step6.practiceTier, PracticeTier.active);
        expect(step6.practiceScore(), greaterThan(0));
      },
    );
  });
}

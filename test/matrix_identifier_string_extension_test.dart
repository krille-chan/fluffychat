import 'package:flutter_test/flutter_test.dart';
import 'package:fluffychat/utils/matrix_identifier_string_extension.dart';

void main() {
  group('Matrix Identifier String Extension', () {
    test('parseIdentifierIntoParts', () {
      var res = '#alias:beep'.parseIdentifierIntoParts();
      expect(res.roomIdOrAlias, '#alias:beep');
      expect(res.eventId, null);
      expect(res.queryString, null);
      res = 'blha'.parseIdentifierIntoParts();
      expect(res, null);
      res = '#alias:beep/\$event'.parseIdentifierIntoParts();
      expect(res.roomIdOrAlias, '#alias:beep');
      expect(res.eventId, '\$event');
      expect(res.queryString, null);
      res = '#alias:beep?blubb'.parseIdentifierIntoParts();
      expect(res.roomIdOrAlias, '#alias:beep');
      expect(res.eventId, null);
      expect(res.queryString, 'blubb');
      res = '#alias:beep/\$event?blubb'.parseIdentifierIntoParts();
      expect(res.roomIdOrAlias, '#alias:beep');
      expect(res.eventId, '\$event');
      expect(res.queryString, 'blubb');
      res = '#/\$?:beep/\$event?blubb?b'.parseIdentifierIntoParts();
      expect(res.roomIdOrAlias, '#/\$?:beep');
      expect(res.eventId, '\$event');
      expect(res.queryString, 'blubb?b');
    });
  });
}

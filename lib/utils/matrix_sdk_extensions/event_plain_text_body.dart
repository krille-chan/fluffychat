import 'package:html/parser.dart' as html_parser;
import 'package:matrix/matrix.dart';

extension PlainTextBody on Event {
  /// Whether the effective content (considering edits) has HTML formatted_body.
  bool _effectiveContentHasHtml({required bool hideEdit}) {
    final newContent = content.tryGetMap<String, Object?>('m.new_content');
    if (hideEdit &&
        relationshipType == RelationshipTypes.edit &&
        newContent != null) {
      return newContent['format'] == 'org.matrix.custom.html' &&
          (newContent.tryGet<String>('formatted_body') ?? '').isNotEmpty;
    }
    return content['format'] == 'org.matrix.custom.html' &&
        formattedText.isNotEmpty;
  }

  /// Extract plain text directly from the effective HTML content,
  /// bypassing the SDK's markdown round-trip that corrupts escaped characters.
  String _plainTextFromHtml({
    required bool hideEdit,
    required bool hideReply,
  }) {
    String html;
    final newContent = content.tryGetMap<String, Object?>('m.new_content');
    if (hideEdit &&
        relationshipType == RelationshipTypes.edit &&
        newContent != null) {
      html = newContent.tryGet<String>('formatted_body') ?? '';
    } else {
      html = formattedText;
    }

    if (hideReply) {
      html = html.replaceAll(
        RegExp(
          '<mx-reply>.*</mx-reply>',
          caseSensitive: false,
          multiLine: false,
          dotAll: true,
        ),
        '',
      );
    }

    return html_parser.parseFragment(html).text?.trim() ?? body;
  }

  /// Like [calcLocalizedBodyFallback] with `plaintextBody: true` and
  /// `removeMarkdown: true`, but avoids the SDK's double-processing bug
  /// where HTML→plaintext→markdown→plaintext corrupts escaped characters.
  String calcLocalizedBodyFallbackFixed(
    MatrixLocalizations i18n, {
    bool withSenderNamePrefix = false,
    bool hideReply = false,
    bool hideEdit = false,
  }) {
    if (redacted) {
      return calcLocalizedBodyFallback(
        i18n,
        withSenderNamePrefix: withSenderNamePrefix,
        hideReply: hideReply,
        hideEdit: hideEdit,
        plaintextBody: true,
        removeMarkdown: true,
      );
    }

    final isTextMessage = type == EventTypes.Message &&
        Event.textOnlyMessageTypes.contains(messageType);

    if (isTextMessage && _effectiveContentHasHtml(hideEdit: hideEdit)) {
      var plainText = _plainTextFromHtml(
        hideEdit: hideEdit,
        hideReply: hideReply,
      );

      if (messageType == MessageTypes.Emote) {
        plainText = '* $plainText';
      }

      if (withSenderNamePrefix) {
        final senderNameOrYou = senderId == room.client.userID
            ? i18n.you
            : senderFromMemoryOrFallback.calcDisplayname(i18n: i18n);
        plainText = '$senderNameOrYou: $plainText';
      }

      return plainText;
    }

    return calcLocalizedBodyFallback(
      i18n,
      withSenderNamePrefix: withSenderNamePrefix,
      hideReply: hideReply,
      hideEdit: hideEdit,
      plaintextBody: true,
      removeMarkdown: true,
    );
  }

  /// Like [calcLocalizedBody] with `plaintextBody: true` and
  /// `removeMarkdown: true`, but avoids the SDK's double-processing bug.
  Future<String> calcLocalizedBodyFixed(
    MatrixLocalizations i18n, {
    bool withSenderNamePrefix = false,
    bool hideReply = false,
    bool hideEdit = false,
  }) async {
    if (redacted) {
      await redactedBecause?.fetchSenderUser();
    }

    if (withSenderNamePrefix &&
        (type == EventTypes.Message || type.contains(EventTypes.Encrypted))) {
      await fetchSenderUser();
    }

    return calcLocalizedBodyFallbackFixed(
      i18n,
      withSenderNamePrefix: withSenderNamePrefix,
      hideReply: hideReply,
      hideEdit: hideEdit,
    );
  }
}

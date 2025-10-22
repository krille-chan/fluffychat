import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/widgets/igc/autocorrect_popup.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AutocorrectSpan extends WidgetSpan {
  AutocorrectSpan({
    required String transformTargetId,
    required String currentText,
    required String originalText,
    required VoidCallback onUndo,
    required TextStyle style,
  }) : super(
          alignment: PlaceholderAlignment.middle,
          child: CompositedTransformTarget(
            link: MatrixState.pAnyState.layerLinkAndKey(transformTargetId).link,
            child: Builder(
              builder: (context) {
                return RichText(
                  key: MatrixState.pAnyState
                      .layerLinkAndKey(transformTargetId)
                      .key,
                  text: TextSpan(
                    text: currentText,
                    style: style,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        OverlayUtil.showOverlay(
                          context: context,
                          child: AutocorrectPopup(
                            originalText: originalText,
                            onUndo: onUndo,
                          ),
                          transformTargetId: transformTargetId,
                        );
                      },
                  ),
                );
              },
            ),
          ),
        );
}

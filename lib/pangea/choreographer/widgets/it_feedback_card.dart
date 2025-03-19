import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/analytics_misc/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/choreographer/repo/full_text_translation_repo.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import '../../../widgets/matrix.dart';
import '../../bot/utils/bot_style.dart';
import '../../common/controllers/pangea_controller.dart';
import '../controllers/it_feedback_controller.dart';
import 'igc/card_error_widget.dart';

class ITFeedbackCard extends StatefulWidget {
  final ITFeedbackRequestModel req;
  final String choiceFeedback;

  const ITFeedbackCard({
    super.key,
    required this.req,
    required this.choiceFeedback,
  });

  @override
  State<ITFeedbackCard> createState() => ITFeedbackCardController();
}

class ITFeedbackCardController extends State<ITFeedbackCard> {
  final PangeaController controller = MatrixState.pangeaController;

  Object? error;
  bool isLoadingFeedback = false;
  bool isTranslating = false;
  ITFeedbackResponseModel? res;
  String? translatedFeedback;

  Response get noLanguages => Response("", 405);

  @override
  void initState() {
    if (!mounted) return;
    //any setup?
    super.initState();
    getFeedback();
  }

  Future<void> getFeedback() async {
    setState(() {
      isLoadingFeedback = true;
    });

    try {
      final resp = await FullTextTranslationRepo.translate(
        accessToken: controller.userController.accessToken,
        request: FullTextTranslationRequestModel(
          text: widget.req.chosenContinuance,
          tgtLang: controller.languageController.userL1?.langCode ??
              widget.req.sourceTextLang,
          userL1: controller.languageController.userL1?.langCode ??
              widget.req.sourceTextLang,
          userL2: controller.languageController.userL2?.langCode ??
              widget.req.targetLang,
        ),
      );
      res = ITFeedbackResponseModel(text: resp.bestTranslation);
    } catch (e, s) {
      error = e;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "req": widget.req.toJson(),
          "choiceFeedback": widget.choiceFeedback,
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoadingFeedback = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => error == null
      ? ITFeedbackCardView(controller: this)
      : CardErrorWidget(error: error!);
}

class ITFeedbackCardView extends StatelessWidget {
  const ITFeedbackCardView({
    super.key,
    required this.controller,
  });

  final ITFeedbackCardController controller;

  @override
  Widget build(BuildContext context) {
    const characterWidth = 10.0;

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            controller.widget.req.chosenContinuance,
            style: BotStyle.text(context),
          ),
          const SizedBox(width: 10),
          Text(
            "≈",
            style: BotStyle.text(context),
          ),
          const SizedBox(width: 10),
          controller.res?.text != null
              ? Text(
                  controller.res!.text,
                  style: BotStyle.text(context),
                )
              : TextLoadingShimmer(
                  width: min(
                    140,
                    characterWidth *
                        controller.widget.req.chosenContinuance.length,
                  ),
                ),
        ],
      ),
    );
  }
}

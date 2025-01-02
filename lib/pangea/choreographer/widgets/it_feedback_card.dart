import 'package:fluffychat/pangea/repo/full_text_translation_repo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../config/app_config.dart';
import '../../../widgets/matrix.dart';
import '../../controllers/it_feedback_controller.dart';
import '../../controllers/pangea_controller.dart';
import '../../utils/bot_style.dart';
import '../../widgets/igc/card_error_widget.dart';

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

    FullTextTranslationRepo.translate(
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
    )
        .then((translationResponse) {
          res = ITFeedbackResponseModel(
            text: translationResponse.bestTranslation,
          );
        })
        .catchError((e) => error = e)
        .whenComplete(
          () => setState(() {
            // isTranslating = false;
            isLoadingFeedback = false;
          }),
        );
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
    final ScrollController scrollController = ScrollController();

    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              controller.widget.req.chosenContinuance,
            ),
            const SizedBox(height: 10),
            Text(
              "≈",
              style: TextStyle(
                fontSize:
                    AppConfig.fontSizeFactor * AppConfig.messageFontSize * 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                minHeight: 30,
              ),
              child: Text(
                controller.res?.text ?? "loading",
                style: BotStyle.text(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

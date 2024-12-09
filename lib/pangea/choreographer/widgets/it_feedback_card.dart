import 'package:fluffychat/pangea/repo/full_text_translation_repo.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/igc/why_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../config/app_config.dart';
import '../../../widgets/matrix.dart';
import '../../controllers/it_feedback_controller.dart';
import '../../controllers/pangea_controller.dart';
import '../../utils/bot_style.dart';
import '../../widgets/common/bot_face_svg.dart';
import '../../widgets/igc/card_error_widget.dart';
import '../../widgets/igc/card_header.dart';

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
  }

  Future<void> getFeedback() async {
    setState(() {
      isLoadingFeedback = true;
    });
    controller.itFeedback
        .get(widget.req)
        .then((value) {
          res = value;
        })
        .catchError((e) => error = e)
        .whenComplete(
          () => setState(() {
            isLoadingFeedback = false;
          }),
        );
  }

  Future<void> translateFeedback() async {
    if (res == null) {
      ErrorHandler.logError(
        m: "Cannot translate feedback because res is null",
      );
      return;
    }
    setState(() {
      isTranslating = true;
    });
    FullTextTranslationRepo.translate(
      accessToken: controller.userController.accessToken,
      request: FullTextTranslationRequestModel(
        text: res!.text,
        tgtLang: controller.languageController.userL1?.langCode ??
            widget.req.sourceTextLang,
        userL1: controller.languageController.userL1?.langCode ??
            widget.req.sourceTextLang,
        userL2: controller.languageController.userL2?.langCode ??
            widget.req.targetLang,
      ),
    )
        .then((value) {
          translatedFeedback = value.bestTranslation;
        })
        .catchError((e) => error = e)
        .whenComplete(
          () => setState(() {
            isTranslating = false;
          }),
        );
  }

  void handleGetExplanationButtonPress() {
    if (isLoadingFeedback) return;
    getFeedback();
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
            CardHeader(
              text: controller.widget.req.chosenContinuance,
              botExpression: BotExpression.nonGold,
            ),
            // Text(
            //   controller.widget.choiceFeedback,
            //   style: BotStyle.text(context),
            // ),
            const SizedBox(height: 10),
            if (controller.res == null)
              WhyButton(
                onPress: controller.handleGetExplanationButtonPress,
                loading: controller.isLoadingFeedback,
              ),
            if (controller.res != null)
              Text(
                controller.res!.text,
                style: BotStyle.text(context),
              ),
            // if res is not null and feedback not in the userL1, show a button to translate the text
            if (controller.res != null &&
                controller.translatedFeedback == null &&
                controller.widget.req.feedbackLang !=
                    controller.controller.languageController.userL1?.langCode)
              Column(
                children: [
                  const SizedBox(height: 10),
                  TranslateButton(
                    onPress: controller.translateFeedback,
                    loading: controller.isTranslating,
                  ),
                ],
              ),
            if (controller.translatedFeedback != null)
              //add little line to separate the text from the translation
              Column(
                children: [
                  const Divider(
                    color: AppConfig.primaryColor,
                    thickness: 2,
                    height: 20, // Set the space around the divider
                    indent: 20, // Set the starting space (left padding)
                    endIndent: 20, // Set the ending space (right padding)
                  ),
                  Text(
                    controller.translatedFeedback!,
                    style: BotStyle.text(context),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// button to translate the text
class TranslateButton extends StatelessWidget {
  const TranslateButton({
    super.key,
    required this.onPress,
    required this.loading,
  });

  final VoidCallback onPress;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loading ? null : onPress,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          AppConfig.primaryColor.withOpacity(0.1),
        ),
      ),
      child: SizedBox(
        width: 150, // set the width of the button contents here
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!loading) const Icon(Icons.translate),
            if (loading)
              const Center(
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            // const SizedBox(width: 8),
            // Text(L10n.of(context).translate),
          ],
        ),
      ),
    );
  }
}

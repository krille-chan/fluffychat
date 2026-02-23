import 'package:fluffychat/pangea/analytics_data/analytics_data_service.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AnalyticsPracticeAnalyticsController {
  final AnalyticsDataService analyticsService;

  const AnalyticsPracticeAnalyticsController(this.analyticsService);

  Future<double> levelProgress(String language) async {
    final derviedData = await analyticsService.derivedData(language);
    return derviedData.levelProgress;
  }

  Future<void> addCompletedActivityAnalytics(
    List<OneConstructUse> uses,
    String targetId,
    String language,
  ) => analyticsService.updateService.addAnalytics(targetId, uses, language);

  Future<void> addSkippedActivityAnalytics(
    PracticeTarget target,
    String language,
  ) async {
    final uses = target.tokens
        .map(
          (t) => OneConstructUse(
            useType: ConstructUseTypeEnum.ignPA,
            constructType: target.activityType.constructUsesType,
            metadata: ConstructUseMetaData(
              roomId: null,
              timeStamp: DateTime.now(),
            ),
            category: t.pos,
            lemma: t.lemma.text,
            form: t.lemma.text,
            xp: 0,
          ),
        )
        .toList();
    await analyticsService.updateService.addAnalytics(null, uses, language);
  }

  Future<void> addSessionAnalytics(
    List<OneConstructUse> uses,
    String language,
  ) async {
    await analyticsService.updateService.addAnalytics(
      null,
      uses,
      language,
      forceUpdate: true,
    );
  }

  Future<ConstructUses> getTargetTokenConstruct(
    PracticeTarget target,
    String language,
  ) async {
    final token = target.tokens.first;
    final construct = target.targetTokenConstructID(token);
    return analyticsService.getConstructUse(construct, language);
  }

  Future<void> waitForAnalytics() async {
    if (!analyticsService.initCompleter.isCompleted) {
      MatrixState.pangeaController.initControllers();
      await analyticsService.initCompleter.future;
    }
  }

  Future<void> waitForUpdate() => analyticsService
      .updateDispatcher
      .constructUpdateStream
      .stream
      .first
      .timeout(const Duration(seconds: 10));
}

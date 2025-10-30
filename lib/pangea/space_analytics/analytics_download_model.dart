import 'package:fluffychat/pangea/analytics_downloads/space_analytics_summary_model.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics_download_enum.dart';

class AnalyticsDownload {
  RequestStatus requestStatus;
  DownloadStatus downloadStatus;
  SpaceAnalyticsSummaryModel? summary;

  AnalyticsDownload({
    required this.requestStatus,
    required this.downloadStatus,
    this.summary,
  });
}

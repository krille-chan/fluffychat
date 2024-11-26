import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static bool get itIsTime =>
      DateTime.utc(2023, 1, 25).isBefore(DateTime.now());

  static String get fileName {
    return ".env";
  }

  static bool get isStaging => synapsURL.contains("staging");

  static String get baseAPI {
    return dotenv.env["BASE_API"] ?? 'BASE API not found';
  }

  static String get frontendURL {
    return dotenv.env["FRONTEND_URL"] ?? "Frontend URL NOT FOUND";
  }

  static String get synapsURL {
    return dotenv.env['SYNAPSE_URL'] ?? 'Synapse Url not found';
  }

  static String get homeServer {
    return dotenv.env["HOME_SERVER"] ?? 'Home Server not found';
  }

  static String get choreoApi {
    return dotenv.env['CHOREO_API'] ?? 'Not found';
  }

  static String get choreoApiKey {
    return dotenv.env['CHOREO_API_KEY'] ??
        'e6fa9fa97031ba0c852efe78457922f278a2fbc109752fe18e465337699e9873';
  }

  static String get sentryDsn {
    return dotenv.env["SENTRY_DSN"] ??
        'https://c2fd19ab2cdc4ebb939a32d01c0e9fa1@o225078.ingest.sentry.io/1376295';
  }

  static String get rcProjectId {
    return dotenv.env["RC_PROJECT"] ?? 'a499dc21';
  }

  static String get rcKey {
    return dotenv.env["RC_KEY"] ?? 'sk_eVGBdPyInaOfJrKlPBgFVnRynqKJB';
  }

  static String get rcGoogleKey {
    return dotenv.env["RC_GOOGLE_KEY"] ?? 'goog_paQMrzFKGzuWZvcMTPkkvIsifJe';
  }

  static String get rcIosKey {
    return dotenv.env["RC_IOS_KEY"] ?? 'appl_DUPqnxuLjkBLzhBPTWeDjqNENuv';
  }

  // This is a public key
  static String get rcStripeKey {
    return dotenv.env["RC_STRIPE_KEY"] ?? 'strp_YWZxWUeEfvagiefDNoofinaRCOl';
  }

  static String get rcOfferingName {
    return dotenv.env["RC_OFFERING_NAME"] ?? 'default';
  }

  static String get stripeManagementUrl {
    return dotenv.env["STRIPE_MANAGEMENT_LINK"] ??
        'https://billing.stripe.com/p/login/dR6dSkf5p6rBc4EcMM';
  }

  static String get supportSpaceId {
    return dotenv.env["SUPPORT_SPACE_ID"] ??
        '!gqSNSkvwTpgumyjLsV:staging.pangea.chat';
  }

  static String get supportUserId {
    return isStaging ? '@support:staging.pangea.chat' : '@support:pangea.chat';
  }
}

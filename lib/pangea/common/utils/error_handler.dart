import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class PangeaWarningError implements Exception {
  final String message;
  PangeaWarningError(message) : message = "Pangea Warning Error: $message";

  @override
  String toString() => message;
}

class ErrorHandler {
  ErrorHandler();

  static Future<void> initialize() async {
    await SentryFlutter.init(
      (options) {
        options.dsn = Environment.sentryDsn;
        options.tracesSampleRate = 0.1;
        options.debug = kDebugMode;
        options.environment = kDebugMode
            ? "debug"
            : Environment.isStagingEnvironment
                ? "staging"
                : "productionC";
      },
    );

    // Error handling
    FlutterError.onError = (FlutterErrorDetails details) async {
      if (!kDebugMode || PlatformInfos.isMobile) {
        Sentry.captureException(
          details.exception,
          stackTrace: details.stack ?? StackTrace.current,
        );
      }
    };

    PlatformDispatcher.instance.onError = (exception, stack) {
      logError(
        e: exception,
        s: stack,
        data: {},
      );
      return true;
    };
  }

  static logError({
    Object? e,
    StackTrace? s,
    String? m,
    required Map<String, dynamic> data,
    SentryLevel level = SentryLevel.error,
  }) async {
    if (e is PangeaWarningError) {
      // Custom handling for PangeaWarningError
      debugPrint("PangeaWarningError: ${e.message}");
    } else {
      debugPrint("error message: ${m ?? e}");
    }

    Sentry.addBreadcrumb(Breadcrumb(data: data));
    debugPrint(data.toString());

    Sentry.captureException(
      e ?? Exception(m ?? "no message supplied"),
      stackTrace: s ?? StackTrace.current,
      withScope: (scope) {
        scope.level = level;
      },
    );
  }
}

class ErrorCopy {
  BuildContext context;
  Object? error;

  late String title;
  late String body;
  int? errorCode;

  ErrorCopy(this.context, this.error) {
    setCopy();
  }

  void _setDefaults() {
    title = "Unexpected error.";
    body = "Please reload and try again.";
    errorCode = 400;
  }

  void setCopy() {
    try {
      if (error is http.Response) {
        errorCode = (error as http.Response).statusCode;
      } else {
        ErrorHandler.logError(
          e: error,
          s: StackTrace.current,
          data: {},
        );
        errorCode = null;
      }
      final L10n l10n = L10n.of(context);

      switch (errorCode) {
        case 502:
        case 504:
        case 500:
          title = l10n.error502504Title;
          body = l10n.error502504Desc;
          break;
        case 520:
          title = l10n.error520Title;
          body = l10n.error520Desc;
          break;
        case 404:
          title = l10n.error404Title;
          body = l10n.error404Desc;
          break;
        case 405:
          title = l10n.error405Title;
          body = l10n.error405Desc;
          break;
        case 601:
          title = l10n.errorDisableIT;
          body = l10n.errorDisableITUserDesc;
          break;
        case 602:
          title = l10n.errorDisableIGC;
          body = l10n.errorDisableIGCUserDesc;
          break;
        case 603:
          title = l10n.errorDisableIT;
          body = l10n.errorDisableITClassDesc;
          break;
        case 604:
          title = l10n.errorDisableIGC;
          body = l10n.errorDisableIGCClassDesc;
          break;
        default:
          title = l10n.oopsSomethingWentWrong;
          body = l10n.errorPleaseRefresh;
      }
    } catch (e, s) {
      ErrorHandler.logError(
        e: s,
        s: s,
        data: {},
      );
      _setDefaults();
    }
  }
}

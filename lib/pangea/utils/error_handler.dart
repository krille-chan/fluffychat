import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/config/environment.dart';

class ErrorHandler {
  ErrorHandler();

  static Future<void> initialize() async {
    FutureOr<void> Function(Scope)? withScope(
      Scope scope,
      FlutterErrorDetails details,
    ) {
      // if (details.exception is http.Response) {
      //   final res = details.exception as http.Response;
      //   scope.addBreadcrumb(
      //     Breadcrumb.http(
      //       url: res.request?.url ?? Uri(path: "not available"),
      //       method: "where does method go?",
      //       statusCode: res.statusCode,
      //     ),
      //   );
      // } else {
      //   debugPrint("not an http exception ${details.exception.toString()}");
      // }
      return null;
    }

    await SentryFlutter.init(
      (options) {
        options.dsn = Environment.sentryDsn;
        options.tracesSampleRate = 0.1;
        options.debug = kDebugMode;
        options.environment = Environment.isStaging ? "staging" : "productionC";
        // options.beforeSend = (event, {hint}) {
        //   debugger(when: kDebugMode);
        //   return null;
        // };
      },
    );

    // Error handling
    FlutterError.onError = (FlutterErrorDetails details) async {
      if (!kDebugMode) {
        Sentry.captureException(
          details.exception,
          stackTrace: details.stack ?? StackTrace.current,
          withScope: (scope) => withScope(scope, details),
        );
      }
    };

    PlatformDispatcher.instance.onError = (exception, stack) {
      logError(e: exception, s: stack);
      return true;
    };
  }

  static logError({
    Object? e,
    StackTrace? s,
    String? m,
    Map<String, dynamic>? data,
  }) async {
    if ((e ?? m) != null) debugPrint("error: ${e?.toString() ?? m}");
    if (data != null) {
      Sentry.addBreadcrumb(Breadcrumb.fromJson(data));
    }
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: e ?? Exception(m ?? "no message supplied"),
        stack: s,
        library: 'Pangea',
        context: ErrorSummary(e?.toString() ?? "error not defined"),
        stackFilter: (input) => input.where(
          (e) => !(e.contains("org-dartlang-sdk") ||
              e.contains("future_impl") ||
              e.contains("microtask") ||
              e.contains("async_patch")),
        ),
      ),
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
        ErrorHandler.logError(e: error, s: StackTrace.current);
        errorCode = null;
      }
      if (L10n.of(context) == null) {
        _setDefaults();
        Sentry.addBreadcrumb(Breadcrumb.fromJson({"error": error?.toString()}));
        ErrorHandler.logError(
          m: "null L10n in ErrorCopy.setCopy",
          s: StackTrace.current,
        );
        return;
      }
      final L10n l10n = L10n.of(context)!;

      switch (errorCode) {
        case 502:
        case 504:
        case 500:
          title = l10n.error502504Title;
          body = l10n.error502504Desc;
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
      ErrorHandler.logError(e: s, s: s);
      _setDefaults();
    }
  }
}

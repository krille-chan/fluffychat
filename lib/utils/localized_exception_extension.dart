import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

extension LocalizedExceptionExtension on Object {
  String toLocalizedString(BuildContext context) {
    if (this is MatrixException) {
      switch ((this as MatrixException).error) {
        case MatrixError.M_FORBIDDEN:
          return L10n.of(context).noPermission;
        case MatrixError.M_LIMIT_EXCEEDED:
          return L10n.of(context).tooManyRequestsWarning;
        default:
          return (this as MatrixException).errorMessage;
      }
    }
    if (this is MatrixConnectionException) {
      L10n.of(context).noConnectionToTheServer;
    }
    Logs().w('Something went wrong: ', this);
    return L10n.of(context).oopsSomethingWentWrong;
  }
}

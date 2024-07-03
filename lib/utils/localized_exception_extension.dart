import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

import 'uia_request_manager.dart';

extension LocalizedExceptionExtension on Object {
  String toLocalizedString(
    BuildContext context, [
    ExceptionContext? exceptionContext,
  ]) {
    if (this is MatrixException) {
      switch ((this as MatrixException).error) {
        case MatrixError.M_FORBIDDEN:
          if (exceptionContext == ExceptionContext.changePassword) {
            return L10n.of(context)!.passwordIsWrong;
          }
          return L10n.of(context)!.noPermission;
        case MatrixError.M_LIMIT_EXCEEDED:
          return L10n.of(context)!.tooManyRequestsWarning;
        default:
          return (this as MatrixException).errorMessage;
      }
    }
    if (this is InvalidPassphraseException) {
      return L10n.of(context)!.wrongRecoveryKey;
    }
    if (this is FileTooBigMatrixException) {
      return L10n.of(context)!.fileIsTooBigForServer;
    }
    if (this is BadServerVersionsException) {
      final serverVersions = (this as BadServerVersionsException)
          .serverVersions
          .toString()
          .replaceAll('{', '"')
          .replaceAll('}', '"');
      final supportedVersions = (this as BadServerVersionsException)
          .supportedVersions
          .toString()
          .replaceAll('{', '"')
          .replaceAll('}', '"');
      return L10n.of(context)!.badServerVersionsException(
        serverVersions,
        supportedVersions,
        serverVersions,
        supportedVersions,
      );
    }
    if (this is BadServerLoginTypesException) {
      final serverVersions = (this as BadServerLoginTypesException)
          .serverLoginTypes
          .toString()
          .replaceAll('{', '"')
          .replaceAll('}', '"');
      final supportedVersions = (this as BadServerLoginTypesException)
          .supportedLoginTypes
          .toString()
          .replaceAll('{', '"')
          .replaceAll('}', '"');
      return L10n.of(context)!.badServerLoginTypesException(
        serverVersions,
        supportedVersions,
        supportedVersions,
      );
    }
    if (this is IOException ||
        this is SocketException ||
        this is SyncConnectionException) {
      return L10n.of(context)!.noConnectionToTheServer;
    }
    if (this is String) return toString();
    if (this is UiaException) return toString();
    Logs().w('Something went wrong: ', this);
    return L10n.of(context)!.oopsSomethingWentWrong;
  }
}

enum ExceptionContext {
  changePassword,
}

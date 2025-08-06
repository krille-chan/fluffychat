import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/l10n/l10n.dart';

/// The status of requests for space analytics access.
enum RequestStatus {
  /// language analytics room is not in their profile
  unavailable,

  /// pending response
  requested,

  /// there is a room in their data but it hasn’t been requested
  unrequested,

  /// the user is in the analytics room, and doesn’t need to request
  available;

  static RequestStatus? fromString(String value) {
    switch (value) {
      case 'available':
        return RequestStatus.available;
      case 'unrequested':
        return RequestStatus.unrequested;
      case 'requested':
        return RequestStatus.requested;
      case 'unavailable':
        return RequestStatus.unavailable;
      default:
        return null;
    }
  }

  IconData get icon {
    switch (this) {
      case RequestStatus.available:
        return Icons.check_circle;
      case RequestStatus.unrequested:
        return Symbols.approval_delegation;
      case RequestStatus.requested:
        return Icons.mark_email_read_outlined;
      case RequestStatus.unavailable:
        return Symbols.approval_delegation;
    }
  }

  String label(BuildContext context) {
    final l10n = L10n.of(context);
    switch (this) {
      case RequestStatus.available:
        return l10n.available;
      case RequestStatus.unrequested:
        return l10n.request;
      case RequestStatus.requested:
        return l10n.pending;
      case RequestStatus.unavailable:
        return l10n.noDataFound;
    }
  }

  Color backgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (this) {
      case RequestStatus.available:
      case RequestStatus.unrequested:
        return theme.colorScheme.primaryContainer;
      case RequestStatus.unavailable:
      case RequestStatus.requested:
        return theme.disabledColor;
    }
  }

  bool get showButton => this != RequestStatus.available;

  bool get enabled => this == RequestStatus.unrequested;

  double get opacity => this == RequestStatus.unavailable ? 0.5 : 1.0;
}

/// The status of the download process for space analytics data.
enum DownloadStatus {
  /// The user is not in the analytics room, so the data cannot be downloaded.
  unavailable,

  /// The data is being downloaded.
  loading,

  /// The data has been downloaded successfully.
  complete;
}

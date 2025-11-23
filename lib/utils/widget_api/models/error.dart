/// Widget API error
class WidgetError implements Exception {
  const WidgetError(this.message);

  final String message;

  @override
  String toString() => 'WidgetError: $message';

  /// Convert to widget error response format
  Map<String, dynamic> toResponse() => {
        'error': {'message': message},
      };
}

/// Common widget errors
class WidgetErrors {
  static const unsupportedApi = WidgetError('Unsupported API version');
  static const capabilityNotGranted = WidgetError('Capability not granted');
  static const invalidRequest = WidgetError('Invalid request');
  static const notNegotiated = WidgetError('Capabilities not negotiated');
  static const encryptionRequired = WidgetError('Encryption required');
  static const forbidden = WidgetError('Forbidden event type');
}

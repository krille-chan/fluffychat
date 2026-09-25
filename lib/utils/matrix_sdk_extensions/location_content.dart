// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';

/// Content keys and asset types as described in MSC3488:
/// https://github.com/matrix-org/matrix-spec-proposals/pull/3488
abstract class LocationContentKeys {
  static const String location = 'org.matrix.msc3488.location';
  static const String asset = 'org.matrix.msc3488.asset';
  static const String timestamp = 'org.matrix.msc3488.ts';
}

abstract class LocationAssetTypes {
  static const String self = 'm.self';
  static const String pin = 'm.pin';
}

class GeoUri {
  final double latitude;
  final double longitude;
  final double? uncertainty;

  const GeoUri({
    required this.latitude,
    required this.longitude,
    this.uncertainty,
  });

  static GeoUri? tryParse(String? uriString) {
    if (uriString == null) return null;
    final uri = Uri.tryParse(uriString);
    if (uri == null || uri.scheme != 'geo') return null;

    final [coordinates, ...parameters] = uri.path.split(';');
    final latlong = coordinates.split(',').map(double.tryParse).toList();
    if (latlong.length < 2 || latlong.length > 3) return null;
    final latitude = latlong.first;
    final longitude = latlong[1];
    if (latitude == null || longitude == null) return null;
    if (latitude.abs() > 90 || longitude.abs() > 180) return null;

    double? uncertainty;
    for (final parameter in parameters) {
      final [key, ...value] = parameter.split('=');
      if (key.toLowerCase() == 'u') uncertainty = double.tryParse(value.join());
    }

    return GeoUri(
      latitude: latitude,
      longitude: longitude,
      uncertainty: uncertainty,
    );
  }

  @override
  String toString() => uncertainty == null
      ? 'geo:$latitude,$longitude'
      : 'geo:$latitude,$longitude;u=$uncertainty';
}

String? getLocationGeoUri(Map<String, Object?> content) =>
    content.tryGet<String>('geo_uri') ??
    content
        .tryGetMap<String, Object?>(LocationContentKeys.location)
        ?.tryGet<String>('uri');

/// MSC3488 defines `m.self` as default when no asset type is given.
String getLocationAssetType(Map<String, Object?> content) =>
    content
        .tryGetMap<String, Object?>(LocationContentKeys.asset)
        ?.tryGet<String>('type') ??
    LocationAssetTypes.self;

Map<String, Object?> buildLocationContent({
  required GeoUri geoUri,
  required String assetType,
  required DateTime timestamp,
}) {
  final uri = geoUri.toString();
  return {
    'msgtype': MessageTypes.Location,
    'body':
        'https://www.openstreetmap.org/?mlat=${geoUri.latitude}&mlon=${geoUri.longitude}#map=16/${geoUri.latitude}/${geoUri.longitude}',
    'geo_uri': uri,
    LocationContentKeys.location: {'uri': uri},
    LocationContentKeys.asset: {'type': assetType},
    LocationContentKeys.timestamp: timestamp.millisecondsSinceEpoch,
  };
}

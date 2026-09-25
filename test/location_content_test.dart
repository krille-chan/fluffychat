// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/matrix_sdk_extensions/location_content.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeoUri.tryParse', () {
    test('parses coordinates and uncertainty', () {
      final geoUri = GeoUri.tryParse('geo:51.5008,-0.1247;u=35.5');
      expect(geoUri?.latitude, 51.5008);
      expect(geoUri?.longitude, -0.1247);
      expect(geoUri?.uncertainty, 35.5);
    });

    test('ignores altitude and unknown parameters', () {
      final geoUri = GeoUri.tryParse('geo:51.5008,-0.1247,12;crs=wgs84;U=10');
      expect(geoUri?.latitude, 51.5008);
      expect(geoUri?.longitude, -0.1247);
      expect(geoUri?.uncertainty, 10);
    });

    test('parses without uncertainty', () {
      final geoUri = GeoUri.tryParse('geo:0,0');
      expect(geoUri?.latitude, 0);
      expect(geoUri?.longitude, 0);
      expect(geoUri?.uncertainty, null);
    });

    test('rejects invalid uris', () {
      for (final uri in [
        null,
        '',
        'https://example.com',
        'geo:51.5008',
        'geo:51.5008,abc',
        'geo:1,2,3,4',
        'geo:91,0',
        'geo:0,181',
      ]) {
        expect(GeoUri.tryParse(uri), null, reason: uri);
      }
    });

    test('toString round trips', () {
      const geoUri = GeoUri(latitude: 51.5, longitude: -0.12, uncertainty: 5);
      expect(geoUri.toString(), 'geo:51.5,-0.12;u=5.0');
      expect(GeoUri.tryParse(geoUri.toString())?.uncertainty, 5);
      expect(
        const GeoUri(latitude: 51.5, longitude: -0.12).toString(),
        'geo:51.5,-0.12',
      );
    });
  });

  group('getLocationGeoUri', () {
    test('prefers the legacy geo_uri', () {
      expect(
        getLocationGeoUri({
          'geo_uri': 'geo:1,2',
          LocationContentKeys.location: {'uri': 'geo:3,4'},
        }),
        'geo:1,2',
      );
    });

    test('falls back to the MSC3488 location', () {
      expect(
        getLocationGeoUri({
          LocationContentKeys.location: {'uri': 'geo:3,4'},
        }),
        'geo:3,4',
      );
    });

    test('returns null without location', () {
      expect(getLocationGeoUri({'body': 'hello'}), null);
    });
  });

  group('getLocationAssetType', () {
    test('reads the MSC3488 asset type', () {
      expect(
        getLocationAssetType({
          LocationContentKeys.asset: {'type': LocationAssetTypes.pin},
        }),
        LocationAssetTypes.pin,
      );
    });

    test('defaults to m.self', () {
      expect(getLocationAssetType({'geo_uri': 'geo:1,2'}), 'm.self');
    });
  });

  test('buildLocationContent contains legacy and MSC3488 fields', () {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(1636829458432);
    final content = buildLocationContent(
      geoUri: const GeoUri(latitude: 51.5, longitude: -0.12),
      assetType: LocationAssetTypes.pin,
      timestamp: timestamp,
    );
    expect(content['msgtype'], 'm.location');
    expect(content['geo_uri'], 'geo:51.5,-0.12');
    expect(content['body'], isA<String>());
    expect(content[LocationContentKeys.location], {'uri': 'geo:51.5,-0.12'});
    expect(content[LocationContentKeys.asset], {'type': 'm.pin'});
    expect(content[LocationContentKeys.timestamp], 1636829458432);
  });
}

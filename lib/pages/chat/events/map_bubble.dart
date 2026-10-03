// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/app_config.dart';
import '../../../utils/platform_infos.dart';

class MapBubble extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final double width;
  final double height;
  final double radius;
  final VoidCallback? onTap;
  final Widget marker;

  const MapBubble({
    required this.latitude,
    required this.longitude,
    this.zoom = 14.0,
    this.width = 400,
    this.height = 400,
    this.radius = 10.0,
    this.onTap,
    this.marker = const LocationPin(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(Size(width, height)),
      child: AspectRatio(
        aspectRatio: width / height,
        child: Stack(
          children: <Widget>[
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(latitude, longitude),
                initialZoom: zoom,
              ),
              children: [
                const OpenStreetMapTileLayer(),
                MarkerLayer(
                  rotate: true,
                  markers: [
                    Marker(
                      point: LatLng(latitude, longitude),
                      width: LocationPin.size,
                      height: LocationPin.size,
                      child: marker,
                    ),
                  ],
                ),
              ],
            ),
            const OpenStreetMapAttribution(),
            Material(
              color: Colors.transparent,
              child: Tooltip(
                message: L10n.of(context).openInMaps,
                child: InkWell(onTap: onTap, child: SizedBox.expand()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenStreetMapTileLayer extends StatelessWidget {
  const OpenStreetMapTileLayer({super.key});

  @override
  Widget build(BuildContext context) => TileLayer(
    maxZoom: 20,
    minZoom: 0,
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: AppConfig.appId,
  );
}

class OpenStreetMapAttribution extends StatelessWidget {
  const OpenStreetMapAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.bottomRight,
      child: Text(
        ' © OpenStreetMap contributors ',
        style: TextStyle(
          color: theme.brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
      ),
    );
  }
}

class LocationPin extends StatelessWidget {
  static double get size => PlatformInfos.isMobile ? 48 : 64;

  final Uri? avatarUrl;
  final String? avatarName;

  const LocationPin({super.key}) : avatarUrl = null, avatarName = null;

  const LocationPin.avatar({
    required this.avatarUrl,
    required String this.avatarName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final avatarName = this.avatarName;
    final color = Theme.of(context).colorScheme.primary;
    return Transform.translate(
      // The tip of the Material location_pin glyph is at 22/24 of its height,
      // so it is moved up by 10/24 to point at the center of the marker
      offset: Offset(0, -size * 10 / 24),
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Icon(
              Icons.location_pin,
              color: color,
              size: size,
              shadows: const [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            if (avatarName != null)
              // The head of the glyph is a circle centered at 9/24 with a
              // radius of 7/24
              Positioned(
                top: size * 9 / 24 - _avatarSize / 2,
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.lerp(color, Colors.black, 0.3)!,
                    ),
                    gradient: const RadialGradient(
                      colors: [Colors.transparent, Colors.black26],
                      stops: [0.8, 1],
                    ),
                  ),
                  child: Avatar(
                    mxContent: avatarUrl,
                    name: avatarName,
                    size: _avatarSize,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static double get _avatarSize => size * 13 / 24;
}

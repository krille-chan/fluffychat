import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class MapBubble extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final double width;
  final double height;
  final double radius;
  const MapBubble({
    this.latitude,
    this.longitude,
    this.zoom = 14.0,
    this.width = 400,
    this.height = 400,
    this.radius = 10.0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        constraints: BoxConstraints.loose(Size(width, height)),
        child: AspectRatio(
          aspectRatio: width / height,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(latitude, longitude),
              zoom: zoom,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    point: LatLng(latitude, longitude),
                    builder: (context) => const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

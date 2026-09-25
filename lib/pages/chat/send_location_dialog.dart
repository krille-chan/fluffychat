// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/events/map_bubble.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/location_content.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

class SendLocationDialog extends StatefulWidget {
  final Room room;

  const SendLocationDialog({required this.room, super.key});

  @override
  SendLocationDialogState createState() => SendLocationDialogState();
}

class SendLocationDialogState extends State<SendLocationDialog> {
  static const double positionZoom = 16;

  final MapController mapController = MapController();
  bool mapIsReady = false;
  bool pinMoved = false;
  bool disabled = false;
  bool denied = false;
  bool isSending = false;
  Position? position;
  Object? error;

  @override
  void initState() {
    super.initState();
    requestLocation();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> requestLocation() async {
    try {
      if (!(await Geolocator.isLocationServiceEnabled())) {
        setState(() => disabled = true);
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => denied = true);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => denied = true);
        return;
      }
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 30),
          ),
        );
      } on TimeoutException {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 30),
          ),
        );
      }
      if (!mounted) return;
      setState(() => this.position = position);
      if (!pinMoved) moveToPosition();
    } catch (e) {
      if (!mounted) return;
      setState(() => error = e);
    }
  }

  void moveToPosition() {
    final position = this.position;
    if (position == null || !mapIsReady) return;
    mapController.move(
      LatLng(position.latitude, position.longitude),
      positionZoom,
    );
    if (pinMoved) setState(() => pinMoved = false);
  }

  void onMapReady() {
    mapIsReady = true;
    moveToPosition();
  }

  void onPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture && !pinMoved) setState(() => pinMoved = true);
  }

  Future<void> sendAction() async {
    setState(() => isSending = true);
    final position = this.position;
    final sendsOwnPosition = !pinMoved && position != null;
    final center = mapController.camera.center;
    final geoUri = sendsOwnPosition
        ? GeoUri(
            latitude: position.latitude,
            longitude: position.longitude,
            uncertainty: position.accuracy,
          )
        : GeoUri(latitude: center.latitude, longitude: center.longitude);
    await showFutureLoadingDialog(
      context: context,
      future: () => widget.room.sendEvent(
        buildLocationContent(
          geoUri: geoUri,
          assetType: sendsOwnPosition
              ? LocationAssetTypes.self
              : LocationAssetTypes.pin,
          timestamp: DateTime.now(),
        ),
      ),
    );
    if (!mounted) return;
    Navigator.of(context, rootNavigator: false).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final position = this.position;

    final Widget? statusWidget;
    if (position != null) {
      statusWidget = null;
    } else if (disabled) {
      statusWidget = Text(l10n.locationDisabledNotice);
    } else if (denied) {
      statusWidget = Text(l10n.locationPermissionDeniedNotice);
    } else if (error != null) {
      statusWidget = Text(l10n.errorObtainingLocation(error.toString()));
    } else {
      statusWidget = Row(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        children: [
          const CupertinoActivityIndicator(),
          const SizedBox(width: 12),
          Text(l10n.obtainingLocation),
        ],
      );
    }

    return AlertDialog.adaptive(
      title: Text(l10n.shareLocation),
      content: Column(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: 400,
            height: 400,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(0, 0),
                    initialZoom: 1,
                    onMapReady: onMapReady,
                    onPositionChanged: onPositionChanged,
                  ),
                  children: const [OpenStreetMapTileLayer()],
                ),
                const IgnorePointer(child: Center(child: LocationPin())),
                const OpenStreetMapAttribution(),
                if (position != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton.filledTonal(
                      tooltip: l10n.myLocation,
                      onPressed: pinMoved ? moveToPosition : null,
                      icon: const Icon(Icons.my_location_outlined),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(l10n.moveMapToChooseLocation),
          if (statusWidget != null) ...[
            const SizedBox(height: 8),
            statusWidget,
          ],
        ],
      ),
      actions: [
        AdaptiveDialogAction(
          onPressed: Navigator.of(context, rootNavigator: false).pop,
          child: Text(l10n.cancel),
        ),
        AdaptiveDialogAction(
          onPressed: isSending || (position == null && !pinMoved)
              ? null
              : sendAction,
          child: Text(l10n.send),
        ),
      ],
    );
  }
}

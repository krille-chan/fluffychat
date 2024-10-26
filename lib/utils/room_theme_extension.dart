import 'package:async/async.dart';
import 'package:flutter/widgets.dart';
import 'package:matrix/matrix.dart' hide Result;

extension RoomThemeExtension on Room {
  static const String typeKey = 'im.fluffychat.room.theme';

  MatrixRoomTheme? get roomTheme {
    final content = getState(typeKey)?.content;
    if (content == null) return null;

    return MatrixRoomTheme.fromJson(content);
  }

  Future<void> setRoomTheme(MatrixRoomTheme theme) =>
      client.setRoomStateWithKey(
        id,
        typeKey,
        '',
        theme.toJson(),
      );
}

class MatrixRoomTheme {
  final Color? color;
  final Uri? wallpaper;

  const MatrixRoomTheme({required this.color, required this.wallpaper});

  factory MatrixRoomTheme.fromJson(Map<String, Object?> json) {
    final colorString = json.tryGet<String>('color');
    final colorInt = colorString == null ? null : int.tryParse(colorString);
    final color =
        colorInt == null ? null : Result(() => Color(colorInt)).asValue?.value;
    final wallpaperString = json.tryGet<String>('wallpaper');
    final wallpaper =
        wallpaperString == null ? null : Uri.tryParse(wallpaperString);

    return MatrixRoomTheme(
      color: color,
      wallpaper: wallpaper,
    );
  }
  Map<String, Object?> toJson() => {
        if (color != null) 'color': color?.value,
        if (wallpaper != null) 'wallpaper': wallpaper?.toString(),
      };
}

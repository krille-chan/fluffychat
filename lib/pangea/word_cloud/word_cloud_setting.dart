// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fluffychat/pangea/word_cloud/word_cloud_shape.dart';

class WordCloudSetting {
  double mapX = 0;
  double mapY = 0;
  String? fontFamily;
  FontStyle? fontStyle;
  FontWeight? fontWeight;
  List<Map> data = [];
  List map = [[]];
  List textCenter = [];
  List textPoints = [];
  List textlist = [];
  List isdrawed = [];
  double centerX = 0;
  double centerY = 0;
  double minTextSize;
  double maxTextSize;
  WordCloudShape shape;
  int attempt;
  List<Color>? colorList = [Colors.black];

  WordCloudSetting({
    Key? key,
    required this.data,
    required this.minTextSize,
    required this.maxTextSize,
    required this.attempt,
    required this.shape,
  });

  void setMapSize(double x, double y) {
    mapX = x;
    mapY = y;
  }

  void setColorList(List<Color>? colors) {
    colorList = colors;
  }

  void setFont(String? family, FontStyle? style, FontWeight? weight) {
    fontFamily = family;
    fontStyle = style;
    fontWeight = weight;
  }

  List setMap(dynamic shape) {
    final List makemap = [[]];
    switch (shape.getType()) {
      case 'normal':
        for (var i = 0; i < mapX; i++) {
          for (var j = 0; j < mapY; j++) {
            makemap[i].add(0);
          }
          makemap.add([]);
        }
        break;

      case 'circle':
        for (var i = 0; i < mapX; i++) {
          for (var j = 0; j < mapY; j++) {
            if (pow(i - (mapX / 2), 2) + pow(j - (mapY / 2), 2) >
                pow(shape.getRadius(), 2)) {
              makemap[i].add(1);
            } else {
              makemap[i].add(0);
            }
          }
          makemap.add([]);
        }
        break;

      case 'ellipse':
        for (var i = 0; i < mapX; i++) {
          for (var j = 0; j < mapY; j++) {
            if (pow(i - (mapX / 2), 2) / pow(shape.getMajorAxis(), 2) +
                    pow(j - (mapY / 2), 2) / pow(shape.getMinorAxis(), 2) >
                1) {
              makemap[i].add(1);
            } else {
              makemap[i].add(0);
            }
          }
          makemap.add([]);
        }
        break;
    }
    return makemap;
  }

  void setInitial() {
    //map = [[]];
    textCenter = [];
    textPoints = [];
    textlist = [];
    isdrawed = [];

    centerX = mapX / 2;
    centerY = mapY / 2;

    map = setMap(shape);

    // for (var i = 0; i < mapX; i++) {
    //   for (var j = 0; j < mapY; j++) {
    //     if (pow(i - (mapX / 2), 2) + pow(j - (mapY / 2), 2) > pow(250, 2)) {
    //       map[i].add(1);
    //     } else {
    //       map[i].add(0);
    //     }
    //   }
    //   map.add([]);
    // }

    for (var i = 0; i < data.length; i++) {
      final double getTextSize =
          (minTextSize * (data[0]['value'] - data[i]['value']) +
                  maxTextSize *
                      (data[i]['value'] - data[data.length - 1]['value'])) /
              (data[0]['value'] - data[data.length - 1]['value']);

      final textSpan = TextSpan(
        text: data[i]['word'],
        style: TextStyle(
          color: colorList?[Random().nextInt(colorList!.length)],
          fontSize: getTextSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          fontStyle: fontStyle,
        ),
      );

      final textPainter = TextPainter()
        ..text = textSpan
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();

      textlist.add(textPainter);

      final double centerCorrectionX = centerX - textlist[i].width / 2;
      final double centerCorrectionY = centerY - textlist[i].height / 2;
      textCenter.add([centerCorrectionX, centerCorrectionY]);
      textPoints.add([]);
      isdrawed.add(false);
    }
  }

  void setTextStyle(List<TextStyle> newstyle) {
    //only support color, weight, family, fontstyle
    textlist = [];
    textCenter = [];
    textPoints = [];
    isdrawed = [];

    for (var i = 0; i < data.length; i++) {
      final double getTextSize =
          (minTextSize * (data[0]['value'] - data[i]['value']) +
                  maxTextSize *
                      (data[i]['value'] - data[data.length - 1]['value'])) /
              (data[0]['value'] - data[data.length - 1]['value']);

      final textSpan = TextSpan(
        text: data[i]['word'],
        style: TextStyle(
          color: newstyle[i].color,
          fontSize: getTextSize,
          fontWeight: newstyle[i].fontWeight,
          fontFamily: newstyle[i].fontFamily,
          fontStyle: newstyle[i].fontStyle,
        ),
      );

      final textPainter = TextPainter()
        ..text = textSpan
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();

      textlist.add(textPainter);

      final double centerCorrectionX = centerX - textlist[i].width / 2;
      final double centerCorrectionY = centerY - textlist[i].height / 2;
      textCenter.add([centerCorrectionX, centerCorrectionY]);
      textPoints.add([]);
      isdrawed.add(false);
    }
  }

  bool checkMap(double x, double y, double w, double h) {
    if (mapX - x < w) {
      return false;
    }
    if (mapY - y < h) {
      return false;
    }
    for (int i = x.toInt(); i < x.toInt() + w; i++) {
      for (int j = y.toInt(); j < y.toInt() + h; j++) {
        if (map[i][j] == 1) {
          return false;
        }
      }
    }
    return true;
  }

  bool checkMapOptimized(int x, int y, double w, double h) {
    if (mapX - x < w) {
      return false;
    }
    if (mapY - y < h) {
      return false;
    }
    for (int i = x.toInt(); i < x.toInt() + w; i++) {
      if (map[i][y + h - 1] == 1) {
        return false;
      }
      if (map[i][y + 1] == 1) {
        return false;
      }
    }
    return true;
  }

  void drawIn(int index, double x, double y) {
    textPoints[index] = [x, y];
    for (int i = x.toInt(); i < x.toInt() + textlist[index].width; i++) {
      for (int j = y.toInt();
          j < y.toInt() + textlist[index].height.floor();
          j++) {
        map[i][j] = 1;
      }
    }
  }

  void drawTextOptimized() {
    drawIn(0, textCenter[0][0], textCenter[0][1]);
    isdrawed[0] = true;
    bool checkattempt = false;
    for (var i = 1; i < textlist.length; i++) {
      final double w = textlist[i].width;
      final double h = textlist[i].height;
      int attempts = 0;

      bool isadded = false;

      while (!isadded) {
        final int getX = Random().nextInt(mapX.toInt() - w.toInt());
        final int direction = Random().nextInt(2);
        if (direction == 0) {
          for (int y = textCenter[i][1].toInt(); y > 0; y--) {
            if (checkMapOptimized(getX, y, w, h)) {
              drawIn(i, getX.toDouble(), y.toDouble());
              isadded = true;
              isdrawed[i] = true;
              break;
            }
          }
        } else if (direction == 1) {
          for (int y = textCenter[i][1].toInt(); y < mapY; y++) {
            if (checkMapOptimized(getX, y, w, h)) {
              drawIn(i, getX.toDouble(), y.toDouble());
              isadded = true;
              isdrawed[i] = true;
              break;
            }
          }
        }
        attempts += 1;
        if (attempts > attempt) {
          isadded = true;
          checkattempt = true;
        }
      }
      if (checkattempt) {
        return;
      }
    }
  }

  void drawText() {
    drawIn(0, textCenter[0][0], textCenter[0][1]);
    for (var i = 1; i < textlist.length; i++) {
      final double w = textlist[i].width;
      final double h = textlist[i].height;
      int attempts = 0;

      bool isadded = false;

      while (!isadded) {
        final int getX = Random().nextInt(mapX.toInt() - w.toInt());
        final int direction = Random().nextInt(2);
        if (direction == 0) {
          for (int y = textCenter[i][1].toInt(); y > 0; y--) {
            if (checkMap(getX.toDouble(), y.toDouble(), w, h)) {
              drawIn(i, getX.toDouble(), y.toDouble());
              isadded = true;
              break;
            }
          }
          if (!isadded) {
            for (int y = textCenter[i][1].toInt(); y < mapY; y++) {
              if (checkMap(getX.toDouble(), y.toDouble(), w, h)) {
                drawIn(i, getX.toDouble(), y.toDouble());
                isadded = true;
                break;
              }
            }
          }
        } else if (direction == 1) {
          for (int y = textCenter[i][1].toInt(); y < mapY; y++) {
            if (checkMap(getX.toDouble(), y.toDouble(), w, h)) {
              drawIn(i, getX.toDouble(), y.toDouble());
              isadded = true;
              break;
            }
          }
          if (!isadded) {
            for (int y = textCenter[i][1].toInt(); y > 0; y--) {
              if (checkMap(getX.toDouble(), y.toDouble(), w, h)) {
                drawIn(i, getX.toDouble(), y.toDouble());
                isadded = true;
                break;
              }
            }
          }
        }
        attempts += 1;
        if (attempts > attempt) {
          isadded = true;
        }
      }
    }
  }

  List getWordPoint() {
    return textPoints;
  }

  List getTextPainter() {
    return textlist;
  }

  int getDataLength() {
    return data.length;
  }
}

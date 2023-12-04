import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/word_cloud/word_cloud_data.dart';
import 'package:fluffychat/pangea/word_cloud/word_cloud_setting.dart';
import 'package:fluffychat/pangea/word_cloud/word_cloud_shape.dart';

class WordCloudView extends StatefulWidget {
  final WordCloudData data;
  final Color? mapcolor;
  final Decoration? decoration;
  final double mapwidth;
  final String? fontFamily;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final double mapheight;
  final List<Color>? colorlist;
  final int attempt;
  final double mintextsize;
  final double maxtextsize;
  final WordCloudShape? shape;

  const WordCloudView({
    super.key,
    required this.data,
    required this.mapwidth,
    required this.mapheight,
    this.mintextsize = 10,
    this.maxtextsize = 100,
    this.attempt = 30,
    this.shape,
    this.fontFamily,
    this.fontStyle,
    this.fontWeight,
    this.mapcolor,
    this.decoration,
    this.colorlist,
  });
  @override
  State<WordCloudView> createState() => _WordCloudViewState();
}

class _WordCloudViewState extends State<WordCloudView> {
  late WordCloudShape wcshape;
  late WordCloudSetting wordcloudsetting;

  @override
  void initState() {
    super.initState();
    if (widget.shape == null) {
      wcshape = WordCloudShape();
    } else {
      wcshape = widget.shape!;
    }

    wordcloudsetting = WordCloudSetting(
      data: widget.data.getData(),
      minTextSize: widget.mintextsize,
      maxTextSize: widget.maxtextsize,
      attempt: widget.attempt,
      shape: wcshape,
    );

    wordcloudsetting.setMapSize(widget.mapwidth, widget.mapheight);
    wordcloudsetting.setFont(
        widget.fontFamily, widget.fontStyle, widget.fontWeight,);
    wordcloudsetting.setColorList(widget.colorlist);
    wordcloudsetting.setInitial();

    wordcloudsetting.drawTextOptimized();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.mapwidth,
      height: widget.mapheight,
      color: widget.mapcolor,
      decoration: widget.decoration,
      child: CustomPaint(
        painter: WCpaint(wordcloudpaint: wordcloudsetting),
      ),
    );
  }
}

class WCpaint extends CustomPainter {
  final WordCloudSetting wordcloudpaint;
  WCpaint({
    required this.wordcloudpaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < wordcloudpaint.getDataLength(); i++) {
      if (wordcloudpaint.isdrawed[i]) {
        wordcloudpaint.getTextPainter()[i].paint(
            canvas,
            Offset(wordcloudpaint.getWordPoint()[i][0],
                wordcloudpaint.getWordPoint()[i][1],),);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

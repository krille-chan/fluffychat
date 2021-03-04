import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class LogViewer extends StatefulWidget {
  @override
  _LogViewerState createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer> {
  Level logLevel = Level.debug;
  double fontSize = 14;
  @override
  Widget build(BuildContext context) {
    final outputEvents = Logs()
        .outputEvents
        .where((e) => e.level.index >= logLevel.index)
        .toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(logLevel.toString()),
        leading: BackButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.zoom_in_outlined),
            onPressed: () => setState(() => fontSize++),
            tooltip: L10n.of(context).zoomIn,
          ),
          IconButton(
            icon: Icon(Icons.zoom_out_outlined),
            onPressed: () => setState(() => fontSize--),
            tooltip: L10n.of(context).zoomOut,
          ),
          PopupMenuButton<Level>(
            itemBuilder: (context) => Level.values
                .map((level) => PopupMenuItem(
                      value: level,
                      child: Text(level.toString()),
                    ))
                .toList(),
            onSelected: (Level level) => setState(() => logLevel = level),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: outputEvents.length,
        itemBuilder: (context, i) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: fontSize),
              children: _AnsiParser(outputEvents[i].lines.join('\n')).spans,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnsiParser {
  static const TEXT = 0, BRACKET = 1, CODE = 2;
  final String text;

  Color foreground;
  Color background;
  List<TextSpan> spans;

  _AnsiParser(this.text) {
    final s = this.text;
    spans = [];
    var state = TEXT;
    StringBuffer buffer;
    var text = StringBuffer();
    var code = 0;
    List<int> codes;

    for (var i = 0, n = s.length; i < n; i++) {
      var c = s[i];

      switch (state) {
        case TEXT:
          if (c == '\u001b') {
            state = BRACKET;
            buffer = StringBuffer(c);
            code = 0;
            codes = [];
          } else {
            text.write(c);
          }
          break;

        case BRACKET:
          buffer.write(c);
          if (c == '[') {
            state = CODE;
          } else {
            state = TEXT;
            text.write(buffer);
          }
          break;

        case CODE:
          buffer.write(c);
          var codeUnit = c.codeUnitAt(0);
          if (codeUnit >= 48 && codeUnit <= 57) {
            code = code * 10 + codeUnit - 48;
            continue;
          } else if (c == ';') {
            codes.add(code);
            code = 0;
            continue;
          } else {
            if (text.isNotEmpty) {
              spans.add(createSpan(text.toString()));
              text.clear();
            }
            state = TEXT;
            if (c == 'm') {
              codes.add(code);
              handleCodes(codes);
            } else {
              text.write(buffer);
            }
          }

          break;
      }
    }

    spans.add(createSpan(text.toString()));
  }

  void handleCodes(List<int> codes) {
    if (codes.isEmpty) {
      codes.add(0);
    }

    switch (codes[0]) {
      case 0:
        foreground = getColor(0, true);
        background = getColor(0, false);
        break;
      case 38:
        foreground = getColor(codes[2], true);
        break;
      case 39:
        foreground = getColor(0, true);
        break;
      case 48:
        background = getColor(codes[2], false);
        break;
      case 49:
        background = getColor(0, false);
    }
  }

  Color getColor(int colorCode, bool foreground) {
    switch (colorCode) {
      case 0:
        return foreground ? Colors.black : Colors.transparent;
      case 12:
        return Colors.lightBlue[300];
      case 208:
        return Colors.orange[300];
      case 196:
        return Colors.red[300];
      case 199:
        return Colors.pink[300];
      default:
        return Colors.white;
    }
  }

  TextSpan createSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: foreground,
        backgroundColor: background,
      ),
    );
  }
}

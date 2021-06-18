import 'package:matrix/matrix.dart';
import 'package:flutter/material.dart';

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
        .where((e) => e.level.index <= logLevel.index)
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
          ),
          IconButton(
            icon: Icon(Icons.zoom_out_outlined),
            onPressed: () => setState(() => fontSize--),
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
          child: SelectableText(
            outputEvents[i].toDisplayString(),
            style: TextStyle(
              color: outputEvents[i].color,
            ),
          ),
        ),
      ),
    );
  }
}

extension on LogEvent {
  Color get color {
    switch (level) {
      case Level.wtf:
        return Colors.purple;
      case Level.error:
        return Colors.red;
      case Level.warning:
        return Colors.orange;
      case Level.info:
        return Colors.green;
      case Level.debug:
        return Colors.white;
      case Level.verbose:
      default:
        return Colors.grey;
    }
  }

  String toDisplayString() {
    var str = '# [${level.toString().split('.').last.toUpperCase()}] $title';
    if (exception != null) {
      str += ' - ${exception.toString()}';
    }
    if (stackTrace != null) {
      str += '\n${stackTrace.toString()}';
    }
    return str;
  }
}

import 'package:famedlysdk/famedlysdk.dart';
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
          child: Text(outputEvents[i].toDisplayString()),
        ),
      ),
    );
  }
}

extension on LogEvent {
  String toDisplayString() {
    var str = '# $title';
    if (exception != null) {
      str += ' - ${exception.toString()}';
    }
    if (stackTrace != null) {
      str += '\n${stackTrace.toString()}';
    }
    return str;
  }
}

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
import '../../word_cloud/word_cloud_data.dart';
import '../../word_cloud/word_cloud_shape.dart';
import '../../word_cloud/word_cloud_tap.dart';
import '../../word_cloud/word_cloud_tap_view.dart';
import '../../word_cloud/word_cloud_view.dart';

class ConstructCloud extends StatefulWidget {
  final AnalyticsSelected? selected;
  final AnalyticsSelected defaultSelected;

  const ConstructCloud({
    super.key,
    required this.selected,
    required this.defaultSelected,
  });

  @override
  State<StatefulWidget> createState() => ConstructCloudState();
}

class ConstructCloudState extends State<ConstructCloud> {
  int count = 0;
  String wordstring = '';
  List<Map<String, dynamic>> wordData = [
    {"word": "loading", 'value': 1},
    {"word": "loading", 'value': 1},
    {"word": "loading", 'value': 1},
    {"word": "loading", 'value': 1},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final WordCloudData wcdata = WordCloudData(data: wordData);
    final WordCloudTap wordtaps = WordCloudTap();

    for (int i = 0; i < wordData.length; i++) {
      void tap() {
        setState(() {
          count += 1;
          wordstring = wordData[i]['word'];
        });
      }

      wordtaps.addWordtap(wordData[i]['word'], tap);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Clicked Word : $wordstring',
            style: const TextStyle(fontSize: 20),
          ),
          Text('Clicked Count : $count', style: const TextStyle(fontSize: 20)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WordCloudTapView(
                  data: wcdata,
                  wordtap: wordtaps,
                  mapcolor: const Color.fromARGB(255, 174, 183, 235),
                  mapwidth: 500,
                  mapheight: 500,
                  fontWeight: FontWeight.bold,
                  shape: WordCloudCircle(radius: 250),
                  colorlist: const [
                    Colors.black,
                    Colors.redAccent,
                    Colors.indigoAccent,
                  ],
                ),
                const SizedBox(
                  height: 15,
                  width: 30,
                ),
                WordCloudView(
                  data: wcdata,
                  mapcolor: const Color.fromARGB(255, 174, 183, 235),
                  mapwidth: 500,
                  mapheight: 500,
                  fontWeight: FontWeight.bold,
                  colorlist: const [
                    Colors.black,
                    Colors.redAccent,
                    Colors.indigoAccent,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

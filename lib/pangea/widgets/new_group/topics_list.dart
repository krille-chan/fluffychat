import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/chat_topic_model.dart';

/// the widget loads the list of ChatTopic from assets/chat_data.json
/// displays the topics in a list with image, name and total number of vocab
/// when a topic is selected, the ChatTopic is passed to the parent widget
/// while a topic is selected, it displays expanded details about the topic,
/// including description, bot prompt, and vocab
class SelectTopicList extends StatefulWidget {
  final Function(ChatTopic) onTopicSelected;

  const SelectTopicList({super.key, required this.onTopicSelected});

  @override
  SelectTopicListState createState() => SelectTopicListState();
}

class SelectTopicListState extends State<SelectTopicList> {
  late Future<List<ChatTopic>> _futureTopics;

  ChatTopic? selected;

  @override
  void initState() {
    super.initState();
    _futureTopics = _loadTopics();
  }

  Future<List<ChatTopic>> _loadTopics() async {
    final String data = await DefaultAssetBundle.of(context)
        .loadString("assets/chat_data.json");
    final jsonResult = json.decode(data);
    final List<ChatTopic> topics = [];
    for (final topic in jsonResult['chats']) {
      topics.add(ChatTopic.fromJson(topic));
    }
    return topics;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatTopic>>(
      future: _futureTopics,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SelectTopicListWidget(
            topics: snapshot.data!,
            onTopicSelected: ((topic) {
              widget.onTopicSelected(topic);
              selected = topic;
              setState(() {});
            }),
            selectedTopicState: this,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class SelectTopicListWidget extends StatelessWidget {
  final List<ChatTopic> topics;
  final Function(ChatTopic) onTopicSelected;
  final SelectTopicListState selectedTopicState;

  const SelectTopicListWidget({
    super.key,
    required this.topics,
    required this.onTopicSelected,
    required this.selectedTopicState,
  });

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      itemCount: topics.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SelectTopicListItem(
          topic: topics[index],
          isSelected: topics[index] == selectedTopicState.selected,
          onTopicSelected: onTopicSelected,
        );
      },
    );

    /// wrap list in scroll area
    return SingleChildScrollView(
      child: list,
    );
  }
}

/// while a topic is selected, it displays expanded details about the topic,
/// including description, bot prompt, and vocab
/// use ThemeData to get colors, text styles, etc.
class SelectTopicListItem extends StatelessWidget {
  final ChatTopic topic;
  final Function(ChatTopic) onTopicSelected;
  final bool isSelected;

  const SelectTopicListItem({
    super.key,
    required this.topic,
    required this.isSelected,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTopicSelected(topic);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[100] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.grey[300]! : Colors.white,
          ),
        ),
        child: Row(
          children: [
            // Image.asset(
            //   Icons.airplane_ticket_outlined,
            //   width: 50,
            //   height: 50,
            // ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 8),
                    Text(
                      topic.description,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      topic.vocab.join(", "),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

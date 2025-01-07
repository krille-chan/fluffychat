import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../models/chat_topic_model.dart';
import '../../models/lemma.dart';
import '../../repo/topic_data_repo.dart';
import '../common/bot_face_svg.dart';

/// stateless widget that displays a list of vocabulary words
/// parameters
/// 1) list of words
/// 2) one callback function that handles all changes to the list (passes full list back to parent)
/// view
/// 1) a list of words (chips) in a wrapped row within a scrollable area with an x button to remove the word
/// 2) in the bottom center is a text field to type a new word and add it to the list on submit
/// 3) at the top right is a button to clear the list with trash icon and confirm dialog
/// 4) at the top left is a button to call an API to get a list of words with the BotFace widget
/// the user can
/// 1) type a new word and add it to the list
/// 2) remove a word from the list
/// 3) clear all words from the list
/// 4) widget button called
/// uses app theme colors, text styles, and icons

class ChatVocabularyList extends StatelessWidget {
  const ChatVocabularyList({
    super.key,
    required this.topic,
    required this.onChanged,
  });

  final ChatTopic topic;
  final ValueChanged<List<Lemma>> onChanged;

  @override
  Widget build(BuildContext context) {
    final deleteButton = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(L10n.of(context).clearAll),
                  actions: [
                    TextButton(
                      child: Text(L10n.of(context).cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(L10n.of(context).confirm),
                      onPressed: () {
                        onChanged([]);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
    final words = Wrap(
      spacing: 8,
      children: [
        for (final word in topic.vocab)
          Chip(
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            label: Text(word.text),
            onDeleted: () {
              onChanged(topic.vocab..remove(word));
            },
          ),
      ],
    );
    final vocabColumn = Column(
      children: [
        // clear all words button
        deleteButton,
        // list of words
        words,
        // add word from text field to words
        WordAddTextField(
          words: topic.vocab,
          onSubmitted: (value) {
            //PTODO - error message if
            if (value.isEmpty) return;
            onChanged(topic.vocab..add(Lemma.create(value)));
          },
        ),
        GenerateVocabButton(
          topic: topic,
          onWordsGenerated: (newWords) {
            onChanged(topic.vocab..addAll(newWords));
          },
          onPressed: () {},
        ),
      ],
    );

    /// return vocabColumn wrapped in a scrollable area with border
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: vocabColumn,
      ),
    );
  }
}

class VocabWord {
  final String word;

  VocabWord({
    required this.word,
  });

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      word: json['word'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
    };
  }

  /// set equals operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabWord &&
          runtimeType == other.runtimeType &&
          word == other.word;

  /// set hashcode
  @override
  int get hashCode => word.hashCode;
}

/// text field widget for adding a word
/// parameters
/// 1) callback passes the word back to the parent widget
/// 2) word list to check if the word is already in the list
/// new word cn be added by pressing enter or the add button
/// uses app theme colors, text styles, and icons
/// function for checking word, reused in the button and textfield onSubmitted
/// 1) if the word is already in the list, it is not added and an error message is displayed
/// 2) if whitespace is detected anywhere in the word, display an error message

class WordAddTextField extends StatefulWidget {
  const WordAddTextField({
    super.key,
    required this.onSubmitted,
    required this.words,
  });

  final ValueChanged<String> onSubmitted;
  final List<Lemma> words;

  @override
  WordAddTextFieldState createState() => WordAddTextFieldState();
}

class WordAddTextFieldState extends State<WordAddTextField> {
  final _controller = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _errorText = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Add a word',
        errorText: _errorText,
        suffixIcon: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _addWord();
          },
        ),
      ),
      onSubmitted: (value) {
        _addWord();
      },
    );
  }

  void _addWord() {
    final word = _controller.text.trim();
    if (word.isEmpty) {
      setState(() {
        _errorText = 'Please enter a word';
      });
      return;
    }
    if (widget.words.map((e) => e.text).contains(word)) {
      setState(() {
        _errorText = 'Word already in list';
      });
      return;
    }
    widget.onSubmitted(word);
    _controller.clear();
  }
}

/// widget button to call an API to get a list of words
/// button has a BotFace icon and text saying "Generate Vocabulary", use L10n for copy
/// parameters
/// 1) callback function to pass the list of words back to the parent widget
/// 2) callback function to notify the parent widget that the button was pressed
/// 3) topic information to pass to the API
/// display loading indicator while waiting for response
/// display error message if there is an error
/// uses app theme colors, text styles, and icons
class GenerateVocabButton extends StatefulWidget {
  const GenerateVocabButton({
    super.key,
    required this.onWordsGenerated,
    required this.onPressed,
    required this.topic,
  });

  final ChatTopic topic;
  final ValueChanged<List<Lemma>> onWordsGenerated;
  final VoidCallback onPressed;

  @override
  GenerateVocabButtonState createState() => GenerateVocabButtonState();
}

class GenerateVocabButtonState extends State<GenerateVocabButton> {
  bool _loading = false;
  String? _errorText;
  final PangeaController _pangeaController = MatrixState.pangeaController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // button to call API
        ElevatedButton.icon(
          icon: const BotFace(
            width: 50.0,
            expression: BotExpression.idle,
          ),
          label: Text(L10n.of(context).generateVocabulary),
          onPressed: () async {
            // if widget.topic.name is null, give error message
            if (widget.topic.name.isEmpty) {
              setState(() {
                _errorText =
                    'Please enter a topic name before generating vocabulary';
              });
              return;
            }
            setState(() {
              _loading = true;
              _errorText = null;
            });
            try {
              final words = await _getWords();
              widget.onWordsGenerated(words);
            } catch (e) {
              setState(() {
                _errorText = e.toString();
              });
            } finally {
              setState(() {
                _loading = false;
              });
            }
            widget.onPressed();
          },
        ),

        // loading indicator
        if (_loading) const CircularProgressIndicator(),
        // error message
        if (_errorText != null) Text(_errorText!),
      ],
    );
  }

  Future<List<Lemma>> _getWords() async {
    final ChatTopic topic = await TopicDataRepo.generate(
      _pangeaController.userController.accessToken,
      request: TopicDataRequest(
        topicInfo: widget.topic,
        numWords: 10,
        numPrompts: 0,
      ),
    );
    return topic.vocab;
  }
}

/// text field for entering a chat description, max 250 characters
/// parameters
/// 1) ChatTopic object
/// 2) initial value for the text field
/// 3) onChanged callback function to pass the updated ChatTopic back to the parent widget
class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required this.topic,
    required this.initialValue,
    required this.onChanged,
  });

  final ChatTopic topic;
  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: L10n.of(context).groupDescription,
        hintText: L10n.of(context).addGroupDescription,
      ),
      maxLength: 250,
      maxLines: 5,
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}

/// text field for entering a chat name, max 50 characters
/// parameters
/// 1) ChatTopic object
/// 2) initial value for the text field
/// 3) onChanged callback function to pass the updated ChatTopic back to the parent widget
class NameField extends StatelessWidget {
  const NameField({
    super.key,
    required this.topic,
    required this.onChanged,
  });

  final ChatTopic topic;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: topic.name,
      decoration: InputDecoration(
        labelText: L10n.of(context).optionalGroupName,
        hintText: L10n.of(context).enterAGroupName,
      ),
      maxLength: 50,
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}

///widget for displaying, adding, deleting and generating discussion prompts
/// parameters
/// 1) chatTopic object
/// 2) callback function to pass the updated ChatTopic back to the parent widget
class PromptsField extends StatefulWidget {
  const PromptsField({
    super.key,
    required this.topic,
    required this.onChanged,
  });

  final ChatTopic topic;
  final ValueChanged<ChatTopic> onChanged;

  @override
  PromptsFieldState createState() => PromptsFieldState();
}

class PromptsFieldState extends State<PromptsField> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  final PangeaController _pangeaController = MatrixState.pangeaController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _errorText = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // text field for entering a prompt
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Add a prompt',
            errorText: _errorText,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addPrompt();
              },
            ),
          ),
          onSubmitted: (value) {
            _addPrompt();
          },
        ),

        // list of prompts
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.topic.discussionPrompts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.topic.discussionPrompts[index].text),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deletePrompt(index);
                },
              ),
            );
          },
        ),

        // button to call API
        ElevatedButton.icon(
          icon: const BotFace(
            width: 50.0,
            expression: BotExpression.idle,
          ),
          label: Text(L10n.of(context).generatePrompts),
          onPressed: () async {
            setState(() {
              _errorText = null;
            });
            try {
              final prompts = await _getPrompts();
              widget.topic.discussionPrompts = prompts;
              widget.onChanged(widget.topic);
            } catch (e) {
              setState(() {
                _errorText = e.toString();
              });
            }
          },
        ),
      ],
    );
  }

  void _addPrompt() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorText = 'Please enter a prompt';
      });
      return;
    }
    final prompt = DiscussionPrompt(text: text);
    if (widget.topic.discussionPrompts.contains(prompt)) {
      setState(() {
        _errorText = 'Prompt already in list';
      });
      return;
    }
    widget.topic.discussionPrompts.add(prompt);
    widget.onChanged(widget.topic);
    _controller.clear();
  }

  void _deletePrompt(int index) {
    widget.topic.discussionPrompts.removeAt(index);
    widget.onChanged(widget.topic);
  }

  Future<List<DiscussionPrompt>> _getPrompts() async {
    final ChatTopic res = await TopicDataRepo.generate(
      _pangeaController.userController.accessToken,
      request: TopicDataRequest(
        topicInfo: widget.topic,
        numPrompts: 10,
        numWords: 0,
      ),
    );
    return res.discussionPrompts;
  }
}

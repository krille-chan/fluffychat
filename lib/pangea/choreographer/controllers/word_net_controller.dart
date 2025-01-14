import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

import 'package:fluffychat/pangea/choreographer/repo/word_repo.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import '../../common/controllers/base_controller.dart';
import '../../common/controllers/pangea_controller.dart';
import '../models/word_data_model.dart';

class WordController extends BaseController {
  late PangeaController _pangeaController;

  final List<WordData> _wordData = [];

  WordController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  WordData? getWordDataLocal({
    required String word,
    required String fullText,
    required String? userL1,
    required String? userL2,
  }) =>
      _wordData.firstWhereOrNull(
        (e) => e.isMatch(
          w: word,
          f: fullText,
          l1: userL1,
          l2: userL2,
        ),
      );

  Future<WordData> getWordDataGlobal({
    required String word,
    required String fullText,
    required String? userL1,
    required String? userL2,
  }) async {
    if (userL1 == null ||
        userL2 == null ||
        userL1 == LanguageKeys.unknownLanguage ||
        userL2 == LanguageKeys.unknownLanguage) {
      throw http.Response("", 405);
    }

    final WordData? local = getWordDataLocal(
      word: word,
      fullText: fullText,
      userL1: userL1,
      userL2: userL2,
    );

    if (local != null) return local;

    final WordData remote = await WordRepo.getWordNetData(
      accessToken: _pangeaController.userController.accessToken,
      fullText: fullText,
      word: word,
      userL1: userL1,
      userL2: userL2,
    );

    _addWordData(remote);

    return remote;
  }

  _addWordData(WordData w) {
    final WordData? local = getWordDataLocal(
      word: w.word,
      fullText: w.fullText,
      userL1: w.userL1,
      userL2: w.userL2,
    );

    if (local == null) {
      if (_wordData.length > 100) _wordData.clear();
      _wordData.add(w);
      setState(null);
    }
  }
}

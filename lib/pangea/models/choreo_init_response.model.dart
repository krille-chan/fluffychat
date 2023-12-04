class ChoreoResponseModel {
  GrammarData? grammarData;
  String? detectedLang;
  String? route;
  String? feedbackMessage;
  int? payloadId;
  ChoreoResponseModel(
      {this.grammarData, this.detectedLang, this.route, this.feedbackMessage,});

  ChoreoResponseModel.fromJson(Map<String, dynamic> json) {
    grammarData = json['grammar_data'] != null
        ? GrammarData.fromJson(json['grammar_data'])
        : null;
    detectedLang = json['detected_lang'];
    route = json['route'];
    feedbackMessage = json['feedback_message'];
    payloadId = json['payload_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (grammarData != null) {
      data['grammar_data'] = grammarData!.toJson();
    }
    data['detected_lang'] = detectedLang;
    data['route'] = route;
    data['feedback_message'] = feedbackMessage;
    return data;
  }
}

class GrammarData {
  String? text;
  List<Tokens>? tokens;
  double? slor;

  GrammarData({this.text, this.tokens, this.slor});

  GrammarData.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['tokens'] != null) {
      tokens = <Tokens>[];
      json['tokens'].forEach((v) {
        tokens!.add(Tokens.fromJson(v));
      });
    }
    slor = json['slor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (tokens != null) {
      data['tokens'] = tokens!.map((v) => v.toJson()).toList();
    }
    data['slor'] = slor;
    return data;
  }
}

class Tokens {
  String? token;
  int? category;
  String? feedbackMessage;

  Tokens({this.token, this.category, this.feedbackMessage});

  Tokens.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    category = json['category'];
    feedbackMessage = json['feedback_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['category'] = category;
    data['feedback_message'] = feedbackMessage;
    return data;
  }
}

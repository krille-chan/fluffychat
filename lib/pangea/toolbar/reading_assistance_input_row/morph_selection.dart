import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';

class MorphSelection {
  PangeaToken token;
  MorphFeaturesEnum morph;

  MorphSelection(
    this.token,
    this.morph,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MorphSelection &&
        other.token == token &&
        other.morph == morph;
  }

  @override
  int get hashCode => token.hashCode ^ morph.hashCode;
}

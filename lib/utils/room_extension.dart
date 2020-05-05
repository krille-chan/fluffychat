import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';

extension LocalizedRoomDisplayname on Room {
  String getLocalizedDisplayname(I18n i18n) {
    if ((this.name?.isEmpty ?? true) &&
        (this.canonicalAlias?.isEmpty ?? true) &&
        !this.isDirectChat &&
        (this.mHeroes != null && this.mHeroes.isNotEmpty)) {
      return i18n.groupWith(this.displayname);
    }
    if ((this.name?.isEmpty ?? true) &&
        (this.canonicalAlias?.isEmpty ?? true) &&
        !this.isDirectChat &&
        (this.mHeroes?.isEmpty ?? true)) {
      return i18n.emptyChat;
    }
    return this.displayname;
  }
}

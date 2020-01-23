import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';

extension LocalizedRoomDisplayname on Room {
  String getLocalizedDisplayname(BuildContext context) {
    if ((this.name?.isEmpty ?? true) &&
        (this.canonicalAlias?.isEmpty ?? true) &&
        !this.isDirectChat &&
        (this.mHeroes != null && this.mHeroes.isNotEmpty)) {
      return I18n.of(context).groupWith(this.displayname);
    }
    return this.displayname;
  }
}

import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';

extension LocalizedRoomDisplayname on Room {
  String getLocalizedDisplayname(BuildContext context) {
    if ((this.name?.isEmpty ?? true) &&
        (this.canonicalAlias?.isEmpty ?? true) &&
        !this.isDirectChat &&
        this.mHeroes.isNotEmpty) {
      return "Group with ${this.displayname}";
    }
    return this.displayname;
  }
}

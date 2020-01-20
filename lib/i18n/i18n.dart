import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';

class I18n {
  I18n(this.localeName);

  static Future<I18n> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return I18n(localeName);
    });
  }

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  final String localeName;

  /* <=============> Translations <=============> */

  String get close => Intl.message("Close");

  String get confirm => Intl.message("Confirm");

  String get create => Intl.message("Create");

  String get createNewGroup => Intl.message("Create new group");

  String get enterAGroupName => Intl.message("Enter a group name");

  String get enterAUsername => Intl.message("Enter a username");

  String get groupIsPublic => Intl.message("Group is public");

  String get makeSureTheIdentifierIsValid =>
      Intl.message("Make sure the identifier is valid");

  String get newPrivateChat => Intl.message("New private chat");

  String get optionalGroupName => Intl.message("(Optional) Group name");

  String get pleaseEnterAMatrixIdentifier =>
      Intl.message('Please enter a matrix identifier');

  String get title => Intl.message(
        'FluffyChat',
        name: 'title',
        desc: 'Title for the application',
        locale: localeName,
      );

  String get username => Intl.message("Username");

  String get youCannotInviteYourself =>
      Intl.message("You cannot invite yourself");

  String get yourOwnUsername => Intl.message("Your own username");
}

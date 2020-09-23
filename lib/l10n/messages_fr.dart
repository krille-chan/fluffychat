// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static m0(username) => "${username} a accepté l\'invitation";

  static m1(username) => "${username} a activé le chiffrement de bout en bout";

  static m2(senderName) => "${senderName} a répondu à l\'appel";

  static m3(username) =>
      "Accepter cette demande de vérification de ${username} ?";

  static m4(username, targetName) => "${username} a banni ${targetName}";

  static m5(homeserver) => "Par défaut, vous serez connecté à ${homeserver}";

  static m6(username) => "${username} a changé l\'image de la discussion";

  static m7(username, description) =>
      "${username} a changé la description de la discussion en : \'${description}\'";

  static m8(username, chatname) =>
      "${username} a renommé la discussion en : \'${chatname}\'";

  static m9(username) =>
      "${username} a changé les permissions de la discussion";

  static m10(username, displayname) =>
      "${username} s\'est renommé en : ${displayname}";

  static m11(username) =>
      "${username} a changé les règles d\'accès à la discussion pour les invités";

  static m12(username, rules) =>
      "${username} a changé les règles d\'accès à la discussion pour les invités en : ${rules}";

  static m13(username) =>
      "${username} a changé la visibilité de l\'historique de la discussion";

  static m14(username, rules) =>
      "${username} a changé la visibilité de l\'historique de la discussion en : ${rules}";

  static m15(username) =>
      "${username} a changé les règles d\'accès à la discussion";

  static m16(username, joinRules) =>
      "${username} a changé les règles d\'accès à la discussion en : ${joinRules}";

  static m17(username) => "${username} a changé son avatar";

  static m18(username) => "${username} a changé les adresses du salon";

  static m19(username) => "${username} a changé le lien d\'invitation";

  static m20(error) => "Impossible de déchiffrer le message : ${error}";

  static m21(count) => "${count} participant(s)";

  static m22(username) => "${username} a créé la discussion";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}/${month}/${year}";

  static m25(month, day) => "${day}/${month}";

  static m26(senderName) => "${senderName} a mis fin à l\'appel";

  static m27(displayname) => "Groupe avec ${displayname}";

  static m28(username, targetName) =>
      "${username} a retiré l\'invitation de ${targetName}";

  static m29(groupName) => "Inviter un contact dans ${groupName}";

  static m30(username, link) =>
      "${username} vous a invité sur FluffyChat. \n1. Installez FluffyChat : https://fluffychat.im \n2. Inscrivez-vous ou connectez-vous \n3. Ouvrez le lien d\'invitation : ${link}";

  static m31(username, targetName) => "${username} a invité ${targetName}";

  static m32(username) => "${username} a rejoint la discussion";

  static m33(username, targetName) => "${username} a expulsé ${targetName}";

  static m34(username, targetName) =>
      "${username} a expulsé et banni ${targetName}";

  static m35(localizedTimeShort) =>
      "Vu pour la dernière fois : ${localizedTimeShort}";

  static m36(count) => "Charger ${count} participants de plus";

  static m37(homeserver) => "Se connecter à ${homeserver}";

  static m38(number) => "${number} selectionné(s)";

  static m39(fileName) => "Lire ${fileName}";

  static m40(username) => "${username} a supprimé un message";

  static m41(username) => "${username} a refusé l\'invitation";

  static m42(username) => "Supprimé par ${username}";

  static m43(username) => "Vu par ${username}";

  static m44(username, count) => "Vu par ${username} et ${count} autres";

  static m45(username, username2) => "Vu par ${username} et ${username2}";

  static m46(username) => "${username} a envoyé un fichier";

  static m47(username) => "${username} a envoyé une image";

  static m48(username) => "${username} a envoyé un sticker";

  static m49(username) => "${username} a envoyé une vidéo";

  static m50(username) => "${username} a envoyé un fichier audio";

  static m51(senderName) =>
      "${senderName} a envoyé des informations sur l\'appel";

  static m52(username) => "${username} a partagé une localisation";

  static m53(senderName) => "${senderName} a démarré un appel";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) => "${username} a dé-banni ${targetName}";

  static m56(type) => "Événement de type inconnu \'${type}\'";

  static m57(unreadCount) => "${unreadCount} discussions non lues";

  static m58(unreadEvents) => "${unreadEvents} messages non lus";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} messages non lus dans ${unreadChats} discussions";

  static m60(username, count) =>
      "${username} et ${count} autres sont en train d\'écrire...";

  static m61(username, username2) =>
      "${username} et ${username2} sont en train d\'écrire...";

  static m62(username) => "${username} est en train d\'écrire...";

  static m63(username) => "${username} a quitté la discussion";

  static m64(username, type) =>
      "${username} a envoyé un événement de type ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("À propos"),
        "accept": MessageLookupByLibrary.simpleMessage("Accepter"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Compte"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Informations du compte"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription": MessageLookupByLibrary.simpleMessage(
            "Ajouter une description au groupe"),
        "admin": MessageLookupByLibrary.simpleMessage("Administrateur"),
        "alias": MessageLookupByLibrary.simpleMessage("adresse"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Vous avez déjà un compte ?"),
        "answeredTheCall": m2,
        "anyoneCanJoin": MessageLookupByLibrary.simpleMessage(
            "Tout le monde peut rejoindre"),
        "archive": MessageLookupByLibrary.simpleMessage("Archiver"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("Salon achivé"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Est-ce que les invités peuvent rejoindre"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Êtes-vous sûr ?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Veuillez saisir votre phrase de passe stockée de manière sécurisée ou votre clé de récupération pour mettre les clés en cache."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Pour pouvoir faire signer l\'autre personne, veuillez entrer votre phrase de passe stockée de manière sécurisée ou votre clé de récupération."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Veuillez saisir votre phrase de passe stockée de manière sécurisée ou votre clé de récupération pour vérifier votre session."),
        "askVerificationRequest": m3,
        "authentication":
            MessageLookupByLibrary.simpleMessage("Authentification"),
        "avatarHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "L\'image de profil a été changée"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Bannir de la discussion"),
        "banned": MessageLookupByLibrary.simpleMessage("Banni"),
        "bannedUser": m4,
        "blockDevice":
            MessageLookupByLibrary.simpleMessage("Bloquer l\'appareil"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Clés mises en cache avec succès !"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "changeTheHomeserver": MessageLookupByLibrary.simpleMessage(
            "Changer le serveur d\'accueil"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Changer le nom du groupe"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Changer de serveur"),
        "changeTheme":
            MessageLookupByLibrary.simpleMessage("Changez votre style"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Changer d\'image de fond"),
        "changedTheChatAvatar": m6,
        "changedTheChatDescriptionTo": m7,
        "changedTheChatNameTo": m8,
        "changedTheChatPermissions": m9,
        "changedTheDisplaynameTo": m10,
        "changedTheGuestAccessRules": m11,
        "changedTheGuestAccessRulesTo": m12,
        "changedTheHistoryVisibility": m13,
        "changedTheHistoryVisibilityTo": m14,
        "changedTheJoinRules": m15,
        "changedTheJoinRulesTo": m16,
        "changedTheProfileAvatar": m17,
        "changedTheRoomAliases": m18,
        "changedTheRoomInvitationLink": m19,
        "changelog":
            MessageLookupByLibrary.simpleMessage("Journal des changements"),
        "changesHaveBeenSaved": MessageLookupByLibrary.simpleMessage(
            "Les changements ont été sauvegardés"),
        "channelCorruptedDecryptError": MessageLookupByLibrary.simpleMessage(
            "Le chiffrement a été corrompu"),
        "chat": MessageLookupByLibrary.simpleMessage("Discussion"),
        "chatDetails":
            MessageLookupByLibrary.simpleMessage("Détails de la discussion"),
        "chooseAStrongPassword": MessageLookupByLibrary.simpleMessage(
            "Choisissez un mot de passe fort"),
        "chooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Choisissez un nom d\'utilisateur"),
        "close": MessageLookupByLibrary.simpleMessage("Fermer"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Comparez et assurez-vous que les emojis suivants correspondent à ceux de l\'autre appareil :"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Comparez et assurez-vous que les chiffres suivants correspondent à ceux de l\'autre appareil :"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
        "connect": MessageLookupByLibrary.simpleMessage("Se connecter"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Tentative de connexion echouée"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Le contact a été invité au groupe"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Visionneuse de contenu"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Copié dans le presse-papier"),
        "copy": MessageLookupByLibrary.simpleMessage("Copier"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Impossible de changer d\'image de profil"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Impossible de changer de nom"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Créer"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Créer un compte"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Créer un nouveau groupe"),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "La signature croisée est désactivée"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "La signature croisée est activée"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Actif en ce moment"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Sombre"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "deactivateAccountWarning": MessageLookupByLibrary.simpleMessage(
            "Cela désactivera votre compte et ne peut pas être annulé ! Êtes-vous sûr(e) ?"),
        "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Supprimer le compte"),
        "deleteMessage":
            MessageLookupByLibrary.simpleMessage("Supprimer le message"),
        "deny": MessageLookupByLibrary.simpleMessage("Refuser"),
        "device": MessageLookupByLibrary.simpleMessage("Périphérique"),
        "devices": MessageLookupByLibrary.simpleMessage("Périphériques"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Abandonner l\'image"),
        "displaynameHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Renommage effectué"),
        "donate": MessageLookupByLibrary.simpleMessage("Faire un don"),
        "downloadFile":
            MessageLookupByLibrary.simpleMessage("Télécharger le fichier"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Changer de nom"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Changer l\'instance Jitsi"),
        "emoteExists": MessageLookupByLibrary.simpleMessage(
            "Cette émoticône existe déjà !"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Raccourci d\'émoticône invalide !"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Paramètre des émoticônes"),
        "emoteShortcode":
            MessageLookupByLibrary.simpleMessage("Raccourci d\'émoticône"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Vous devez sélectionner un raccourci d\'émoticône et une image !"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Discussion vide"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Vous ne pourrez plus désactiver le chiffrement. Êtes-vous sûr(e) ?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Chiffrement"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Algorithme de chiffrement"),
        "encryptionNotEnabled": MessageLookupByLibrary.simpleMessage(
            "Le chiffrement n\'est pas actif"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Paramètres du chiffrement de bout en bout"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Entrez un nom de groupe"),
        "enterAUsername": MessageLookupByLibrary.simpleMessage(
            "Entrez un nom d\'utilisateur"),
        "enterYourHomeserver": MessageLookupByLibrary.simpleMessage(
            "Renseignez votre serveur d\'accueil"),
        "fileName": MessageLookupByLibrary.simpleMessage("Nom du ficher"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Taille du fichier"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Transférer"),
        "friday": MessageLookupByLibrary.simpleMessage("Vendredi"),
        "fromJoining": MessageLookupByLibrary.simpleMessage(
            "À partir de l\'entrée dans le salon"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("À partir de l\'invitation"),
        "group": MessageLookupByLibrary.simpleMessage("Groupe"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Description du groupe"),
        "groupDescriptionHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "La description du groupe a été changée"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("Le groupe est public"),
        "groupWith": m27,
        "guestsAreForbidden": MessageLookupByLibrary.simpleMessage(
            "Les invités ne peuvent pas rejoindre"),
        "guestsCanJoin": MessageLookupByLibrary.simpleMessage(
            "Les invités peuvent rejoindre"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Aide"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(
            "Le serveur d\'accueil n\'est pas compatible"),
        "id": MessageLookupByLibrary.simpleMessage("Identifiant"),
        "identity": MessageLookupByLibrary.simpleMessage("Identité"),
        "ignoreListDescription": MessageLookupByLibrary.simpleMessage(
            "Vous pouvez ignorer les utilisateurs/trices qui vous dérangent. Vous ne pourrez pas recevoir de messages ou d\'invitations à participer à un salon de discussion de la part des utilisateurs/trices figurant sur votre liste personnelle."),
        "ignoreUsername": MessageLookupByLibrary.simpleMessage(
            "Ignorer l\'utilisateur/trice"),
        "ignoredUsers": MessageLookupByLibrary.simpleMessage(
            "Utilisateurs/trices ignoré(e)s"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Phrase de passe ou clé de récupération incorrecte"),
        "inviteContact":
            MessageLookupByLibrary.simpleMessage("Inviter un contact"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Invité"),
        "invitedUser": m31,
        "invitedUsersOnly": MessageLookupByLibrary.simpleMessage(
            "Uniquement les utilisateurs invités"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "La clé de l\'appareil ci-dessous est-elle correcte ?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("écrit..."),
        "joinRoom":
            MessageLookupByLibrary.simpleMessage("Rejoindre la réunion"),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage(
            "Les clés sont mises en cache"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Les clés sont manquantes"),
        "kickFromChat":
            MessageLookupByLibrary.simpleMessage("Expulser de la discussion"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage(
            "Dernière addresse IP utilisée"),
        "lastSeenLongTimeAgo": MessageLookupByLibrary.simpleMessage(
            "Vu pour la dernière fois il y a longtemps"),
        "leave": MessageLookupByLibrary.simpleMessage("Partir"),
        "leftTheChat":
            MessageLookupByLibrary.simpleMessage("A quitté la discussion"),
        "license": MessageLookupByLibrary.simpleMessage("Licence"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Clair"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Charger plus..."),
        "loadingPleaseWait": MessageLookupByLibrary.simpleMessage(
            "Chargement... Veuillez patienter"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Connexion"),
        "logout": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Promouvoir comme modérateur"),
        "makeAnAdmin": MessageLookupByLibrary.simpleMessage(
            "Promouvoir comme administrateur"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Vérifiez que l\'identifiant est valide"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Le message sera supprimé pour tous les participants"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderateur"),
        "monday": MessageLookupByLibrary.simpleMessage("Lundi"),
        "muteChat": MessageLookupByLibrary.simpleMessage(
            "Mettre la discussion en sourdine"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Sachez que vous avez besoin de Pantalaimon pour utiliser le chiffrement de bout en bout pour l\'instant."),
        "newMessageInFluffyChat": MessageLookupByLibrary.simpleMessage(
            "Nouveau message dans FluffyChat"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Nouvelle discussion privée"),
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(
            "Nouvelle demande de vérification !"),
        "no": MessageLookupByLibrary.simpleMessage("Non"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat ne permet pas actuellement d\'activer la signature croisée. Veuillez l\'activer à partir de Riot."),
        "noEmotesFound":
            MessageLookupByLibrary.simpleMessage("Aucun émote trouvé. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Il semblerait que vous n\'ayez pas de services Google sur votre téléphone. C\'est une bonne décision pour votre vie privée ! Pour recevoir des notifications dans FluffyChat, nous vous recommandons d\'utiliser microG : https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat ne prend pas actuellement en charge l\'activation de la sauvegarde des clés en ligne. Veuillez l\'activer à partir de Riot."),
        "noPermission":
            MessageLookupByLibrary.simpleMessage("Aucune permission"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("Aucun salon trouvé..."),
        "none": MessageLookupByLibrary.simpleMessage("Aucun"),
        "notSupportedInWeb": MessageLookupByLibrary.simpleMessage(
            "Non supporté par l\'application web"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "La sauvegarde en ligne des clés est désactivée"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "La sauvegarde en ligne des clés est activée"),
        "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
            "Oups, un problème s\'est produit..."),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "Ouvrez l\'application pour lire le message"),
        "openCamera":
            MessageLookupByLibrary.simpleMessage("Ouvrir l\'appareil photo"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Optionnel) Nom du groupe"),
        "participatingUserDevices":
            MessageLookupByLibrary.simpleMessage("Périphériques participants"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Phrase de passe ou clé de récupération"),
        "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "passwordHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Le mot de passe a été modifié"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Choisir une image"),
        "pin": MessageLookupByLibrary.simpleMessage("Épingler"),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Choisissez un nom d\'utilisateur"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Renseignez un identifiant Matrix"),
        "pleaseEnterYourPassword": MessageLookupByLibrary.simpleMessage(
            "Renseignez votre mot de passe"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Renseignez votre nom d\'utilisateur"),
        "publicRooms": MessageLookupByLibrary.simpleMessage("Salons publics"),
        "recording": MessageLookupByLibrary.simpleMessage("Enregistrement"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Refuser"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Rejoindre de nouveau"),
        "remove": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(
            "Supprimer tous les autres périphériques"),
        "removeDevice":
            MessageLookupByLibrary.simpleMessage("Supprimer le périphérique"),
        "removeExile":
            MessageLookupByLibrary.simpleMessage("Retirer le bannissement"),
        "removeMessage":
            MessageLookupByLibrary.simpleMessage("Supprimer le message"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(
            "Afficher les contenus riches des messages"),
        "reply": MessageLookupByLibrary.simpleMessage("Répondre"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Demander la permission"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Demander à lire les anciens messages"),
        "revokeAllPermissions": MessageLookupByLibrary.simpleMessage(
            "Révoquer toutes les permissions"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("Le salon a été mis à niveau"),
        "saturday": MessageLookupByLibrary.simpleMessage("Samedi"),
        "searchForAChat":
            MessageLookupByLibrary.simpleMessage("Rechercher une discussion"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Envoyer"),
        "sendAMessage":
            MessageLookupByLibrary.simpleMessage("Envoyer un message"),
        "sendAudio":
            MessageLookupByLibrary.simpleMessage("Envoyer un fichier audio"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "Autoriser l\'envoi de rapports d\'anomalies via sentry.io"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Envoyer un fichier"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Envoyer une image"),
        "sendOriginal":
            MessageLookupByLibrary.simpleMessage("Envoyer le fichier original"),
        "sendVideo": MessageLookupByLibrary.simpleMessage("Envoyer une vidéo"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "Informations relatives à votre vie privée : https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("La session est vérifiée"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Définir une image de profil"),
        "setGroupDescription": MessageLookupByLibrary.simpleMessage(
            "Définir une description du groupe"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("Créer un lien d\'invitation"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Définir un statut"),
        "settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
        "share": MessageLookupByLibrary.simpleMessage("Partager"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("S\'inscrire"),
        "skip": MessageLookupByLibrary.simpleMessage("Ignorer"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Code source"),
        "startYourFirstChat": MessageLookupByLibrary.simpleMessage(
            "Démarrez votre première discussion :-)"),
        "startedACall": m53,
        "statusExampleMessage": MessageLookupByLibrary.simpleMessage(
            "Comment allez-vous aujourd\'hui ?"),
        "submit": MessageLookupByLibrary.simpleMessage("Soumettre"),
        "sunday": MessageLookupByLibrary.simpleMessage("Dimanche"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Système"),
        "tapToShowMenu": MessageLookupByLibrary.simpleMessage(
            "Tappez pour afficher le menu"),
        "theyDontMatch":
            MessageLookupByLibrary.simpleMessage("Elles ne correspondent pas"),
        "theyMatch":
            MessageLookupByLibrary.simpleMessage("Elles correspondent"),
        "thisRoomHasBeenArchived":
            MessageLookupByLibrary.simpleMessage("Ce salon a été archivé."),
        "thursday": MessageLookupByLibrary.simpleMessage("Jeudi"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Retenter l\'envoi"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Mardi"),
        "unbannedUser": m55,
        "unblockDevice":
            MessageLookupByLibrary.simpleMessage("Débloquer l\'appareil"),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Périphérique inconnu"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Algorithme de chiffrement inconnu"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Session inconnue, veuillez vérifier"),
        "unmuteChat":
            MessageLookupByLibrary.simpleMessage("Retirer la sourdine"),
        "unpin": MessageLookupByLibrary.simpleMessage("Détacher"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "Utiliser des couleurs compatibles Amoled ?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Session vérifiée avec succès !"),
        "verify": MessageLookupByLibrary.simpleMessage("Vérifier"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Vérifier manuellement"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Commencer la vérification"),
        "verifySuccess": MessageLookupByLibrary.simpleMessage(
            "Vous avez vérifié avec succès !"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(
            "Vérification de l\'autre compte"),
        "verifyUser": MessageLookupByLibrary.simpleMessage(
            "Vérifier l\'utilisateur/trice"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Appel vidéo"),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(
            "Visibilité de l\'historique de la discussion"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Visible pour tous les participants"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Visible pour tout le monde"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Message vocal"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "En attente de la vérification de la demande par le partenaire..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "En attente de l\'acceptation de l\'émoji par le partenaire..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "En attente de l\'acceptation des nombres par le partenaire..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Image de fond"),
        "warning": MessageLookupByLibrary.simpleMessage("Attention !"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Le chiffrement de bout en bout est actuellement en béta ! Utilisez cette fonctionnalité à vos propres risques !"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Mercredi"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Bienvenue dans la messagerie instantanée la plus mignonne du réseau Matrix."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Qui est autorisé à rejoindre ce groupe"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Écrit un message..."),
        "yes": MessageLookupByLibrary.simpleMessage("Oui"),
        "you": MessageLookupByLibrary.simpleMessage("Vous"),
        "youAreInvitedToThisChat": MessageLookupByLibrary.simpleMessage(
            "Vous êtes invité à cette discussion"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Vous ne participez plus à cette discussion"),
        "youCannotInviteYourself": MessageLookupByLibrary.simpleMessage(
            "Vous ne pouvez pas vous inviter vous-même"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Vous avez été banni de cette discussion"),
        "yourOwnUsername": MessageLookupByLibrary.simpleMessage(
            "Votre propre nom d\'utilisateur")
      };
}

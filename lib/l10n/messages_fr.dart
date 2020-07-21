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

  static m60(username) =>
      "Accepter cette demande de vérification de ${username} ?";

  static m2(username, targetName) => "${username} a banni ${targetName}";

  static m3(homeserver) => "Par défaut, vous serez connecté à ${homeserver}";

  static m4(username) => "${username} a changé l\'image de la discussion";

  static m5(username, description) =>
      "${username} a changé la description de la discussion en : \'${description}\'";

  static m6(username, chatname) =>
      "${username} a renommé la discussion en : \'${chatname}\'";

  static m7(username) =>
      "${username} a changé les permissions de la discussion";

  static m8(username, displayname) =>
      "${username} s\'est renommé en : ${displayname}";

  static m9(username) =>
      "${username} a changé les règles d\'accès à la discussion pour les invités";

  static m10(username, rules) =>
      "${username} a changé les règles d\'accès à la discussion pour les invités en : ${rules}";

  static m11(username) =>
      "${username} a changé la visibilité de l\'historique de la discussion";

  static m12(username, rules) =>
      "${username} a changé la visibilité de l\'historique de la discussion en : ${rules}";

  static m13(username) =>
      "${username} a changé les règles d\'accès à la discussion";

  static m14(username, joinRules) =>
      "${username} a changé les règles d\'accès à la discussion en : ${joinRules}";

  static m15(username) => "${username} a changé son image de profil";

  static m16(username) => "${username} a changé les adresses du salon";

  static m17(username) => "${username} a changé le lien d\'invitation";

  static m18(error) => "Impossible de déchiffrer le message : ${error}";

  static m19(count) => "${count} participant(s)";

  static m20(username) => "${username} a créé la discussion";

  static m21(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m22(year, month, day) => "${day}/${month}/${year}";

  static m23(month, day) => "${day}/${month}";

  static m24(displayname) => "Groupe avec ${displayname}";

  static m25(username, targetName) =>
      "${username} a retiré l\'invitation de ${targetName}";

  static m26(groupName) => "Inviter un contact dans ${groupName}";

  static m27(username, link) =>
      "${username} vous a invité sur FluffyChat. \n1. Installez FluffyChat : http://fluffy.chat \n2. Inscrivez-vous ou connectez-vous \n3. Ouvrez le lien d\'invitation : ${link}";

  static m28(username, targetName) => "${username} a invité ${targetName}";

  static m29(username) => "${username} a rejoint la discussion";

  static m30(username, targetName) => "${username} a expulsé ${targetName}";

  static m31(username, targetName) =>
      "${username} a expulsé et banni ${targetName}";

  static m32(localizedTimeShort) =>
      "Vu pour la dernière fois : ${localizedTimeShort}";

  static m33(count) => "Charger ${count} participants de plus";

  static m34(homeserver) => "Se connecter à ${homeserver}";

  static m35(number) => "${number} selectionné(s)";

  static m36(fileName) => "Lire ${fileName}";

  static m37(username) => "${username} a supprimé un message";

  static m38(username) => "${username} a refusé l\'invitation";

  static m39(username) => "Supprimé par ${username}";

  static m40(username) => "Vu par ${username}";

  static m41(username, count) => "Vu par ${username} et ${count} autres";

  static m42(username, username2) => "Vu par ${username} et ${username2}";

  static m43(username) => "${username} a envoyé un fichier";

  static m44(username) => "${username} a envoyé une image";

  static m45(username) => "${username} a envoyé un sticker";

  static m46(username) => "${username} a envoyé une vidéo";

  static m47(username) => "${username} a envoyé un fichier audio";

  static m48(username) => "${username} a partagé une localisation";

  static m49(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m50(username, targetName) => "${username} a dé-banni ${targetName}";

  static m51(type) => "Événement de type inconnu \'${type}\'";

  static m52(unreadCount) => "${unreadCount} discussions non lues";

  static m53(unreadEvents) => "${unreadEvents} messages non lus";

  static m54(unreadEvents, unreadChats) =>
      "${unreadEvents} messages non lus dans ${unreadChats} discussions";

  static m55(username, count) =>
      "${username} et ${count} autres sont en train d\'écrire...";

  static m56(username, username2) =>
      "${username} et ${username2} sont en train d\'écrire...";

  static m57(username) => "${username} est en train d\'écrire...";

  static m58(username) => "${username} a quitté la discussion";

  static m59(username, type) =>
      "${username} a envoyé un événement de type ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Optionnel) Nom du groupe"),
        "About": MessageLookupByLibrary.simpleMessage("À propos"),
        "Accept": MessageLookupByLibrary.simpleMessage("Accepter"),
        "Account": MessageLookupByLibrary.simpleMessage("Compte"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Informations du compte"),
        "Add a group description": MessageLookupByLibrary.simpleMessage(
            "Ajouter une description au groupe"),
        "Admin": MessageLookupByLibrary.simpleMessage("Administrateur"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Vous avez déjà un compte ?"),
        "Anyone can join": MessageLookupByLibrary.simpleMessage(
            "Tout le monde peut rejoindre"),
        "Archive": MessageLookupByLibrary.simpleMessage("Archiver"),
        "Archived Room": MessageLookupByLibrary.simpleMessage("Salon achivé"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Est-ce que les invités peuvent rejoindre"),
        "Are you sure?":
            MessageLookupByLibrary.simpleMessage("Êtes-vous sûr ?"),
        "Authentication":
            MessageLookupByLibrary.simpleMessage("Authentification"),
        "Avatar has been changed": MessageLookupByLibrary.simpleMessage(
            "L\'image de profil a été changée"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Bannir de la discussion"),
        "Banned": MessageLookupByLibrary.simpleMessage("Banni"),
        "Block Device":
            MessageLookupByLibrary.simpleMessage("Bloquer l\'appareil"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "Change the homeserver": MessageLookupByLibrary.simpleMessage(
            "Changer le serveur d\'accueil"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Changer le nom du groupe"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Changer de serveur"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Changer d\'image de fond"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Changez votre style"),
        "Changelog":
            MessageLookupByLibrary.simpleMessage("Journal des changements"),
        "Chat": MessageLookupByLibrary.simpleMessage("Discussion"),
        "Chat details":
            MessageLookupByLibrary.simpleMessage("Détails de la discussion"),
        "Choose a strong password": MessageLookupByLibrary.simpleMessage(
            "Choisissez un mot de passe fort"),
        "Choose a username": MessageLookupByLibrary.simpleMessage(
            "Choisissez un nom d\'utilisateur"),
        "Close": MessageLookupByLibrary.simpleMessage("Fermer"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
        "Connect": MessageLookupByLibrary.simpleMessage("Se connecter"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Tentative de connexion echouée"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Le contact a été invité au groupe"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Visionneuse de contenu"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Copié dans le presse-papier"),
        "Copy": MessageLookupByLibrary.simpleMessage("Copier"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Impossible de changer d\'image de profil"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Impossible de changer de nom"),
        "Create": MessageLookupByLibrary.simpleMessage("Créer"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Créer un compte"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Créer un nouveau groupe"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Actif en ce moment"),
        "Dark": MessageLookupByLibrary.simpleMessage("Sombre"),
        "Delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Supprimer le message"),
        "Deny": MessageLookupByLibrary.simpleMessage("Refuser"),
        "Device": MessageLookupByLibrary.simpleMessage("Périphérique"),
        "Devices": MessageLookupByLibrary.simpleMessage("Périphériques"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Abandonner l\'image"),
        "Displayname has been changed":
            MessageLookupByLibrary.simpleMessage("Renommage effectué"),
        "Donate": MessageLookupByLibrary.simpleMessage("Faire un don"),
        "Download file":
            MessageLookupByLibrary.simpleMessage("Télécharger le fichier"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Changer l\'instance Jitsi"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Changer de nom"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Paramètre des émoticônes"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Raccourci d\'émoticône"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Discussion vide"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Chiffrement"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Algorithme de chiffrement"),
        "Encryption is not enabled": MessageLookupByLibrary.simpleMessage(
            "Le chiffrement n\'est pas actif"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Le chiffrement de bout en bout est actuellement en béta ! Utilisez cette fonctionnalité à vos propres risques !"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Paramètres du chiffrement de bout en bout"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Entrez un nom de groupe"),
        "Enter a username": MessageLookupByLibrary.simpleMessage(
            "Entrez un nom d\'utilisateur"),
        "Enter your homeserver": MessageLookupByLibrary.simpleMessage(
            "Renseignez votre serveur d\'accueil"),
        "File name": MessageLookupByLibrary.simpleMessage("Nom du ficher"),
        "File size": MessageLookupByLibrary.simpleMessage("Taille du fichier"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Transférer"),
        "Friday": MessageLookupByLibrary.simpleMessage("Vendredi"),
        "From joining": MessageLookupByLibrary.simpleMessage(
            "À partir de l\'entrée dans le salon"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("À partir de l\'invitation"),
        "Group": MessageLookupByLibrary.simpleMessage("Groupe"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Description du groupe"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage(
                "La description du groupe a été changée"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Le groupe est public"),
        "Guests are forbidden": MessageLookupByLibrary.simpleMessage(
            "Les invités ne peuvent pas rejoindre"),
        "Guests can join": MessageLookupByLibrary.simpleMessage(
            "Les invités peuvent rejoindre"),
        "Help": MessageLookupByLibrary.simpleMessage("Aide"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "Le serveur d\'accueil n\'est pas compatible"),
        "How are you today?": MessageLookupByLibrary.simpleMessage(
            "Comment allez-vous aujourd\'hui ?"),
        "ID": MessageLookupByLibrary.simpleMessage("Identifiant"),
        "Identity": MessageLookupByLibrary.simpleMessage("Identité"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Inviter un contact"),
        "Invited": MessageLookupByLibrary.simpleMessage("Invité"),
        "Invited users only": MessageLookupByLibrary.simpleMessage(
            "Uniquement les utilisateurs invités"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "On dirait que vous n\'avez pas installé les services Google sur votre téléphone. C\'est une bonne décision pour votre vie privée ! Pour recevoir les notifications de FluffyChat, nous vous recommendons d\'utiliser microG : https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Expulser de la discussion"),
        "Last seen IP": MessageLookupByLibrary.simpleMessage(
            "Dernière addresse IP utilisée"),
        "Leave": MessageLookupByLibrary.simpleMessage("Partir"),
        "Left the chat":
            MessageLookupByLibrary.simpleMessage("A quitté la discussion"),
        "License": MessageLookupByLibrary.simpleMessage("Licence"),
        "Light": MessageLookupByLibrary.simpleMessage("Clair"),
        "Load more...": MessageLookupByLibrary.simpleMessage("Charger plus..."),
        "Loading... Please wait": MessageLookupByLibrary.simpleMessage(
            "Chargement... Merci de patienter"),
        "Login": MessageLookupByLibrary.simpleMessage("Connexion"),
        "Logout": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Promouvoir comme modérateur"),
        "Make an admin": MessageLookupByLibrary.simpleMessage(
            "Promouvoir comme administrateur"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Vérifiez que l\'identifiant est valide"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Le message sera supprimé pour tous les participants"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderateur"),
        "Monday": MessageLookupByLibrary.simpleMessage("Lundi"),
        "Mute chat": MessageLookupByLibrary.simpleMessage(
            "Mettre la discussion en sourdine"),
        "New message in FluffyChat": MessageLookupByLibrary.simpleMessage(
            "Nouveau message dans FluffyChat"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Nouvelle discussion privée"),
        "No emotes found. 😕": MessageLookupByLibrary.simpleMessage(
            "Aucune émoticône trouvée. 😕"),
        "No permission":
            MessageLookupByLibrary.simpleMessage("Aucune permission"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("Aucun salon trouvé..."),
        "None": MessageLookupByLibrary.simpleMessage("Aucun"),
        "Not supported in web": MessageLookupByLibrary.simpleMessage(
            "Non supporté par l\'application web"),
        "Oops something went wrong...": MessageLookupByLibrary.simpleMessage(
            "Oups, quelque chose s\'est mal passé..."),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Ouvrez l\'application pour lire le message"),
        "Open camera":
            MessageLookupByLibrary.simpleMessage("Ouvrir l\'appareil photo"),
        "Participating user devices":
            MessageLookupByLibrary.simpleMessage("Périphériques participants"),
        "Password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Choisir une image"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Vous devez installer Pantalaimon pour utiliser le chiffrement de bout en bout pour l\'instant."),
        "Please choose a username": MessageLookupByLibrary.simpleMessage(
            "Choisissez un nom d\'utilisateur"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Renseignez un identifiant Matrix"),
        "Please enter your password": MessageLookupByLibrary.simpleMessage(
            "Renseignez votre mot de passe"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Renseignez votre nom d\'utilisateur"),
        "Public Rooms": MessageLookupByLibrary.simpleMessage("Salons publics"),
        "Recording": MessageLookupByLibrary.simpleMessage("Enregistrement"),
        "Reject": MessageLookupByLibrary.simpleMessage("Refuser"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Rejoindre de nouveau"),
        "Remove": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Supprimer tous les autres périphériques"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Supprimer le périphérique"),
        "Remove exile":
            MessageLookupByLibrary.simpleMessage("Retirer le bannissement"),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Supprimer le message"),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(
            "Afficher les contenus riches des messages"),
        "Reply": MessageLookupByLibrary.simpleMessage("Répondre"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Demander la permission"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Demander à lire les anciens messages"),
        "Revoke all permissions": MessageLookupByLibrary.simpleMessage(
            "Révoquer toutes les permissions"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("Le salon a été mis à niveau"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Samedi"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Rechercher une discussion"),
        "Seen a long time ago": MessageLookupByLibrary.simpleMessage(
            "Vu pour la dernière fois il y a longtemps"),
        "Send": MessageLookupByLibrary.simpleMessage("Envoyer"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Envoyer un message"),
        "Send file": MessageLookupByLibrary.simpleMessage("Envoyer un fichier"),
        "Send image": MessageLookupByLibrary.simpleMessage("Envoyer une image"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Définir une image de profil"),
        "Set group description": MessageLookupByLibrary.simpleMessage(
            "Définir une description du groupe"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("Créer un lien d\'invitation"),
        "Set status": MessageLookupByLibrary.simpleMessage("Définir un statut"),
        "Settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
        "Share": MessageLookupByLibrary.simpleMessage("Partager"),
        "Sign up": MessageLookupByLibrary.simpleMessage("S\'inscrire"),
        "Skip": MessageLookupByLibrary.simpleMessage("Ignorer"),
        "Source code": MessageLookupByLibrary.simpleMessage("Code source"),
        "Start your first chat :-)": MessageLookupByLibrary.simpleMessage(
            "Démarrez votre première discussion :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Soumettre"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Dimanche"),
        "System": MessageLookupByLibrary.simpleMessage("Système"),
        "Tap to show menu": MessageLookupByLibrary.simpleMessage(
            "Tappez pour afficher le menu"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage(
                "Le chiffrement a été corrompu"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Elles ne correspondent pas"),
        "They Match":
            MessageLookupByLibrary.simpleMessage("Elles correspondent"),
        "This room has been archived.":
            MessageLookupByLibrary.simpleMessage("Ce salon a été archivé."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Jeudi"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Retenter l\'envoi"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Mardi"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Débloquer l\'appareil"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Périphérique inconnu"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Algorithme de chiffrement inconnu"),
        "Unmute chat":
            MessageLookupByLibrary.simpleMessage("Retirer la sourdine"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Utiliser des couleurs compatibles Amoled ?"),
        "Username": MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
        "Verify": MessageLookupByLibrary.simpleMessage("Vérifier"),
        "Verify User": MessageLookupByLibrary.simpleMessage(
            "Vérifier l\'utilisateur/trice"),
        "Video call": MessageLookupByLibrary.simpleMessage("Appel vidéo"),
        "Visibility of the chat history": MessageLookupByLibrary.simpleMessage(
            "Visibilité de l\'historique de la discussion"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Visible pour tous les participants"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Visible pour tout le monde"),
        "Voice message": MessageLookupByLibrary.simpleMessage("Message vocal"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Image de fond"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Mercredi"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Bienvenue dans la messagerie la plus mignonne du réseau Matrix."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Qui est autorisé à rejoindre ce groupe"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Écrivez un message..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Oui"),
        "You": MessageLookupByLibrary.simpleMessage("Vous"),
        "You are invited to this chat": MessageLookupByLibrary.simpleMessage(
            "Vous êtes invité à cette discussion"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Vous ne participez plus à cette discussion"),
        "You cannot invite yourself": MessageLookupByLibrary.simpleMessage(
            "Vous ne pouvez pas vous inviter vous-même"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Vous avez été banni de cette discussion"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Vous ne pourrez plus désactiver le chiffrement. Êtez-vous sûr ?"),
        "Your own username": MessageLookupByLibrary.simpleMessage(
            "Votre propre nom d\'utilisateur"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("adresse"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Veuillez saisir votre phrase de passe stockée de manière sécurisée ou votre clé de récupération pour mettre les clés en cache."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Pour pouvoir faire signer l\'autre personne, veuillez entrer votre phrase de passe stockée de manière sécurisée ou votre clé de récupération."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Veuillez saisir votre phrase de passe stockée de manière sécurisée ou votre clé de récupération pour vérifier votre session."),
        "askVerificationRequest": m60,
        "bannedUser": m2,
        "byDefaultYouWillBeConnectedTo": m3,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Clés mises en cache avec succès !"),
        "changedTheChatAvatar": m4,
        "changedTheChatDescriptionTo": m5,
        "changedTheChatNameTo": m6,
        "changedTheChatPermissions": m7,
        "changedTheDisplaynameTo": m8,
        "changedTheGuestAccessRules": m9,
        "changedTheGuestAccessRulesTo": m10,
        "changedTheHistoryVisibility": m11,
        "changedTheHistoryVisibilityTo": m12,
        "changedTheJoinRules": m13,
        "changedTheJoinRulesTo": m14,
        "changedTheProfileAvatar": m15,
        "changedTheRoomAliases": m16,
        "changedTheRoomInvitationLink": m17,
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Comparez et assurez-vous que les emojis suivants correspondent à ceux de l\'autre appareil :"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Comparez et assurez-vous que les chiffres suivants correspondent à ceux de l\'autre appareil :"),
        "couldNotDecryptMessage": m18,
        "countParticipants": m19,
        "createdTheChat": m20,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "La signature croisée est désactivée"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "La signature croisée est activée"),
        "dateAndTimeOfDay": m21,
        "dateWithYear": m22,
        "dateWithoutYear": m23,
        "emoteExists": MessageLookupByLibrary.simpleMessage(
            "Cette émoticône existe déjà !"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Raccourci d\'émoticône invalide !"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Vous devez sélectionner un raccourci d\'émoticône et une image !"),
        "groupWith": m24,
        "hasWithdrawnTheInvitationFor": m25,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Phrase de passe ou clé de récupération incorrecte"),
        "inviteContactToGroup": m26,
        "inviteText": m27,
        "invitedUser": m28,
        "is typing...":
            MessageLookupByLibrary.simpleMessage("est en train d\'écrire..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "La clé de l\'appareil ci-dessous est-elle correcte ?"),
        "joinedTheChat": m29,
        "keysCached": MessageLookupByLibrary.simpleMessage(
            "Les clés sont mises en cache"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Les clés sont manquantes"),
        "kicked": m30,
        "kickedAndBanned": m31,
        "lastActiveAgo": m32,
        "loadCountMoreParticipants": m33,
        "logInTo": m34,
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(
            "Nouvelle demande de vérification !"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat ne permet pas actuellement d\'activer la signature croisée. Veuillez l\'activer à partir de Element."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat ne prend pas actuellement en charge l\'activation de la sauvegarde des clés en ligne. Veuillez l\'activer à partir de Element."),
        "numberSelected": m35,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "La sauvegarde en ligne des clés est désactivée"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "La sauvegarde en ligne des clés est activée"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Phrase de passe ou clé de récupération"),
        "play": m36,
        "redactedAnEvent": m37,
        "rejectedTheInvitation": m38,
        "removedBy": m39,
        "seenByUser": m40,
        "seenByUserAndCountOthers": m41,
        "seenByUserAndUser": m42,
        "sentAFile": m43,
        "sentAPicture": m44,
        "sentASticker": m45,
        "sentAVideo": m46,
        "sentAnAudio": m47,
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("La session est vérifiée"),
        "sharedTheLocation": m48,
        "timeOfDay": m49,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m50,
        "unknownEvent": m51,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Session inconnue, veuillez vérifier"),
        "unreadChats": m52,
        "unreadMessages": m53,
        "unreadMessagesInChats": m54,
        "userAndOthersAreTyping": m55,
        "userAndUserAreTyping": m56,
        "userIsTyping": m57,
        "userLeftTheChat": m58,
        "userSentUnknownEvent": m59,
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Session vérifiée avec succès !"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Vérifier manuellement"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Commencer la vérification"),
        "verifySuccess": MessageLookupByLibrary.simpleMessage(
            "Vous avez vérifié avec succès !"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(
            "Vérification de l\'autre compte"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "En attente de la vérification de la demande par le partenaire..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "En attente de l\'acceptation de l\'émoji par le partenaire..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "En attente de l\'acceptation des nombres par le partenaire...")
      };
}

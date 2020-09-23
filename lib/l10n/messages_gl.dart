// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a gl locale. All the
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
  String get localeName => 'gl';

  static m0(username) => "${username} aceptou o convite";

  static m1(username) => "${username} activou o cifrado extremo-a-extremo";

  static m2(senderName) => "${senderName} respondeu á chamada";

  static m3(username) =>
      "¿Aceptar a solicitude de verificación de ${username}?";

  static m4(username, targetName) => "${username} vetou a ${targetName}";

  static m5(homeserver) => "Por omisión vas conectar con ${homeserver}";

  static m6(username) => "${username} cambiou o avatar do chat";

  static m7(username, description) =>
      "${username} mudou a descrición da conversa a: \'${description}\'";

  static m8(username, chatname) =>
      "${username} mudou o nome da conversa a: \'${chatname}\'";

  static m9(username) => "${username} mudou os permisos da conversa";

  static m10(username, displayname) =>
      "${username} cambiou o nome público a: ${displayname}";

  static m11(username) =>
      "${username} mudou as regras de acceso para convidadas";

  static m12(username, rules) =>
      "${username} mudou as regras de acceso para convidadas a: ${rules}";

  static m13(username) => "${username} mudou a visibilidade do historial";

  static m14(username, rules) =>
      "${username} mudou a visibilidade do historial a: ${rules}";

  static m15(username) => "${username} mudou as regras de acceso";

  static m16(username, joinRules) =>
      "${username} mudou as regras de acceso a: ${joinRules}";

  static m17(username) => "${username} mudou o avatar";

  static m18(username) => "${username} mudou os alias da sala";

  static m19(username) => "${username} mudou a ligazón de convite";

  static m20(error) => "Non se descifrou a mensaxe: ${error}";

  static m21(count) => "${count} participantes";

  static m22(username) => "${username} creou a conversa";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}-${month}-${year}";

  static m25(month, day) => "${day}-${month}";

  static m26(senderName) => "${senderName} rematou a chamada";

  static m27(displayname) => "Grupo con ${displayname}";

  static m28(username, targetName) =>
      "${username} retirou o convite para ${targetName}";

  static m29(groupName) => "Convidar contacto a ${groupName}";

  static m30(username, link) =>
      "${username} convidoute a FluffyChat.\n1. instala FluffyChat:  https://fluffychat.im \n2. Rexístrate ou conéctate\n3. Abre a ligazón do convite: ${link}";

  static m31(username, targetName) => "${username} convidou a ${targetName}";

  static m32(username) => "${username} uníuse ó chat";

  static m33(username, targetName) => "${username} expulsou a ${targetName}";

  static m34(username, targetName) =>
      "${username} expulsou e vetou a ${targetName}";

  static m35(localizedTimeShort) => "Última actividade: ${localizedTimeShort}";

  static m36(count) => "Cargar ${count} participantes máis";

  static m37(homeserver) => "Conectar con ${homeserver}";

  static m38(number) => "${number} seleccionados";

  static m39(fileName) => "Reproducir ${fileName}";

  static m40(username) => "${username} publicou un evento";

  static m41(username) => "${username} rexeitou o convite";

  static m42(username) => "Eliminado por ${username}";

  static m43(username) => "Visto por ${username}";

  static m44(username, count) => "Visto por ${username} e ${count} outras";

  static m45(username, username2) => "Visto por ${username} e ${username2}";

  static m46(username) => "${username} enviou un ficheiro";

  static m47(username) => "${username} enviou unha imaxe";

  static m48(username) => "${username} enviou un adhesivo";

  static m49(username) => "${username} enviou un vídeo";

  static m50(username) => "${username} enviou un audio";

  static m51(senderName) => "${senderName} enviou informacións da chamada";

  static m52(username) => "${username} compartiu a localización";

  static m53(senderName) => "${senderName} iniciou unha chamada";

  static m54(hours12, hours24, minutes, suffix) =>
      "${hours12}:${minutes} ${suffix}";

  static m55(username, targetName) =>
      "${username} retirou o veto a ${targetName}";

  static m56(type) => "Evento descoñecido \'${type}\'";

  static m57(unreadCount) => "${unreadCount} chats non lidos";

  static m58(unreadEvents) => "${unreadEvents} mensaxes non lidas";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} mensaxes non lidas en ${unreadChats} conversas";

  static m60(username, count) =>
      "${username} e ${count} máis están escribindo...";

  static m61(username, username2) =>
      "${username} e ${username2} están escribindo...";

  static m62(username) => "${username} está escribindo...";

  static m63(username) => "${username} deixou a conversa";

  static m64(username, type) => "${username} enviou un evento {type]";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Acerca de"),
        "accept": MessageLookupByLibrary.simpleMessage("Aceptar"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Conta"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Información da conta"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription": MessageLookupByLibrary.simpleMessage(
            "Engade a descrición do grupo"),
        "admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("¿xa tes unha conta?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Calquera pode unirse"),
        "archive": MessageLookupByLibrary.simpleMessage("Arquivo"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("Sala arquivada"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Teñen permitido as convidadas o acceso"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("¿estás certo?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Escribe a frase de paso de seguridade ou chave de recuperación para almacenar as chaves."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Para poder conectar a outra persoa, escribe a túa frase de paso ou chave de recuperación."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Escribe frase de paso de almacenaxe segura ou chave de recuperación para verificar a túa sesión."),
        "askVerificationRequest": m3,
        "authentication": MessageLookupByLibrary.simpleMessage("Autenticación"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("O avatar cambiou"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Expulsar da conversa"),
        "banned": MessageLookupByLibrary.simpleMessage("Vetada"),
        "bannedUser": m4,
        "blockDevice":
            MessageLookupByLibrary.simpleMessage("Bloquear dispositivo"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Almacenaches as chaves correctamente!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Mudar de servidor de inicio"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Mudar o nome do grupo"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Mudar de servidor"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Cambiar o estilo"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Mudar fondo do chat"),
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
            MessageLookupByLibrary.simpleMessage("Rexistro de cambios"),
        "changesHaveBeenSaved":
            MessageLookupByLibrary.simpleMessage("Gardáronse os cambios"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("O cifrado está corrompido"),
        "chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("Detalles do chat"),
        "chooseAStrongPassword": MessageLookupByLibrary.simpleMessage(
            "Escolle un contrasinal forte"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Escolle un nome de usuaria"),
        "close": MessageLookupByLibrary.simpleMessage("Pechar"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Comparar e asegurarse de que estas emoticonas concordan no outro dispositivo:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Compara e asegúrate de que os seguintes números concordan cos do outro dispositivo:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "connect": MessageLookupByLibrary.simpleMessage("Conectar"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Fallou o intento de conexión"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "O contacto foi convidado ó grupo"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Visor de contido"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Copiado ó portapapeis"),
        "copy": MessageLookupByLibrary.simpleMessage("Copiar"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar":
            MessageLookupByLibrary.simpleMessage("Non se estableceu o avatar"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Non se estableceu o nome público"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Crear"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Crear unha conta"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Crear novo grupo"),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "A Sinatura-Cruzada está desactivada"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Sinatura-Cruzada activada"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Actualmente activo"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Escuro"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "deactivateAccountWarning": MessageLookupByLibrary.simpleMessage(
            "Esto desactivará a conta. Esto non ten volta atrás. Estás segura?"),
        "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Eliminar conta"),
        "deleteMessage":
            MessageLookupByLibrary.simpleMessage("Eliminar mensaxe"),
        "deny": MessageLookupByLibrary.simpleMessage("Denegar"),
        "device": MessageLookupByLibrary.simpleMessage("Dispositivo"),
        "devices": MessageLookupByLibrary.simpleMessage("Dispositivos"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Desbotar imaxe"),
        "displaynameHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("O nome público mudou"),
        "donate": MessageLookupByLibrary.simpleMessage("Doar"),
        "downloadFile":
            MessageLookupByLibrary.simpleMessage("Descargar ficheiro"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Editar nome público"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Editar instancia Jitsi"),
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Xa existe ese emote!"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Atallo do emote non é válido!"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Axustes de Emote"),
        "emoteShortcode":
            MessageLookupByLibrary.simpleMessage("Atallo de Emote"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Escribe un atallo e asocialle unha imaxe!"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Chat baleiro"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Non poderás desactivar o cifrado posteriormente, ¿estás certo?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Cifrado"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Algoritmo do cifrado"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("Cifrado desactivado"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Axustes do cifrado extremo-a-extremo"),
        "endedTheCall": m26,
        "enterAGroupName": MessageLookupByLibrary.simpleMessage(
            "Escribe un nome para o grupo"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Escribe un nome de usuaria"),
        "enterYourHomeserver": MessageLookupByLibrary.simpleMessage(
            "Escribe o teu servidor de inicio"),
        "fileName": MessageLookupByLibrary.simpleMessage("Nome do ficheiro"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Tamaño do ficheiro"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Reenviar"),
        "friday": MessageLookupByLibrary.simpleMessage("Venres"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("Desde que se una"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("Desde o convite"),
        "group": MessageLookupByLibrary.simpleMessage("Grupo"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Descrición do grupo"),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Mudou a descrición do grupo"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("O grupo é público"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("Non se permiten convidadas"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Permítense convidadas"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Axuda"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(
            "Servidor de inicio non compatible"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Identidade"),
        "ignoreListDescription": MessageLookupByLibrary.simpleMessage(
            "Podes ignorar usuarias molestas. Non recibirás ningunha mensaxe nin convites a salas da túa lista personal de usuarias ignoradas."),
        "ignoreUsername":
            MessageLookupByLibrary.simpleMessage("Ignorar nome de usuaria"),
        "ignoredUsers":
            MessageLookupByLibrary.simpleMessage("Usuarias ignoradas"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Frase de paso ou chave de recuperación incorrecta"),
        "inviteContact":
            MessageLookupByLibrary.simpleMessage("Convidar contacto"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Convidado"),
        "invitedUser": m31,
        "invitedUsersOnly":
            MessageLookupByLibrary.simpleMessage("Só usuarias convidadas"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "¿É correcta esta chave do dispositivo?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("está escribindo..."),
        "joinRoom": MessageLookupByLibrary.simpleMessage("Entrar na sala"),
        "joinedTheChat": m32,
        "keysCached":
            MessageLookupByLibrary.simpleMessage("Chaves almacenadas"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Faltan as chaves"),
        "kickFromChat":
            MessageLookupByLibrary.simpleMessage("Expulsar da conversa"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage("Última IP vista"),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("Hai moito que non aparece"),
        "leave": MessageLookupByLibrary.simpleMessage("Saír"),
        "leftTheChat":
            MessageLookupByLibrary.simpleMessage("Deixar a conversa"),
        "license": MessageLookupByLibrary.simpleMessage("Licenza"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Claro"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Cargar máis..."),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("Cargando... Agarda"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Conexión"),
        "logout": MessageLookupByLibrary.simpleMessage("Desconectar"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Converter en moderadora"),
        "makeAnAdmin":
            MessageLookupByLibrary.simpleMessage("Converter en administradora"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Asegúrate de que o identificador é válido"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "A mensaxe eliminarase para todas as participantes"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderadora"),
        "monday": MessageLookupByLibrary.simpleMessage("Luns"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Acalar conversa"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Ten en conta que polo de agora precisas Pantalaimon para o cifrado extremo-a-extremo."),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("Nova mensaxe en FluffyChat"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Nova conversa privada"),
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(
            "Nova solicitude de verificación!"),
        "no": MessageLookupByLibrary.simpleMessage("Non"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Polo momento FluffyChat non soporta a activación da Sinatura-Cruzada. Actívaa desde Element."),
        "noEmotesFound":
            MessageLookupByLibrary.simpleMessage("Non hai emotes. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Semella que non tes os servizos de google no teu dispositivo. Ben feito! a túa privacidade agradécecho! Para recibir notificacións push en FluffyChat recomendamos usar microG: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Actualmente Fluffychat non soporta a activación da Copia En Liña das Chaves. Actívaa desde Element."),
        "noPermission": MessageLookupByLibrary.simpleMessage("Sen permiso"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("Non se atoparon salas..."),
        "none": MessageLookupByLibrary.simpleMessage("Ningún"),
        "notSupportedInWeb":
            MessageLookupByLibrary.simpleMessage("Non soportado na web"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Copia de apoio En liña das Chaves desactivada"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Copia de Apoio das Chaves activada"),
        "oopsSomethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Ooooi, algo fallou..."),
        "openAppToReadMessages":
            MessageLookupByLibrary.simpleMessage("Abrir a app e ler mensaxes"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Abrir cámara"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Optativo) Nome do grupo"),
        "participatingUserDevices": MessageLookupByLibrary.simpleMessage(
            "Dispositivos das usuarias participantes"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "frase de paso ou chave de recuperación"),
        "password": MessageLookupByLibrary.simpleMessage("Contrasinal"),
        "passwordHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Cambiaches o contrasinal"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Escolle unha imaxe"),
        "pin": MessageLookupByLibrary.simpleMessage("Fixar"),
        "play": m39,
        "pleaseChooseAUsername":
            MessageLookupByLibrary.simpleMessage("Escolle un nome de usuaria"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Escribe un identificador matrix"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("Escribe o teu contrasinal"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Escribe o teu nome de usuaria"),
        "publicRooms": MessageLookupByLibrary.simpleMessage("Salas públicas"),
        "recording": MessageLookupByLibrary.simpleMessage("Gravando"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Rexeitar"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Volta a unirte"),
        "remove": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(
            "Quitar todos os outros dispositivos"),
        "removeDevice":
            MessageLookupByLibrary.simpleMessage("Quitar dispositivo"),
        "removeExile": MessageLookupByLibrary.simpleMessage("Quitar o veto"),
        "removeMessage":
            MessageLookupByLibrary.simpleMessage("Eliminar mensaxe"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(
            "Mostrar contido enriquecido da mensaxe"),
        "reply": MessageLookupByLibrary.simpleMessage("Responder"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Solicitar permiso"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Solicitar ler mensaxes antigas"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("Revogar tódolos permisos"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("A sala foi actualizada"),
        "saturday": MessageLookupByLibrary.simpleMessage("Sábado"),
        "searchForAChat":
            MessageLookupByLibrary.simpleMessage("Buscar un chat"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Enviar"),
        "sendAMessage":
            MessageLookupByLibrary.simpleMessage("Enviar unha mensaxe"),
        "sendAudio": MessageLookupByLibrary.simpleMessage("Enviar audio"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "Permitir o envío de informes de fallos con sentry.io"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Enviar ficheiro"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Enviar imaxe"),
        "sendOriginal": MessageLookupByLibrary.simpleMessage("Enviar orixinal"),
        "sendVideo": MessageLookupByLibrary.simpleMessage("Enviar vídeo"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "Información sobre privacidade: https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Sesión verificada"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Establecer foto do perfil"),
        "setGroupDescription": MessageLookupByLibrary.simpleMessage(
            "Establecer descrición do grupo"),
        "setInvitationLink": MessageLookupByLibrary.simpleMessage(
            "Establecer ligazón do convite"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Establecer estado"),
        "settings": MessageLookupByLibrary.simpleMessage("Axustes"),
        "share": MessageLookupByLibrary.simpleMessage("Compartir"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Rexistro"),
        "skip": MessageLookupByLibrary.simpleMessage("Saltar"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Código fonte"),
        "startYourFirstChat": MessageLookupByLibrary.simpleMessage(
            "Abre a primeira conversa :-)"),
        "startedACall": m53,
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("¿Que tal estás hoxe?"),
        "submit": MessageLookupByLibrary.simpleMessage("Enviar"),
        "sunday": MessageLookupByLibrary.simpleMessage("Domingo"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Sistema"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("Toca para mostrar menú"),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage("Non concordan"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("Concordan"),
        "thisRoomHasBeenArchived":
            MessageLookupByLibrary.simpleMessage("A sala foi arquivada."),
        "thursday": MessageLookupByLibrary.simpleMessage("Xoves"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Inténtao outra vez"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Martes"),
        "unbannedUser": m55,
        "unblockDevice":
            MessageLookupByLibrary.simpleMessage("Desbloquear dispositivo"),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Dispositivo descoñecido"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Algoritmo de cifrado descoñecido"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Sesión descoñecida, por favor verifícaa"),
        "unmuteChat": MessageLookupByLibrary.simpleMessage("Reactivar chat"),
        "unpin": MessageLookupByLibrary.simpleMessage("Desafixar"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "¿Usar cores compatibles con Amoled?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Nome de usuaria"),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Sesión verificada correctamente!"),
        "verify": MessageLookupByLibrary.simpleMessage("Verificar"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verificar manualmente"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Comezar verificación"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Verificaches correctamente!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Verificando a outra conta"),
        "verifyUser": MessageLookupByLibrary.simpleMessage("Verificar usuaria"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Chamada de vídeo"),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(
            "Visibilidade do historial da conversa"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Visible para todas as participantes"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Visible para todas"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Mensaxe de voz"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Agardando a que a outra parte acepte a solicitude..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Agardando a que a outra parte acepte as emoticonas..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Agardando a que a outra parte acepte os números..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Fondo da conversa"),
        "warning": MessageLookupByLibrary.simpleMessage("Aviso!"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "O cifrado extremo-a-extremo está en Beta! Úsao baixo a túa responsabilidade!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Mércores"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Benvida á mensaxería instantánea más cuquiña da rede matrix."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Quen se pode unir a este grupo"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Escribe unha mensaxe..."),
        "yes": MessageLookupByLibrary.simpleMessage("Si"),
        "you": MessageLookupByLibrary.simpleMessage("Ti"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("Estás convidada a este chat"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Xa non participas desta conversa"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("Non podes autoconvidarte"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Foches vetada nesta conversa"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("O teu nome de usuaria")
      };
}

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static m0(username) => "${username} aceptó la invitación";

  static m1(username) => "${username} activó el cifrado de extremo a extremo";

  static m2(senderName) => "${senderName} respondió a la llamada";

  static m3(username) =>
      "¿Aceptar esta solicitud de verificación de ${username}?";

  static m4(username, targetName) => "${username} vetó a ${targetName}";

  static m5(homeserver) =>
      "De forma predeterminada estará conectado a ${homeserver}";

  static m6(username) => "${username} cambió el icono del chat";

  static m7(username, description) =>
      "${username} cambió la descripción del chat a: \'${description}\'";

  static m8(username, chatname) =>
      "${username} cambió el nombre del chat a: \'${chatname}\'";

  static m9(username) => "${username} cambió los permisos del chat";

  static m10(username, displayname) =>
      "${username} cambió su nombre visible a: ${displayname}";

  static m11(username) =>
      "${username} cambió las reglas de acceso de visitantes";

  static m12(username, rules) =>
      "${username} cambió las reglas de acceso de visitantes a: ${rules}";

  static m13(username) => "${username} cambió la visibilidad del historial";

  static m14(username, rules) =>
      "${username} cambió la visibilidad del historial a: ${rules}";

  static m15(username) => "${username} cambió las reglas de ingreso";

  static m16(username, joinRules) =>
      "${username} cambió las reglas de ingreso a ${joinRules}";

  static m17(username) => "${username} cambió su imagen de perfil";

  static m18(username) => "${username} cambió el alias de la sala";

  static m19(username) => "${username} cambió el enlace de invitación";

  static m20(error) => "No se pudo descifrar el mensaje: ${error}";

  static m21(count) => "${count} participantes";

  static m22(username) => "${username} creó el chat";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}/${month}/${year}";

  static m25(month, day) => "${day}/${month}";

  static m26(senderName) => "${senderName} terminó la llamada";

  static m27(displayname) => "Grupo con ${displayname}";

  static m28(username, targetName) =>
      "${username} ha retirado la invitación para ${targetName}";

  static m29(groupName) => "Invitar contacto a ${groupName}";

  static m30(username, link) =>
      "${username} te invitó a FluffyChat.\n1. Instale FluffyChat: https://fluffychat.im\n2. Regístrate o inicia sesión \n3. Abra el enlace de invitación: ${link}";

  static m31(username, targetName) => "${username} invitó a ${targetName}";

  static m32(username) => "${username} se unió al chat";

  static m33(username, targetName) => "${username} echó a ${targetName}";

  static m34(username, targetName) => "${username} echó y vetó a ${targetName}";

  static m35(localizedTimeShort) => "Última vez activo: ${localizedTimeShort}";

  static m36(count) => "Mostrar ${count} participantes más";

  static m37(homeserver) => "Iniciar sesión en ${homeserver}";

  static m38(number) => "${number} seleccionado(s)";

  static m39(fileName) => "Reproducir ${fileName}";

  static m40(username) => "${username} redactó un evento";

  static m41(username) => "${username} rechazó la invitación";

  static m42(username) => "Eliminado por ${username}";

  static m43(username) => "Visto por ${username}";

  static m44(username, count) => "Visto por ${username} y ${count} más";

  static m45(username, username2) => "Visto por ${username} y ${username2}";

  static m46(username) => "${username} envió un archivo";

  static m47(username) => "${username} envió una imagen";

  static m48(username) => "${username} envió un sticker";

  static m49(username) => "${username} envió un video";

  static m50(username) => "${username} envió un audio";

  static m51(senderName) => "${senderName} envió información de la llamada";

  static m52(username) => "${username} compartió la ubicación";

  static m53(senderName) => "${senderName} comenzó una llamada";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) =>
      "${username} admitió a ${targetName} nuevamente";

  static m56(type) => "Evento desconocido \'${type}\'";

  static m57(unreadCount) => "${unreadCount} chats no leídos";

  static m58(unreadEvents) => "${unreadEvents} mensajes no leídos";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} mensajes no leídos en ${unreadChats} chats";

  static m60(username, count) =>
      "${username} y ${count} más están escribiendo...";

  static m61(username, username2) =>
      "${username} y ${username2} están escribiendo...";

  static m62(username) => "${username} está escribiendo...";

  static m63(username) => "${username} abandonó el chat";

  static m64(username, type) => "${username} envió un evento ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Acerca de"),
        "accept": MessageLookupByLibrary.simpleMessage("Aceptar"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Cuenta"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Información de la cuenta"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription": MessageLookupByLibrary.simpleMessage(
            "Agregar una descripción al grupo"),
        "admin": MessageLookupByLibrary.simpleMessage("Administrador"),
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("¿Ya tienes una cuenta?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Cualquiera puede unirse"),
        "archive": MessageLookupByLibrary.simpleMessage("Archivo"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("Sala archivada"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "¿Pueden unirse los usuarios visitantes?"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("¿Estás seguro?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Ingrese su contraseña de almacenamiento segura (SSSS) o la clave de recuperación para almacenar en caché las claves."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Para poder confirmar a la otra persona, ingrese su contraseña de almacenamiento segura o la clave de recuperación."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Por favor, ingrese su contraseña de almacenamiento seguro (SSSS) o la clave de recuperación para verificar su sesión."),
        "askVerificationRequest": m3,
        "authentication": MessageLookupByLibrary.simpleMessage("Autenticación"),
        "avatarHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "La imagen de perfil ha sido cambiada"),
        "banFromChat": MessageLookupByLibrary.simpleMessage("Vetar del chat"),
        "banned": MessageLookupByLibrary.simpleMessage("Vetado"),
        "bannedUser": m4,
        "blockDevice":
            MessageLookupByLibrary.simpleMessage("Bloquear dispositivo"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "¡Las claves se han almacenado exitosamente!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Cambiar el servidor"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Cambiar el nombre del grupo"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Cambiar el servidor"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Cambia tu estilo"),
        "changeWallpaper": MessageLookupByLibrary.simpleMessage(
            "Cambiar el fondo de pantalla"),
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
            MessageLookupByLibrary.simpleMessage("Registro de cambios"),
        "changesHaveBeenSaved":
            MessageLookupByLibrary.simpleMessage("Los cambios se han guardado"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("El cifrado se ha corrompido"),
        "chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "chatDetails":
            MessageLookupByLibrary.simpleMessage("Detalles del chat"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Elija una contraseña segura"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Elija un nombre de usuario"),
        "close": MessageLookupByLibrary.simpleMessage("Cerrar"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Compare y asegúrese de que los siguientes emoji coincidan con los del otro dispositivo:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Compare y asegúrese de que los siguientes números coincidan con los del otro dispositivo:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "connect": MessageLookupByLibrary.simpleMessage("Conectar"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Falló el intento de conexión"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "El contacto ha sido invitado al grupo"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Visor de contenido"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Copiado al portapapeles"),
        "copy": MessageLookupByLibrary.simpleMessage("Copiar"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "No se pudo establecer la imagen de perfil"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "No se pudo establecer el nombre visible"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Crear"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Crear cuenta ahora"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Crear grupo nuevo"),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "La confirmación cruzada está deshabilitada"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "La confirmación cruzada está habilitada"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Actualmente activo"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Oscuro"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "deleteMessage":
            MessageLookupByLibrary.simpleMessage("Eliminar mensaje"),
        "deny": MessageLookupByLibrary.simpleMessage("Rechazar"),
        "device": MessageLookupByLibrary.simpleMessage("Dispositivo"),
        "devices": MessageLookupByLibrary.simpleMessage("Dispositivos"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Descartar imagen"),
        "displaynameHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "El nombre visible ha cambiado"),
        "donate": MessageLookupByLibrary.simpleMessage("Donar"),
        "downloadFile":
            MessageLookupByLibrary.simpleMessage("Descargar archivo"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Editar nombre visible"),
        "editJitsiInstance": MessageLookupByLibrary.simpleMessage(
            "Cambiar la instancia de Jitsi"),
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("¡El emote ya existe!"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "¡El atajo del emote es inválido!"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Configuración de emotes"),
        "emoteShortcode":
            MessageLookupByLibrary.simpleMessage("Atajo de emote"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "¡Debes elegir un atajo de emote y una imagen!"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Chat vacío"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Ya no podrá deshabilitar el cifrado. ¿Estás seguro?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Cifrado"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Algoritmo de cifrado"),
        "encryptionNotEnabled": MessageLookupByLibrary.simpleMessage(
            "El cifrado no está habilitado"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Configuración del cifrado de extremo a extremo"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Ingrese un nombre de grupo"),
        "enterAUsername": MessageLookupByLibrary.simpleMessage(
            "Ingrese un nombre de usuario"),
        "enterYourHomeserver":
            MessageLookupByLibrary.simpleMessage("Ingrese su servidor"),
        "fileName": MessageLookupByLibrary.simpleMessage("Nombre del archivo"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Tamaño del archivo"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Reenviar"),
        "friday": MessageLookupByLibrary.simpleMessage("Viernes"),
        "fromJoining":
            MessageLookupByLibrary.simpleMessage("Desde que se unió"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("Desde la invitación"),
        "group": MessageLookupByLibrary.simpleMessage("Grupo"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Descripción del grupo"),
        "groupDescriptionHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "La descripción del grupo ha sido cambiada"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("El grupo es público"),
        "groupWith": m27,
        "guestsAreForbidden": MessageLookupByLibrary.simpleMessage(
            "Los visitantes están prohibidos"),
        "guestsCanJoin": MessageLookupByLibrary.simpleMessage(
            "Los visitantes pueden unirse"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Ayuda"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(
            "El servidor no es compatible"),
        "id": MessageLookupByLibrary.simpleMessage("Identificación"),
        "identity": MessageLookupByLibrary.simpleMessage("Identidad"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Frase de contraseña o clave de recuperación incorrecta"),
        "inviteContact":
            MessageLookupByLibrary.simpleMessage("Invitar contacto"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Invitado"),
        "invitedUser": m31,
        "invitedUsersOnly":
            MessageLookupByLibrary.simpleMessage("Sólo usuarios invitados"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "¿Es correcta la siguiente clave de dispositivo?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("está escribiendo..."),
        "joinRoom": MessageLookupByLibrary.simpleMessage("Unirse a la sala"),
        "joinedTheChat": m32,
        "keysCached":
            MessageLookupByLibrary.simpleMessage("Las claves están en caché"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Faltan las claves"),
        "kickFromChat": MessageLookupByLibrary.simpleMessage("Echar del chat"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp":
            MessageLookupByLibrary.simpleMessage("Última dirección IP vista"),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("Visto hace mucho tiempo"),
        "leave": MessageLookupByLibrary.simpleMessage("Abandonar"),
        "leftTheChat": MessageLookupByLibrary.simpleMessage("Abandonó el chat"),
        "license": MessageLookupByLibrary.simpleMessage("Licencia"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Claro"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Mostrar más..."),
        "loadingPleaseWait": MessageLookupByLibrary.simpleMessage(
            "Cargando... Por favor espere"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Hacer un moderador/a"),
        "makeAnAdmin":
            MessageLookupByLibrary.simpleMessage("Hacer un administrador/a"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Asegúrese de que el identificador es válido"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "El mensaje será eliminado para todos los participantes"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderador"),
        "monday": MessageLookupByLibrary.simpleMessage("Lunes"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Silenciar chat"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Tenga en cuenta que necesita Pantalaimon para utilizar el cifrado de extremo a extremo por ahora."),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("Nuevo mensaje en FluffyChat"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Nuevo chat privado"),
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(
            "¡Nueva solicitud de verificación!"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat actualmente no soporta la activación de Cross-Signing. Por favor, actívelo dentro de Riot."),
        "noEmotesFound":
            MessageLookupByLibrary.simpleMessage("Ningún emote encontrado. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Parece que no tienes servicios de Google en tu teléfono. ¡Esa es una buena decisión para tu privacidad! Para recibir notificaciones instantáneas en FluffyChat, recomendamos usar microG: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat actualmente no soporta la activación de Online Key Backup. Por favor, actívalo dentro de Riot."),
        "noPermission":
            MessageLookupByLibrary.simpleMessage("Sin autorización"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("Ninguna sala encontrada..."),
        "none": MessageLookupByLibrary.simpleMessage("Ninguno"),
        "notSupportedInWeb": MessageLookupByLibrary.simpleMessage(
            "No es compatible con la versión web"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "La copia de seguridad de la clave en línea está deshabilitada"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "La copia de seguridad de la clave en línea está habilitada"),
        "oopsSomethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Ups, algo salió mal..."),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "Abrir la aplicación para leer los mensajes"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Abrir la cámara"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Opcional) Nombre del grupo"),
        "participatingUserDevices": MessageLookupByLibrary.simpleMessage(
            "Dispositivos de usuario participantes"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "contraseña o clave de recuperación"),
        "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Elegir imagen"),
        "pin": MessageLookupByLibrary.simpleMessage("Pin"),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Por favor, elija un nombre de usuario"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Por favor, ingrese un identificador matrix"),
        "pleaseEnterYourPassword": MessageLookupByLibrary.simpleMessage(
            "Por favor ingrese su contraseña"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Por favor ingrese su nombre de usuario"),
        "publicRooms": MessageLookupByLibrary.simpleMessage("Salas públicas"),
        "recording": MessageLookupByLibrary.simpleMessage("Grabando"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Rechazar"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Volver a unirse"),
        "remove": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(
            "Eliminar todos los otros dispositivos"),
        "removeDevice":
            MessageLookupByLibrary.simpleMessage("Eliminar dispositivo"),
        "removeExile":
            MessageLookupByLibrary.simpleMessage("Eliminar la expulsión"),
        "removeMessage":
            MessageLookupByLibrary.simpleMessage("Eliminar mensaje"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(
            "Mostrar el contenido con mensajes enriquecidos"),
        "reply": MessageLookupByLibrary.simpleMessage("Responder"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Solicitar permiso"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Solicitar poder leer mensajes antiguos"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("Revocar todos los permisos"),
        "roomHasBeenUpgraded": MessageLookupByLibrary.simpleMessage(
            "La sala ha subido de categoría"),
        "saturday": MessageLookupByLibrary.simpleMessage("Sábado"),
        "searchForAChat":
            MessageLookupByLibrary.simpleMessage("Buscar un chat"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Enviar"),
        "sendAMessage":
            MessageLookupByLibrary.simpleMessage("Enviar un mensaje"),
        "sendAudio": MessageLookupByLibrary.simpleMessage("Enviar audio"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "Permite el envió de informes de errores con sentry.io"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Enviar un archivo"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Enviar una imagen"),
        "sendOriginal":
            MessageLookupByLibrary.simpleMessage("Enviar el original"),
        "sendVideo": MessageLookupByLibrary.simpleMessage("Enviar video"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "Informacion sobre tu privacidad: https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("La sesión está verificada"),
        "setAProfilePicture": MessageLookupByLibrary.simpleMessage(
            "Establecer una foto de perfil"),
        "setGroupDescription": MessageLookupByLibrary.simpleMessage(
            "Establecer descripción del grupo"),
        "setInvitationLink": MessageLookupByLibrary.simpleMessage(
            "Establecer enlace de invitación"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Establecer estado"),
        "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "share": MessageLookupByLibrary.simpleMessage("Compartir"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "skip": MessageLookupByLibrary.simpleMessage("Omitir"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Código fuente"),
        "startYourFirstChat":
            MessageLookupByLibrary.simpleMessage("Comience su primer chat :-)"),
        "startedACall": m53,
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("¿Cómo estás hoy?"),
        "submit": MessageLookupByLibrary.simpleMessage("Enviar"),
        "sunday": MessageLookupByLibrary.simpleMessage("Domingo"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Sistema"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("Toca para mostrar el menú"),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage("No coinciden"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("Coinciden"),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(
            "Esta sala ha sido archivada."),
        "thursday": MessageLookupByLibrary.simpleMessage("Jueves"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Intentar enviar nuevamente"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Martes"),
        "unbannedUser": m55,
        "unblockDevice":
            MessageLookupByLibrary.simpleMessage("Desbloquear dispositivo"),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Dispositivo desconocido"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Algoritmo de cifrado desconocido"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Sesión desconocida, por favor verifíquela"),
        "unmuteChat":
            MessageLookupByLibrary.simpleMessage("Dejar de silenciar el chat"),
        "unpin": MessageLookupByLibrary.simpleMessage("Despinchar"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "¿Usar colores compatibles con AMOLED?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Nombre de usuario"),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "¡Sesión verificada exitosamente!"),
        "verify": MessageLookupByLibrary.simpleMessage("Verificar"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verificar manualmente"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Comenzar verificación"),
        "verifySuccess": MessageLookupByLibrary.simpleMessage(
            "¡Has verificado exitosamente!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Verificando la otra cuenta"),
        "verifyUser": MessageLookupByLibrary.simpleMessage("Verificar usuario"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Video llamada"),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(
            "Visibilidad del historial del chat"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Visible para todos los participantes"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Visible para todo el mundo"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Mensaje de voz"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Esperando a que el socio acepte la solicitud..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Esperando a que el socio acepte los emojis..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Esperando a que el socio acepte los números..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Fondo de pantalla"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "¡El cifrado de extremo a extremo está actualmente en período de prueba! ¡Úselo bajo su propio riesgo!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Miércoles"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Bienvenidos al mensajero instantáneo más lindo de la red matricial."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Quién tiene permitido unirse al grupo"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Escribe un mensaje..."),
        "yes": MessageLookupByLibrary.simpleMessage("Sí"),
        "you": MessageLookupByLibrary.simpleMessage("Tú"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("Estás invitado a este chat"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Ya no estás participando en este chat"),
        "youCannotInviteYourself": MessageLookupByLibrary.simpleMessage(
            "No puedes invitarte a tí mismo"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Has sido vetado de este chat"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("Tu nombre de usuario")
      };
}

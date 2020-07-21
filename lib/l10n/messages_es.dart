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

  static m60(username) =>
      "¿Aceptar esta solicitud de verificación de ${username}?";

  static m2(username, targetName) => "${username} vetó a ${targetName}";

  static m3(homeserver) =>
      "De forma predeterminada estará conectado a ${homeserver}";

  static m4(username) => "${username} cambió el icono del chat";

  static m5(username, description) =>
      "${username} cambió la descripción del chat a: \'${description}\'";

  static m6(username, chatname) =>
      "${username} cambió el nombre del chat a: \'${chatname}\'";

  static m7(username) => "${username} cambió los permisos del chat";

  static m8(username, displayname) =>
      "${username} cambió su nombre visible a: ${displayname}";

  static m9(username) =>
      "${username} cambió las reglas de acceso de visitantes";

  static m10(username, rules) =>
      "${username} cambió las reglas de acceso de visitantes a: ${rules}";

  static m11(username) => "${username} cambió la visibilidad del historial";

  static m12(username, rules) =>
      "${username} cambió la visibilidad del historial a: ${rules}";

  static m13(username) => "${username} cambió las reglas de ingreso";

  static m14(username, joinRules) =>
      "${username} cambió las reglas de ingreso a ${joinRules}";

  static m15(username) => "${username} cambió su imagen de perfil";

  static m16(username) => "${username} cambió el alias de la sala";

  static m17(username) => "${username} cambió el enlace de invitación";

  static m18(error) => "No se pudo descifrar el mensaje: ${error}";

  static m19(count) => "${count} participantes";

  static m20(username) => "${username} creó el chat";

  static m21(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m22(year, month, day) => "${day}/${month}/${year}";

  static m23(month, day) => "${day}/${month}";

  static m24(displayname) => "Grupo con ${displayname}";

  static m25(username, targetName) =>
      "${username} ha retirado la invitación para ${targetName}";

  static m26(groupName) => "Invitar contacto a ${groupName}";

  static m27(username, link) =>
      "${username} te invitó a FluffyChat.\n1. Instale FluffyChat: http://fluffy.chat\n2. Regístrate o inicia sesión \n3. Abra el enlace de invitación: ${link}";

  static m28(username, targetName) => "${username} invitó a ${targetName}";

  static m29(username) => "${username} se unió al chat";

  static m30(username, targetName) => "${username} echó a ${targetName}";

  static m31(username, targetName) => "${username} echó y vetó a ${targetName}";

  static m32(localizedTimeShort) => "Última vez activo: ${localizedTimeShort}";

  static m33(count) => "Mostrar ${count} participantes más";

  static m34(homeserver) => "Iniciar sesión en ${homeserver}";

  static m35(number) => "${number} seleccionado(s)";

  static m36(fileName) => "Reproducir ${fileName}";

  static m37(username) => "${username} redactó un evento";

  static m38(username) => "${username} rechazó la invitación";

  static m39(username) => "Eliminado por ${username}";

  static m40(username) => "Visto por ${username}";

  static m41(username, count) => "Visto por ${username} y ${count} más";

  static m42(username, username2) => "Visto por ${username} y ${username2}";

  static m43(username) => "${username} envió un archivo";

  static m44(username) => "${username} envió una imagen";

  static m45(username) => "${username} envió un sticker";

  static m46(username) => "${username} envió un video";

  static m47(username) => "${username} envió un audio";

  static m48(username) => "${username} compartió la ubicación";

  static m49(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m50(username, targetName) =>
      "${username} admitió a ${targetName} nuevamente";

  static m51(type) => "Evento desconocido \'${type}\'";

  static m52(unreadCount) => "${unreadCount} chats no leídos";

  static m53(unreadEvents) => "${unreadEvents} mensajes no leídos";

  static m54(unreadEvents, unreadChats) =>
      "${unreadEvents} mensajes no leídos en ${unreadChats} chats";

  static m55(username, count) =>
      "${username} y ${count} más están escribiendo...";

  static m56(username, username2) =>
      "${username} y ${username2} están escribiendo...";

  static m57(username) => "${username} está escribiendo...";

  static m58(username) => "${username} abandonó el chat";

  static m59(username, type) => "${username} envió un evento ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Opcional) Nombre del grupo"),
        "About": MessageLookupByLibrary.simpleMessage("Acerca de"),
        "Accept": MessageLookupByLibrary.simpleMessage("Aceptar"),
        "Account": MessageLookupByLibrary.simpleMessage("Cuenta"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Información de la cuenta"),
        "Add a group description": MessageLookupByLibrary.simpleMessage(
            "Agregar una descripción al grupo"),
        "Admin": MessageLookupByLibrary.simpleMessage("Administrador"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("¿Ya tienes una cuenta?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Cualquiera puede unirse"),
        "Archive": MessageLookupByLibrary.simpleMessage("Archivo"),
        "Archived Room": MessageLookupByLibrary.simpleMessage("Sala archivada"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "¿Pueden unirse los usuarios visitantes?"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("¿Estás seguro?"),
        "Authentication": MessageLookupByLibrary.simpleMessage("Autenticación"),
        "Avatar has been changed": MessageLookupByLibrary.simpleMessage(
            "La imagen de perfil ha sido cambiada"),
        "Ban from chat": MessageLookupByLibrary.simpleMessage("Vetar del chat"),
        "Banned": MessageLookupByLibrary.simpleMessage("Vetado"),
        "Block Device":
            MessageLookupByLibrary.simpleMessage("Bloquear dispositivo"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Cambiar el servidor"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Cambiar el nombre del grupo"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Cambiar el servidor"),
        "Change wallpaper": MessageLookupByLibrary.simpleMessage(
            "Cambiar el fondo de pantalla"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Cambia tu estilo"),
        "Changelog":
            MessageLookupByLibrary.simpleMessage("Registro de cambios"),
        "Chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "Chat details":
            MessageLookupByLibrary.simpleMessage("Detalles del chat"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Elija una contraseña segura"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Elija un nombre de usuario"),
        "Close": MessageLookupByLibrary.simpleMessage("Cerrar"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "Connect": MessageLookupByLibrary.simpleMessage("Conectar"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Falló el intento de conexión"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "El contacto ha sido invitado al grupo"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Visor de contenido"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Copiado al portapapeles"),
        "Copy": MessageLookupByLibrary.simpleMessage("Copiar"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "No se pudo establecer la imagen de perfil"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "No se pudo establecer el nombre visible"),
        "Create": MessageLookupByLibrary.simpleMessage("Crear"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Crear cuenta ahora"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Crear grupo nuevo"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Actualmente activo"),
        "Dark": MessageLookupByLibrary.simpleMessage("Oscuro"),
        "Delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Eliminar mensaje"),
        "Deny": MessageLookupByLibrary.simpleMessage("Rechazar"),
        "Device": MessageLookupByLibrary.simpleMessage("Dispositivo"),
        "Devices": MessageLookupByLibrary.simpleMessage("Dispositivos"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Descartar imagen"),
        "Displayname has been changed": MessageLookupByLibrary.simpleMessage(
            "El nombre visible ha cambiado"),
        "Donate": MessageLookupByLibrary.simpleMessage("Donar"),
        "Download file":
            MessageLookupByLibrary.simpleMessage("Descargar archivo"),
        "Edit Jitsi instance": MessageLookupByLibrary.simpleMessage(
            "Cambiar la instancia de Jitsi"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Editar nombre visible"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Configuración de emotes"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Atajo de emote"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Chat vacío"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Cifrado"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Algoritmo de cifrado"),
        "Encryption is not enabled": MessageLookupByLibrary.simpleMessage(
            "El cifrado no está habilitado"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "¡El cifrado de extremo a extremo está actualmente en período de prueba! ¡Úselo bajo su propio riesgo!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Configuración del cifrado de extremo a extremo"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Ingrese un nombre de grupo"),
        "Enter a username": MessageLookupByLibrary.simpleMessage(
            "Ingrese un nombre de usuario"),
        "Enter your homeserver":
            MessageLookupByLibrary.simpleMessage("Ingrese su servidor"),
        "File name": MessageLookupByLibrary.simpleMessage("Nombre del archivo"),
        "File size": MessageLookupByLibrary.simpleMessage("Tamaño del archivo"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Reenviar"),
        "Friday": MessageLookupByLibrary.simpleMessage("Viernes"),
        "From joining":
            MessageLookupByLibrary.simpleMessage("Desde que se unió"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("Desde la invitación"),
        "Group": MessageLookupByLibrary.simpleMessage("Grupo"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Descripción del grupo"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage(
                "La descripción del grupo ha sido cambiada"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("El grupo es público"),
        "Guests are forbidden": MessageLookupByLibrary.simpleMessage(
            "Los visitantes están prohibidos"),
        "Guests can join": MessageLookupByLibrary.simpleMessage(
            "Los visitantes pueden unirse"),
        "Help": MessageLookupByLibrary.simpleMessage("Ayuda"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "El servidor no es compatible"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("¿Cómo estás hoy?"),
        "ID": MessageLookupByLibrary.simpleMessage("Identificación"),
        "Identity": MessageLookupByLibrary.simpleMessage("Identidad"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Invitar contacto"),
        "Invited": MessageLookupByLibrary.simpleMessage("Invitado"),
        "Invited users only":
            MessageLookupByLibrary.simpleMessage("Sólo usuarios invitados"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Parece que no tienes servicios de Google en tu teléfono. ¡Esa es una buena decisión para tu privacidad! Para recibir notificaciones instantáneas en FluffyChat, recomendamos usar microG: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Echar del chat"),
        "Last seen IP":
            MessageLookupByLibrary.simpleMessage("Última dirección IP vista"),
        "Leave": MessageLookupByLibrary.simpleMessage("Abandonar"),
        "Left the chat":
            MessageLookupByLibrary.simpleMessage("Abandonó el chat"),
        "License": MessageLookupByLibrary.simpleMessage("Licencia"),
        "Light": MessageLookupByLibrary.simpleMessage("Claro"),
        "Load more...": MessageLookupByLibrary.simpleMessage("Mostrar más..."),
        "Loading... Please wait": MessageLookupByLibrary.simpleMessage(
            "Cargando... Por favor espere"),
        "Login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "Logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Hacer un moderador/a"),
        "Make an admin":
            MessageLookupByLibrary.simpleMessage("Hacer un administrador/a"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Asegúrese de que el identificador es válido"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "El mensaje será eliminado para todos los participantes"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderador"),
        "Monday": MessageLookupByLibrary.simpleMessage("Lunes"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Silenciar chat"),
        "New message in FluffyChat":
            MessageLookupByLibrary.simpleMessage("Nuevo mensaje en FluffyChat"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Nuevo chat privado"),
        "No emotes found. 😕":
            MessageLookupByLibrary.simpleMessage("Ningún emote encontrado. 😕"),
        "No permission":
            MessageLookupByLibrary.simpleMessage("Sin autorización"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("Ninguna sala encontrada..."),
        "None": MessageLookupByLibrary.simpleMessage("Ninguno"),
        "Not supported in web": MessageLookupByLibrary.simpleMessage(
            "No es compatible con la versión web"),
        "Oops something went wrong...":
            MessageLookupByLibrary.simpleMessage("Ups, algo salió mal..."),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Abrir la aplicación para leer los mensajes"),
        "Open camera": MessageLookupByLibrary.simpleMessage("Abrir la cámara"),
        "Participating user devices": MessageLookupByLibrary.simpleMessage(
            "Dispositivos de usuario participantes"),
        "Password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Elegir imagen"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Tenga en cuenta que necesita Pantalaimon para utilizar el cifrado de extremo a extremo por ahora."),
        "Please choose a username": MessageLookupByLibrary.simpleMessage(
            "Por favor, elija un nombre de usuario"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Por favor, ingrese un identificador matrix"),
        "Please enter your password": MessageLookupByLibrary.simpleMessage(
            "Por favor ingrese su contraseña"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Por favor ingrese su nombre de usuario"),
        "Public Rooms": MessageLookupByLibrary.simpleMessage("Salas públicas"),
        "Recording": MessageLookupByLibrary.simpleMessage("Grabando"),
        "Reject": MessageLookupByLibrary.simpleMessage("Rechazar"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Volver a unirse"),
        "Remove": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Eliminar todos los otros dispositivos"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Eliminar dispositivo"),
        "Remove exile":
            MessageLookupByLibrary.simpleMessage("Eliminar la expulsión"),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Eliminar mensaje"),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(
            "Mostrar el contenido con mensajes enriquecidos"),
        "Reply": MessageLookupByLibrary.simpleMessage("Responder"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Solicitar permiso"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Solicitar poder leer mensajes antiguos"),
        "Revoke all permissions":
            MessageLookupByLibrary.simpleMessage("Revocar todos los permisos"),
        "Room has been upgraded": MessageLookupByLibrary.simpleMessage(
            "La sala ha subido de categoría"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Sábado"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Buscar un chat"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Visto hace mucho tiempo"),
        "Send": MessageLookupByLibrary.simpleMessage("Enviar"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Enviar un mensaje"),
        "Send file": MessageLookupByLibrary.simpleMessage("Enviar un archivo"),
        "Send image": MessageLookupByLibrary.simpleMessage("Enviar una imagen"),
        "Set a profile picture": MessageLookupByLibrary.simpleMessage(
            "Establecer una foto de perfil"),
        "Set group description": MessageLookupByLibrary.simpleMessage(
            "Establecer descripción del grupo"),
        "Set invitation link": MessageLookupByLibrary.simpleMessage(
            "Establecer enlace de invitación"),
        "Set status": MessageLookupByLibrary.simpleMessage("Establecer estado"),
        "Settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "Share": MessageLookupByLibrary.simpleMessage("Compartir"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "Skip": MessageLookupByLibrary.simpleMessage("Omitir"),
        "Source code": MessageLookupByLibrary.simpleMessage("Código fuente"),
        "Start your first chat :-)":
            MessageLookupByLibrary.simpleMessage("Comience su primer chat :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Enviar"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Domingo"),
        "System": MessageLookupByLibrary.simpleMessage("Sistema"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Toca para mostrar el menú"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage("El cifrado se ha corrompido"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("No coinciden"),
        "They Match": MessageLookupByLibrary.simpleMessage("Coinciden"),
        "This room has been archived.": MessageLookupByLibrary.simpleMessage(
            "Esta sala ha sido archivada."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Jueves"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Intentar enviar nuevamente"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Martes"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Desbloquear dispositivo"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Dispositivo desconocido"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Algoritmo de cifrado desconocido"),
        "Unmute chat":
            MessageLookupByLibrary.simpleMessage("Dejar de silenciar el chat"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "¿Usar colores compatibles con AMOLED?"),
        "Username": MessageLookupByLibrary.simpleMessage("Nombre de usuario"),
        "Verify": MessageLookupByLibrary.simpleMessage("Verificar"),
        "Verify User":
            MessageLookupByLibrary.simpleMessage("Verificar usuario"),
        "Video call": MessageLookupByLibrary.simpleMessage("Video llamada"),
        "Visibility of the chat history": MessageLookupByLibrary.simpleMessage(
            "Visibilidad del historial del chat"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Visible para todos los participantes"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Visible para todo el mundo"),
        "Voice message": MessageLookupByLibrary.simpleMessage("Mensaje de voz"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Fondo de pantalla"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Miércoles"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Bienvenido al mensajero instantáneo más tierno de la red Matrix."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Quién tiene permitido unirse al grupo"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Escribe un mensaje..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Sí"),
        "You": MessageLookupByLibrary.simpleMessage("Tú"),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage("Estás invitado a este chat"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Ya no estás participando en este chat"),
        "You cannot invite yourself": MessageLookupByLibrary.simpleMessage(
            "No puedes invitarte a tí mismo"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Has sido vetado de este chat"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Ya no podrá deshabilitar el cifrado. ¿Estás seguro?"),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("Tu nombre de usuario"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Ingrese su contraseña de almacenamiento segura (SSSS) o la clave de recuperación para almacenar en caché las claves."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Para poder confirmar a la otra persona, ingrese su contraseña de almacenamiento segura o la clave de recuperación."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Por favor, ingrese su contraseña de almacenamiento seguro (SSSS) o la clave de recuperación para verificar su sesión."),
        "askVerificationRequest": m60,
        "bannedUser": m2,
        "byDefaultYouWillBeConnectedTo": m3,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "¡Las claves se han almacenado exitosamente!"),
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
            "Compare y asegúrese de que los siguientes emoji coincidan con los del otro dispositivo:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Compare y asegúrese de que los siguientes números coincidan con los del otro dispositivo:"),
        "couldNotDecryptMessage": m18,
        "countParticipants": m19,
        "createdTheChat": m20,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "La confirmación cruzada está deshabilitada"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "La confirmación cruzada está habilitada"),
        "dateAndTimeOfDay": m21,
        "dateWithYear": m22,
        "dateWithoutYear": m23,
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("¡El emote ya existe!"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "¡El atajo del emote es inválido!"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "¡Debes elegir un atajo de emote y una imagen!"),
        "groupWith": m24,
        "hasWithdrawnTheInvitationFor": m25,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Frase de contraseña o clave de recuperación incorrecta"),
        "inviteContactToGroup": m26,
        "inviteText": m27,
        "invitedUser": m28,
        "is typing...":
            MessageLookupByLibrary.simpleMessage("está escribiendo..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "¿Es correcta la siguiente clave de dispositivo?"),
        "joinedTheChat": m29,
        "keysCached":
            MessageLookupByLibrary.simpleMessage("Las claves están en caché"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Faltan las claves"),
        "kicked": m30,
        "kickedAndBanned": m31,
        "lastActiveAgo": m32,
        "loadCountMoreParticipants": m33,
        "logInTo": m34,
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(
            "¡Nueva solicitud de verificación!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat actualmente no admite habilitar confirmación cruzada. Por favor habilítela desde Element."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat actualmente no admite habilitar la Copia de seguridad de clave en línea. Por favor habilítela desde Element."),
        "numberSelected": m35,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "La copia de seguridad de la clave en línea está deshabilitada"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "La copia de seguridad de la clave en línea está habilitada"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "contraseña o clave de recuperación"),
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
            MessageLookupByLibrary.simpleMessage("La sesión está verificada"),
        "sharedTheLocation": m48,
        "timeOfDay": m49,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m50,
        "unknownEvent": m51,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Sesión desconocida, por favor verifíquela"),
        "unreadChats": m52,
        "unreadMessages": m53,
        "unreadMessagesInChats": m54,
        "userAndOthersAreTyping": m55,
        "userAndUserAreTyping": m56,
        "userIsTyping": m57,
        "userLeftTheChat": m58,
        "userSentUnknownEvent": m59,
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "¡Sesión verificada exitosamente!"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verificar manualmente"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Comenzar verificación"),
        "verifySuccess": MessageLookupByLibrary.simpleMessage(
            "¡Has verificado exitosamente!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Verificando la otra cuenta"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Esperando a que el socio acepte la solicitud..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Esperando a que el socio acepte los emojis..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Esperando a que el socio acepte los números...")
      };
}

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

  static m60(username) =>
      "¿Aceptar a solicitude de verificación de ${username}?";

  static m2(username, targetName) => "${username} vetou a ${targetName}";

  static m3(homeserver) => "Por omisión vas conectar con ${homeserver}";

  static m4(username) => "${username} cambiou o avatar do chat";

  static m5(username, description) =>
      "${username} mudou a descrición da conversa a: \'${description}\'";

  static m6(username, chatname) =>
      "${username} mudou o nome da conversa a: \'${chatname}\'";

  static m7(username) => "${username} mudou os permisos da conversa";

  static m8(username, displayname) =>
      "${username} cambiou o nome público a: ${displayname}";

  static m9(username) =>
      "${username} mudou as regras de acceso para convidadas";

  static m10(username, rules) =>
      "${username} mudou as regras de acceso para convidadas a: ${rules}";

  static m11(username) => "${username} mudou a visibilidade do historial";

  static m12(username, rules) =>
      "${username} mudou a visibilidade do historial a: ${rules}";

  static m13(username) => "${username} mudou as regras de acceso";

  static m14(username, joinRules) =>
      "${username} mudou as regras de acceso a: ${joinRules}";

  static m15(username) => "${username} mudou o avatar do perfil";

  static m16(username) => "${username} mudou os alias da sala";

  static m17(username) => "${username} mudou a ligazón de convite";

  static m18(error) => "Non se descifrou a mensaxe: ${error}";

  static m19(count) => "${count} participantes";

  static m20(username) => "${username} creou a conversa";

  static m21(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m22(year, month, day) => "${day}-${month}-${year}";

  static m23(month, day) => "${day}-${month}";

  static m24(displayname) => "Grupo con ${displayname}";

  static m25(username, targetName) =>
      "${username} retirou o convite para ${targetName}";

  static m26(groupName) => "Convidar contacto a ${groupName}";

  static m27(username, link) =>
      "${username} convidoute a FluffyChat.\n1. instala FluffyChat:  http://fluffy.chat \n2. Rexístrate ou conéctate\n3. Abre a ligazón do convite: ${link}";

  static m28(username, targetName) => "${username} convidou a ${targetName}";

  static m29(username) => "${username} uníuse ó chat";

  static m30(username, targetName) => "${username} expulsou a ${targetName}";

  static m31(username, targetName) =>
      "${username} expulsou e vetou a ${targetName}";

  static m32(localizedTimeShort) => "Última actividade: ${localizedTimeShort}";

  static m33(count) => "Cargar ${count} participantes máis";

  static m34(homeserver) => "Conectar con ${homeserver}";

  static m35(number) => "${number} seleccionados";

  static m36(fileName) => "Reproducir ${fileName}";

  static m37(username) => "${username} publicou un evento";

  static m38(username) => "${username} rexeitou o convite";

  static m39(username) => "Eliminado por ${username}";

  static m40(username) => "Visto por ${username}";

  static m41(username, count) => "Visto por ${username} e ${count} outras";

  static m42(username, username2) => "Visto por ${username} e ${username2}";

  static m43(username) => "${username} enviou un ficheiro";

  static m44(username) => "${username} enviou unha imaxe";

  static m45(username) => "${username} enviou un adhesivo";

  static m46(username) => "${username} enviou un vídeo";

  static m47(username) => "${username} enviou un audio";

  static m48(username) => "${username} compartiu a localización";

  static m49(hours12, hours24, minutes, suffix) =>
      "${hours12}:${minutes} ${suffix}";

  static m50(username, targetName) =>
      "${username} retirou o veto a ${targetName}";

  static m51(type) => "Evento descoñecido \'${type}\'";

  static m52(unreadCount) => "${unreadCount} chats non lidos";

  static m53(unreadEvents) => "${unreadEvents} mensaxes non lidas";

  static m54(unreadEvents, unreadChats) =>
      "${unreadEvents} mensaxes non lidas en ${unreadChats} conversas";

  static m55(username, count) =>
      "${username} e ${count} máis están escribindo...";

  static m56(username, username2) =>
      "${username} e ${username2} están escribindo...";

  static m57(username) => "${username} está escribindo...";

  static m58(username) => "${username} deixou a conversa";

  static m59(username, type) => "${username} enviou un evento {type]";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Optativo) Nome do grupo"),
        "About": MessageLookupByLibrary.simpleMessage("Acerca de"),
        "Accept": MessageLookupByLibrary.simpleMessage("Aceptar"),
        "Account": MessageLookupByLibrary.simpleMessage("Conta"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Información da conta"),
        "Add a group description": MessageLookupByLibrary.simpleMessage(
            "Engade a descrición do grupo"),
        "Admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("¿xa tes unha conta?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Calquera pode unirse"),
        "Archive": MessageLookupByLibrary.simpleMessage("Arquivo"),
        "Archived Room": MessageLookupByLibrary.simpleMessage("Sala arquivada"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Teñen permitido as convidadas o acceso"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("¿estás certo?"),
        "Authentication": MessageLookupByLibrary.simpleMessage("Autenticación"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("O avatar cambiou"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Expulsar da conversa"),
        "Banned": MessageLookupByLibrary.simpleMessage("Vetada"),
        "Block Device":
            MessageLookupByLibrary.simpleMessage("Bloquear dispositivo"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Mudar de servidor de inicio"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Mudar o nome do grupo"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Mudar de servidor"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Mudar fondo do chat"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Cambiar o estilo"),
        "Changelog":
            MessageLookupByLibrary.simpleMessage("Rexistro de cambios"),
        "Chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "Chat details":
            MessageLookupByLibrary.simpleMessage("Detalles do chat"),
        "Choose a strong password": MessageLookupByLibrary.simpleMessage(
            "Escolle un contrasinal forte"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Escolle un nome de usuaria"),
        "Close": MessageLookupByLibrary.simpleMessage("Pechar"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "Connect": MessageLookupByLibrary.simpleMessage("Conectar"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Fallou o intento de conexión"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "O contacto foi convidado ó grupo"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Visor de contido"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Copiado ó portapapeis"),
        "Copy": MessageLookupByLibrary.simpleMessage("Copiar"),
        "Could not set avatar":
            MessageLookupByLibrary.simpleMessage("Non se estableceu o avatar"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Non se estableceu o nome público"),
        "Create": MessageLookupByLibrary.simpleMessage("Crear"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Crear unha conta"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Crear novo grupo"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Actualmente activo"),
        "Dark": MessageLookupByLibrary.simpleMessage("Escuro"),
        "Delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Eliminar mensaxe"),
        "Deny": MessageLookupByLibrary.simpleMessage("Denegar"),
        "Device": MessageLookupByLibrary.simpleMessage("Dispositivo"),
        "Devices": MessageLookupByLibrary.simpleMessage("Dispositivos"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Desbotar imaxe"),
        "Displayname has been changed":
            MessageLookupByLibrary.simpleMessage("O nome público mudou"),
        "Donate": MessageLookupByLibrary.simpleMessage("Doar"),
        "Download file":
            MessageLookupByLibrary.simpleMessage("Descargar ficheiro"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Editar instancia Jitsi"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Editar nome público"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Axustes de Emote"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Atallo de Emote"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Chat baleiro"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Cifrado"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Algoritmo do cifrado"),
        "Encryption is not enabled":
            MessageLookupByLibrary.simpleMessage("Cifrado desactivado"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "O cifrado extremo-a-extremo está en Beta! Úsao baixo a túa responsabilidade!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Axustes do cifrado extremo-a-extremo"),
        "Enter a group name": MessageLookupByLibrary.simpleMessage(
            "Escribe un nome para o grupo"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Escribe un nome de usuaria"),
        "Enter your homeserver": MessageLookupByLibrary.simpleMessage(
            "Escribe o teu servidor de inicio"),
        "File name": MessageLookupByLibrary.simpleMessage("Nome do ficheiro"),
        "File size": MessageLookupByLibrary.simpleMessage("Tamaño do ficheiro"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Reenviar"),
        "Friday": MessageLookupByLibrary.simpleMessage("Venres"),
        "From joining":
            MessageLookupByLibrary.simpleMessage("Desde que se una"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("Desde o convite"),
        "Group": MessageLookupByLibrary.simpleMessage("Grupo"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Descrición do grupo"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage("Mudou a descrición do grupo"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("O grupo é público"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Non se permiten convidadas"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Permítense convidadas"),
        "Help": MessageLookupByLibrary.simpleMessage("Axuda"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "Servidor de inicio non compatible"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("¿Que tal estás hoxe?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Identidade"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Convidar contacto"),
        "Invited": MessageLookupByLibrary.simpleMessage("Convidado"),
        "Invited users only":
            MessageLookupByLibrary.simpleMessage("Só usuarias convidadas"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Semella que non tes os servizos de google no teu dispositivo. Ben feito! a túa privacidade agradécecho! Para recibir notificacións push en FluffyChat recomendamos usar microG: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Expulsar da conversa"),
        "Last seen IP": MessageLookupByLibrary.simpleMessage("Última IP vista"),
        "Leave": MessageLookupByLibrary.simpleMessage("Saír"),
        "Left the chat":
            MessageLookupByLibrary.simpleMessage("Deixar a conversa"),
        "License": MessageLookupByLibrary.simpleMessage("Licenza"),
        "Light": MessageLookupByLibrary.simpleMessage("Claro"),
        "Load more...": MessageLookupByLibrary.simpleMessage("Cargar máis..."),
        "Loading... Please wait":
            MessageLookupByLibrary.simpleMessage("Cargando... Agarda"),
        "Login": MessageLookupByLibrary.simpleMessage("Conexión"),
        "Logout": MessageLookupByLibrary.simpleMessage("Desconectar"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Converter en moderadora"),
        "Make an admin":
            MessageLookupByLibrary.simpleMessage("Converter en administradora"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Asegúrate de que o identificador é válido"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "A mensaxe eliminarase para todas as participantes"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderadora"),
        "Monday": MessageLookupByLibrary.simpleMessage("Luns"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Acalar conversa"),
        "New message in FluffyChat":
            MessageLookupByLibrary.simpleMessage("Nova mensaxe en FluffyChat"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Nova conversa privada"),
        "No emotes found. 😕":
            MessageLookupByLibrary.simpleMessage("Non hai emotes. 😕"),
        "No permission": MessageLookupByLibrary.simpleMessage("Sen permiso"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("Non se atoparon salas..."),
        "None": MessageLookupByLibrary.simpleMessage("Ningún"),
        "Not supported in web":
            MessageLookupByLibrary.simpleMessage("Non soportado na web"),
        "Oops something went wrong...":
            MessageLookupByLibrary.simpleMessage("Ooooi, algo fallou..."),
        "Open app to read messages":
            MessageLookupByLibrary.simpleMessage("Abrir a app e ler mensaxes"),
        "Open camera": MessageLookupByLibrary.simpleMessage("Abrir cámara"),
        "Participating user devices": MessageLookupByLibrary.simpleMessage(
            "Dispositivos das usuarias participantes"),
        "Password": MessageLookupByLibrary.simpleMessage("Contrasinal"),
        "Pick image":
            MessageLookupByLibrary.simpleMessage("Escolle unha imaxe"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Ten en conta que polo de agora precisas Pantalaimon para o cifrado extremo-a-extremo."),
        "Please choose a username":
            MessageLookupByLibrary.simpleMessage("Escolle un nome de usuaria"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Escribe un identificador matrix"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("Escribe o teu contrasinal"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Escribe o teu nome de usuaria"),
        "Public Rooms": MessageLookupByLibrary.simpleMessage("Salas públicas"),
        "Recording": MessageLookupByLibrary.simpleMessage("Gravando"),
        "Reject": MessageLookupByLibrary.simpleMessage("Rexeitar"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Volta a unirte"),
        "Remove": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Quitar todos os outros dispositivos"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Quitar dispositivo"),
        "Remove exile": MessageLookupByLibrary.simpleMessage("Quitar o veto"),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Eliminar mensaxe"),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(
            "Mostrar contido enriquecido da mensaxe"),
        "Reply": MessageLookupByLibrary.simpleMessage("Responder"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Solicitar permiso"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Solicitar ler mensaxes antigas"),
        "Revoke all permissions":
            MessageLookupByLibrary.simpleMessage("Revogar tódolos permisos"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("A sala foi actualizada"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Sábado"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Buscar un chat"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Hai moito que non aparece"),
        "Send": MessageLookupByLibrary.simpleMessage("Enviar"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Enviar unha mensaxe"),
        "Send file": MessageLookupByLibrary.simpleMessage("Enviar ficheiro"),
        "Send image": MessageLookupByLibrary.simpleMessage("Enviar imaxe"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Establecer foto do perfil"),
        "Set group description": MessageLookupByLibrary.simpleMessage(
            "Establecer descrición do grupo"),
        "Set invitation link": MessageLookupByLibrary.simpleMessage(
            "Establecer ligazón do convite"),
        "Set status": MessageLookupByLibrary.simpleMessage("Establecer estado"),
        "Settings": MessageLookupByLibrary.simpleMessage("Axustes"),
        "Share": MessageLookupByLibrary.simpleMessage("Compartir"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Rexistro"),
        "Skip": MessageLookupByLibrary.simpleMessage("Saltar"),
        "Source code": MessageLookupByLibrary.simpleMessage("Código fonte"),
        "Start your first chat :-)": MessageLookupByLibrary.simpleMessage(
            "Abre a primeira conversa :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Enviar"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Domingo"),
        "System": MessageLookupByLibrary.simpleMessage("Sistema"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Toca para mostrar menú"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage("O cifrado está corrompido"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Non concordan"),
        "They Match": MessageLookupByLibrary.simpleMessage("Concordan"),
        "This room has been archived.":
            MessageLookupByLibrary.simpleMessage("A sala foi arquivada."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Xoves"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Inténtao outra vez"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Martes"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Desbloquear dispositivo"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Dispositivo descoñecido"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Algoritmo de cifrado descoñecido"),
        "Unmute chat": MessageLookupByLibrary.simpleMessage("Reactivar chat"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "¿Usar cores compatibles con Amoled?"),
        "Username": MessageLookupByLibrary.simpleMessage("Nome de usuaria"),
        "Verify": MessageLookupByLibrary.simpleMessage("Verificar"),
        "Verify User":
            MessageLookupByLibrary.simpleMessage("Verificar usuaria"),
        "Video call": MessageLookupByLibrary.simpleMessage("Chamada de vídeo"),
        "Visibility of the chat history": MessageLookupByLibrary.simpleMessage(
            "Visibilidade do historial da conversa"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Visible para todas as participantes"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Visible para todas"),
        "Voice message": MessageLookupByLibrary.simpleMessage("Mensaxe de voz"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Fondo da conversa"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Mércores"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Benvida a mensaxería instantánea más cuquiña da rede matrix."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Quen se pode unir a este grupo"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Escribe unha mensaxe..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Si"),
        "You": MessageLookupByLibrary.simpleMessage("Ti"),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage("Estás convidada a este chat"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Xa non participas desta conversa"),
        "You cannot invite yourself":
            MessageLookupByLibrary.simpleMessage("Non podes autoconvidarte"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Foches vetada nesta conversa"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Non poderás desactivar o cifrado posteriormente, ¿estás certo?"),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("O teu nome de usuaria"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Escribe a frase de paso de seguridade ou chave de recuperación para almacenar as chaves."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Para poder conectar a outra persoa, escribe a túa frase de paso ou chave de recuperación."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Escribe frase de paso de almacenaxe segura ou chave de recuperación para verificar a túa sesión."),
        "askVerificationRequest": m60,
        "bannedUser": m2,
        "byDefaultYouWillBeConnectedTo": m3,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Almacenaches as chaves correctamente!"),
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
            "Comparar e asegurarse de que estas emoticonas concordan no outro dispositivo:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Compara e asegúrate de que os seguintes números concordan cos do outro dispositivo:"),
        "couldNotDecryptMessage": m18,
        "countParticipants": m19,
        "createdTheChat": m20,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "A Sinatura-Cruzada está desactivada"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Sinatura-Cruzada activada"),
        "dateAndTimeOfDay": m21,
        "dateWithYear": m22,
        "dateWithoutYear": m23,
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Xa existe ese emote!"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Atallo do emote non é válido!"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Escribe un atallo e asocialle unha imaxe!"),
        "groupWith": m24,
        "hasWithdrawnTheInvitationFor": m25,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Frase de paso ou chave de recuperación incorrecta"),
        "inviteContactToGroup": m26,
        "inviteText": m27,
        "invitedUser": m28,
        "is typing...":
            MessageLookupByLibrary.simpleMessage("está escribindo..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "¿É correcta esta chave do dispositivo?"),
        "joinedTheChat": m29,
        "keysCached":
            MessageLookupByLibrary.simpleMessage("Chaves almacenadas"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Faltan as chaves"),
        "kicked": m30,
        "kickedAndBanned": m31,
        "lastActiveAgo": m32,
        "loadCountMoreParticipants": m33,
        "logInTo": m34,
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(
            "Nova solicitude de verificación!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Polo momento FluffyChat non soporta a activación da Sinatura-Cruzada. Actívaa desde Element."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Actualmente Fluffychat non soporta a activación da Copia En Liña das Chaves. Actívaa desde Element."),
        "numberSelected": m35,
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Copia de apoio En liña das Chaves desactivada"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Copia de Apoio das Chaves activada"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "frase de paso ou chave de recuperación"),
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
            MessageLookupByLibrary.simpleMessage("Sesión verificada"),
        "sharedTheLocation": m48,
        "timeOfDay": m49,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m50,
        "unknownEvent": m51,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Sesión descoñecida, por favor verifícaa"),
        "unreadChats": m52,
        "unreadMessages": m53,
        "unreadMessagesInChats": m54,
        "userAndOthersAreTyping": m55,
        "userAndUserAreTyping": m56,
        "userIsTyping": m57,
        "userLeftTheChat": m58,
        "userSentUnknownEvent": m59,
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Sesión verificada correctamente!"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verificar manualmente"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Comezar verificación"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Verificaches correctamente!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Verificando a outra conta"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Agardando a que a outra parte acepte a solicitude..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Agardando a que a outra parte acepte as emoticonas..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Agardando a que a outra parte acepte os números...")
      };
}

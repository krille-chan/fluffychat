// This file is auto-generated using scripts/generate_command_hints_glue.sh.

import 'package:fluffychat/l10n/l10n.dart';

String commandExample(String command) {
  switch (command) {
    case 'markasdm':
    case 'kick':
    case 'dm':
    case 'ban':
    case 'unban':
    case 'ignore':
    case 'unignore':
    case 'invite':
      return '/$command <matrix-id>';
    case 'html':
    case 'sendraw':
    case 'plain':
      return '/$command <message>';
    case 'op':
      return '/$command <matrix-id> <power-level>';
    default:
      return '/$command';
  }
}

String commandHint(L10n l10n, String command) {
  switch (command) {
    case "ban":
      return l10n.commandHint_ban;
    case "clearcache":
      return l10n.commandHint_clearcache;
    case "create":
      return l10n.commandHint_create;
    case "discardsession":
      return l10n.commandHint_discardsession;
    case "dm":
      return l10n.commandHint_dm;
    case "html":
      return l10n.commandHint_html;
    case "invite":
      return l10n.commandHint_invite;
    case "join":
      return l10n.commandHint_join;
    case "kick":
      return l10n.commandHint_kick;
    case "leave":
      return l10n.commandHint_leave;
    case "me":
      return l10n.commandHint_me;
    case "myroomavatar":
      return l10n.commandHint_myroomavatar;
    case "myroomnick":
      return l10n.commandHint_myroomnick;
    case "op":
      return l10n.commandHint_op;
    case "plain":
      return l10n.commandHint_plain;
    case "react":
      return l10n.commandHint_react;
    case "send":
      return l10n.commandHint_send;
    case "unban":
      return l10n.commandHint_unban;
    case 'markasdm':
      return l10n.commandHint_markasdm;
    case 'markasgroup':
      return l10n.commandHint_markasgroup;
    case 'googly':
      return l10n.commandHint_googly;
    case 'hug':
      return l10n.commandHint_hug;
    case 'cuddle':
      return l10n.commandHint_cuddle;
    case 'sendraw':
      return l10n.commandHint_sendraw;
    case 'ignore':
      return l10n.commandHint_ignore;
    case 'unignore':
      return l10n.commandHint_unignore;
    case 'roomupgrade':
      return l10n.commandHint_roomupgrade;
    case 'logout':
      return l10n.commandHint_logout;
    case 'logoutall':
      return l10n.commandHint_logoutall;
    default:
      return "";
  }
}

#!/usr/bin/env bash
# Generates some glue code for translation of /command hints.

# How to use this:
# - Add any new hints to assets/l10n/intl_en.arb
#   They must be of the form commandHint_<command> with <command> in lowercase.
# - Run this script to regenerate the glue code
# - Run flutter test to see if you did everything right

# Looking to add descriptions for a new command, but don't know what it does?
# It is likely defined here (in registerDefaultCommands()):
# https://gitlab.com/famedly/company/frontend/famedlysdk/-/blob/main/lib/src/utils/commands_extension.dart

echo "\
// This file is auto-generated using scripts/generate_command_hints_glue.sh.

import 'package:flutter_gen/gen_l10n/l10n.dart';

String commandHint(L10n l10n, String command) {
  switch (command) {
$(sed -n \
  's/[[:blank:]]*\"\(commandHint_\([[:lower:]]*\)\)\".*/    case "\2":\
      return l10n.\1;/p' \
  lib/l10n/intl_en.arb
)
    default:
      return \"\";
  }
}\
" > lib/pages/chat/command_hints.dart

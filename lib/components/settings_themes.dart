import 'package:flutter/material.dart';

import '../components/theme_switcher.dart';
import '../components/matrix.dart';
import '../l10n/l10n.dart';

class ThemesSettings extends StatefulWidget {
  @override
  ThemesSettingsState createState() => ThemesSettingsState();
}

class ThemesSettingsState extends State<ThemesSettings> {
  Themes _selectedTheme;
  bool _amoledEnabled;

  @override
  Widget build(BuildContext context) {
    final MatrixState matrix = Matrix.of(context);
    final ThemeSwitcherWidgetState themeEngine =
        ThemeSwitcherWidget.of(context);
    _selectedTheme = themeEngine.selectedTheme;
    _amoledEnabled = themeEngine.amoledEnabled;

    return Column(
      children: <Widget>[
        RadioListTile<Themes>(
          title: Text(
            L10n.of(context).systemTheme,
          ),
          value: Themes.system,
          groupValue: _selectedTheme,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (Themes value) {
            setState(() {
              _selectedTheme = value;
              themeEngine.switchTheme(matrix, value, _amoledEnabled);
            });
          },
        ),
        RadioListTile<Themes>(
          title: Text(
            L10n.of(context).lightTheme,
          ),
          value: Themes.light,
          groupValue: _selectedTheme,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (Themes value) {
            setState(() {
              _selectedTheme = value;
              themeEngine.switchTheme(matrix, value, _amoledEnabled);
            });
          },
        ),
        RadioListTile<Themes>(
          title: Text(
            L10n.of(context).darkTheme,
          ),
          value: Themes.dark,
          groupValue: _selectedTheme,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (Themes value) {
            setState(() {
              _selectedTheme = value;
              themeEngine.switchTheme(matrix, value, _amoledEnabled);
            });
          },
        ),
        ListTile(
          title: Text(
            L10n.of(context).useAmoledTheme,
          ),
          trailing: Switch(
            value: _amoledEnabled,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool value) {
              setState(() {
                _amoledEnabled = value;
                themeEngine.switchTheme(matrix, _selectedTheme, value);
              });
            },
          ),
        ),
      ],
    );
  }
}

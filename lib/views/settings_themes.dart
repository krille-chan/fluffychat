import 'package:flutter/material.dart';

import '../components/ThemeSwitcher.dart';
import '../components/adaptive_page_layout.dart';
import '../components/matrix.dart';
import '../i18n/i18n.dart';
import 'chat_list.dart';

class ThemesSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: ThemesSettings(),
    );
  }
}

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

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).changeTheme),
      ),
      body: Column(
        children: <Widget>[
          RadioListTile<Themes>(
            title: Text(
              I18n.of(context).systemTheme,
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
              I18n.of(context).lightTheme,
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
              I18n.of(context).darkTheme,
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
          Divider(thickness: 8),
          ListTile(
            title: Text(
              I18n.of(context).useAmoledTheme,
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
      ),
    );
  }
}

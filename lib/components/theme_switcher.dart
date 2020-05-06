import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'matrix.dart';

enum Themes {
  light,
  dark,
  system,
}

final ThemeData lightTheme = ThemeData(
  primaryColorDark: Colors.white,
  primaryColorLight: Color(0xff121212),
  brightness: Brightness.light,
  primaryColor: Color(0xFF5625BA),
  backgroundColor: Colors.white,
  secondaryHeaderColor: Color(0xFFECECF2),
  scaffoldBackgroundColor: Colors.white,
  snackBarTheme: SnackBarThemeData(
    behavior: kIsWeb ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    color: Colors.white,
    textTheme: TextTheme(
      title: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColorDark: Color(0xff1B1B1B),
  primaryColorLight: Colors.white,
  primaryColor: Color(0xFF8966CF),
  errorColor: Color(0xFFCF6679),
  backgroundColor: Color(0xff121212),
  scaffoldBackgroundColor: Color(0xff1B1B1B),
  accentColor: Color(0xFFF5B4D2),
  secondaryHeaderColor: Color(0xff202020),
  snackBarTheme: SnackBarThemeData(
    behavior: kIsWeb ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: Color(0xff1D1D1D),
    textTheme: TextTheme(
      title: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
);

final ThemeData amoledTheme = ThemeData.dark().copyWith(
  primaryColorDark: Color(0xff121212),
  primaryColorLight: Colors.white,
  primaryColor: Color(0xFF8966CF),
  errorColor: Color(0xFFCF6679),
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  accentColor: Color(0xFFF5B4D2),
  secondaryHeaderColor: Color(0xff1D1D1D),
  snackBarTheme: SnackBarThemeData(
    behavior: kIsWeb ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: Color(0xff1D1D1D),
    textTheme: TextTheme(
      title: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
);

Color chatListItemColor(BuildContext context, bool activeChat) =>
    Theme.of(context).brightness == Brightness.light
        ? activeChat ? Color(0xFFE8E8E8) : Colors.white
        : activeChat
            ? ThemeSwitcherWidget.of(context).amoledEnabled
                ? Color(0xff121212)
                : Colors.black
            : ThemeSwitcherWidget.of(context).amoledEnabled
                ? Colors.black
                : Color(0xff121212);

Color blackWhiteColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black;

class ThemeSwitcher extends InheritedWidget {
  final ThemeSwitcherWidgetState data;

  const ThemeSwitcher({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(ThemeSwitcher old) {
    return this != old;
  }
}

class ThemeSwitcherWidget extends StatefulWidget {
  final Widget child;

  ThemeSwitcherWidget({Key key, this.child})
      : assert(child != null),
        super(key: key);

  @override
  ThemeSwitcherWidgetState createState() => ThemeSwitcherWidgetState();

  /// Returns the (nearest) Client instance of your application.
  static ThemeSwitcherWidgetState of(BuildContext context) {
    ThemeSwitcherWidgetState newState =
        (context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>()).data;
    newState.context = context;
    return newState;
  }
}

class ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  ThemeData themeData;
  Themes selectedTheme;
  bool amoledEnabled;
  BuildContext context;

  Future loadSelection(MatrixState matrix) async {
    String item = await matrix.client.storeAPI.getItem("theme") ?? "light";
    selectedTheme =
        Themes.values.firstWhere((e) => e.toString() == 'Themes.' + item);

    amoledEnabled =
        (await matrix.client.storeAPI.getItem("amoled_enabled") ?? "false")
                .toLowerCase() ==
            'true';

    switchTheme(matrix, selectedTheme, amoledEnabled);
    return;
  }

  void switchTheme(
      MatrixState matrix, Themes newTheme, bool amoled_enabled) async {
    ThemeData theme;
    switch (newTheme) {
      case Themes.light:
        theme = lightTheme;
        break;
      case Themes.dark:
        if (amoled_enabled) {
          theme = amoledTheme;
        } else {
          theme = darkTheme;
        }
        break;
      case Themes.system:
        // This needs to be a low level call as we don't have a MaterialApp yet
        Brightness brightness =
            MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .platformBrightness;
        if (brightness == Brightness.dark) {
          if (amoled_enabled) {
            theme = amoledTheme;
          } else {
            theme = darkTheme;
          }
        } else {
          theme = lightTheme;
        }
        break;
    }

    await saveThemeValue(matrix, newTheme);
    await saveAmoledEnabledValue(matrix, amoled_enabled);
    setState(() {
      amoledEnabled = amoled_enabled;
      selectedTheme = newTheme;
      themeData = theme;
    });
  }

  Future saveThemeValue(MatrixState matrix, Themes value) async {
    await matrix.client.storeAPI
        .setItem("theme", value.toString().split('.').last);
  }

  Future saveAmoledEnabledValue(MatrixState matrix, bool value) async {
    await matrix.client.storeAPI.setItem("amoled_enabled", value.toString());
  }

  void setup() async {
    final MatrixState matrix = Matrix.of(context);
    await loadSelection(matrix);

    if (selectedTheme == null) {
      switchTheme(matrix, Themes.light, false);
    } else {
      switch (selectedTheme) {
        case Themes.light:
          switchTheme(matrix, Themes.light, false);
          break;
        case Themes.dark:
          if (amoledEnabled) {
            switchTheme(matrix, Themes.dark, true);
          } else {
            switchTheme(matrix, Themes.dark, false);
          }
          break;
        case Themes.system:
          switchTheme(matrix, Themes.system, false);
          break;
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (amoledEnabled == null || selectedTheme == null) {
        setup();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (themeData == null) {
      // This needs to be a low level call as we don't have a MaterialApp yet
      Brightness brightness =
          MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .platformBrightness;
      if (brightness == Brightness.dark) {
        themeData = darkTheme;
      } else {
        themeData = lightTheme;
      }
      return ThemeSwitcher(
        data: this,
        child: widget.child,
      );
    } else {
      return ThemeSwitcher(
        data: this,
        child: widget.child,
      );
    }
  }
}

# Code Style

FluffyChat tries to be as minimal as possible even in the code style. We try to keep the code clean, simple and easy to read. The source code of the app is under `/lib` with the main entry point `/lib/main.dart`.

### Directory Structure:


- /lib
  - /config
    - app_config.dart
    - ...Constants, styles and other configurations
  - /l10n
    - intl_en.arb
    - ...Localization files
  - /models
    - app_model.dart
    - ...Data models used in the app
  - /utils
    - handy_function.dart
    - ...Helper functions and extensions
  - /views
    - /ui
      - home_ui.dart
      - details_ui.dart
    - /widgets
      - /dialogs
        - /ui
      - /list_items
        - /ui
      - /ui
    - home_view.dart
    - details_view.dart
    - ...The views and widgets of the app separated in Controllers and Views
  - main.dart


Most of the business model is in the Famedly Matrix Dart SDK. We try to not keep a model inside of the source code but extend it under `/utils`.

### Separation of Controllers and Views

We split views and controller logic with stateful widgets as controller where the build method just builds a stateless widget which receives the state as the only parameter. A common controller would look like this:

```dart
// /lib/controller/enter_name_controller.dart
import 'package:flutter/material.dart';

class EnterName extends StatefulWidget {
  @override
  EnterNameController createState() => EnterNameController();
}

class EnterNameController extends State<EnterName> {
  final TextEditingController textEditingController = TextEditingController();
  String name = 'Unknown';

  /// Changes the name with the content in the textfield. If the textfield is
  /// empty, this breaks up and displays a SnackBar.
  void setNameAction() {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have not entered your name'),
        ),
      );
      return;
    }
    setState(() => name = textEditingController.text);
  }

  @override
  Widget build(BuildContext context) => EnterNameView(this);
}
```

So we have a controller for a `EnterName` view which as a `TextEditingController`, a state `name` and an action `void setNameAction()`. Actions must always be methods of a type, that we dont need to pass parameters in the corresponding view class and must have dartdoc comments.

The view class could look like this:

```dart
// /lib/views/enter_name_view.dart
import 'package:flutter/material.dart';

class EnterNameView extends StatelessWidget {
  final EnterNameController controller;

  const EnterNameView(this.controller, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your name: ${controller.name}'),
      ),
      body: Center(
        child: TextField(
          controller: controller.textEditingController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.setNameAction,
        child: Icon(Icons.save),
      ),
    );
  }
}
```

Views should just contain code which describes the view. All other parameters or logic should be in the controller. The job of the view class is just to take the current state and build the widget tree and pipe the callbacks back. If there is any calulation necessary which is not solveable as a simple if-else or switch statement, it should be done in an external helper function unter `/lib/utils/`.

All file names must be lower_snake_case. All views must have a `View` suffix and all controller must have a `Controller` suffix. Widgets may have a controller too but they should pass the callbacks back to the view where possible. Calling one line methods directly in the view is only recommended if there is no need to pass a parameter.

To perform an action on state initialization we use the initState method:
```dart
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
```

And the dispose method to perform an action on disposing:
```dart
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
```

To run code after the widget was created first we use the WidgetBindings in the initState:
```dart
@override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Do something when build is finished
    });
    super.initState();
  }
```

### Formatting

We do not allow code with wrong formatting. Please run `flutter format lib` if your IDE doesn't do this automatically.

### Code Analyzis

We do not allow codes with dart errors or warnings. We use the [pedantic](https://pub.dev/packages/pedantic) package for static code analysis with additional rules under `analysis_options.yaml`.

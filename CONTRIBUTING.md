# Contributing to FluffyChat
Contributions are always welcome. Yet we might lack manpower to review all of them in time.

To improve the process please make sure that you read the following guidelines carefully:

## Contributing Guidelines

1. Always create a Pull Request for any changes.
2. Whenever possible please make sure that your Pull Request only contains **one** commit. Cases where multiple commits make sense are very rare.
3. Do not add merge commits. Use rebases.
4. Every Pull Request should change only one thing. For bigger changes it is often better to split them up in multiple Pull Requests.
5. [Sign your commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits).
6. Format the commit message as [Conventional Commits](https://www.conventionalcommits.org).
7. Format (`flutter format lib`) and sort impots (`dart run import_sorter:main --no-comments`) in all code files.
8. For bigger or complex changes (more than a couple of code lines) write an issue or refer to an existing issue and ask for approval from the maintainers (@krille-chan) **before** starting to implement it. This way you reduce the risk that your Pull Request get's declined.
9. Prefer simple and easy to maintain solutions over complexity and fancy ones.

# Code Style

FluffyChat tries to be as minimal as possible even in the code style. We try to keep the code clean, simple and easy to read. The source code of the app is under `/lib` with the main entry point `/lib/main.dart`.

<!-- editorconfig-checker-disable -->
<!-- prettier-ignore-start -->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Directory Structure:](#directory-structure)
- [Separation of Controllers and Views](#separation-of-controllers-and-views)
- [Formatting](#formatting)
- [Code Analyzis](#code-analyzis)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<!-- prettier-ignore-end -->
<!-- editorconfig-checker-enable -->

### Directory Structure:


- /lib
  - /config
    - app_config.dart
    - ...Constants, styles and other configurations
  - /utils
    - handy_function.dart
    - ...Helper functions and extensions
  - /pages
    - /chat
      - chat.dart
      - chat_view.dart
    - /chat_list
      - chat_list.dart
      - chat_list_view.dart
    - ...The pages of the app separated in Controllers and Views
  - /widgets
    - /layouts
    - ...Custom widgets created for this project
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

We do not allow codes with dart errors or warnings. We use the [flutter_lints](https://pub.dev/packages/flutter_lints) package for static code analysis with additional rules under `analysis_options.yaml`.

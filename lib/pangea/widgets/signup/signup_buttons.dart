import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/widgets/common/pangea_logo_svg.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';

class SignupButtons extends StatefulWidget {
  const SignupButtons({super.key});

  @override
  State<SignupButtons> createState() => SignupButtonsState();
}

class SignupButtonsState extends State<SignupButtons> {
  final PangeaController pangeaController = MatrixState.pangeaController;

  void pickAvatar() async {
    final source = !PlatformInfos.isMobile
        ? ImageSource.gallery
        : await showModalActionSheet<ImageSource>(
            context: context,
            title: L10n.of(context).changeYourAvatar,
            actions: [
              SheetAction(
                key: ImageSource.camera,
                label: L10n.of(context).openCamera,
                isDefaultAction: true,
                icon: Icons.camera_alt_outlined,
              ),
              SheetAction(
                key: ImageSource.gallery,
                label: L10n.of(context).openGallery,
                icon: Icons.photo_outlined,
              ),
            ],
          );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
      maxWidth: 512,
      maxHeight: 512,
    );
    setState(() {
      Matrix.of(context).loginAvatar = picked;
    });
  }

  final TextEditingController usernameController = TextEditingController();
  String? signupError;

  void signUp() async {
    usernameController.text = usernameController.text.trim();
    final localpart =
        usernameController.text.toLowerCase().replaceAll(' ', '_');
    if (localpart.isEmpty) {
      setState(() {
        signupError = L10n.of(context).pleaseChooseAUsername;
      });
      return;
    }

    setState(() {
      signupError = null;
    });

    try {
      try {
        await Matrix.of(context).getLoginClient().register(username: localpart);
      } on MatrixException catch (e) {
        if (!e.requireAdditionalAuthentication) rethrow;
      }
      Matrix.of(context).loginUsername = usernameController.text;
      context.go('/home/signup');
    } catch (e, s) {
      Logs().d('Sign up failed', e, s);
      setState(() {
        signupError = e.toLocalizedString(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Matrix.of(context).loginAvatar;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Stack(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(64),
                  elevation:
                      Theme.of(context).appBarTheme.scrolledUnderElevation ??
                          10,
                  color: Colors.transparent,
                  shadowColor:
                      Theme.of(context).colorScheme.onBackground.withAlpha(64),
                  clipBehavior: Clip.hardEdge,
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.white,
                    child: avatar == null
                        ? const Icon(
                            Icons.person_outlined,
                            color: Colors.black,
                            size: 64,
                          )
                        : FutureBuilder<Uint8List>(
                            future: avatar.readAsBytes(),
                            builder: (context, snapshot) {
                              final bytes = snapshot.data;
                              if (bytes == null) {
                                return const CircularProgressIndicator
                                    .adaptive();
                              }
                              return Image.memory(
                                bytes,
                                fit: BoxFit.cover,
                                width: 128,
                                height: 128,
                              );
                            },
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: pickAvatar,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    child: const Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: usernameController,
            onSubmitted: (_) => signUp(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.account_box_outlined),
              hintText: L10n.of(context).chooseAUsername,
              errorText: signupError,
              errorStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
              fillColor:
                  Theme.of(context).colorScheme.background.withOpacity(0.75),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Hero(
            tag: 'signUpButton',
            child: ElevatedButton(
              onPressed: signUp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PangeaLogoSvg(width: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(L10n.of(context).signUp),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  L10n.of(context).or,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

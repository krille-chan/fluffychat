import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';

class SocialNetwork {
  final Widget logo; // The path to social media image
  final String name; // Social media name
  final String chatBot; // ChatBot for send demand
  bool connected; // An indicator if the user is logged in or not

  SocialNetwork({
    required this.logo,
    required this.name,
    required this.chatBot,
    this.connected = false,
  });
}

class AddBridgeBody extends StatefulWidget {
  final Client client;
  const AddBridgeBody({super.key, required this.client});

  @override
  State<AddBridgeBody> createState() => _AddBridgeBodyState();
}

class _AddBridgeBodyState extends State<AddBridgeBody> {
  @override
  Widget build(BuildContext context) {
    final List<SocialNetwork> socialNetwork = [
      SocialNetwork(
        logo: Logo(Logos.facebook_messenger),
        name: "Facebook Messenger",
        chatBot: "",
      ),
      SocialNetwork(
        logo: Logo(Logos.instagram),
        name: "Instagram",
        chatBot: "@instagrambot:loveto.party",
      ),
      SocialNetwork(
        logo: Logo(Logos.whatsapp),
        name: "Whatsapp",
        chatBot: "",
      ),
    ];

    void showNetworkDialog(BuildContext context, SocialNetwork network) {
      String? username;
      String? password;
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                "${L10n.of(context)!.connectYourSocialAccount} ${network.name}",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFAAB22),
                ),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(L10n.of(context)!.enterYourDetails),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: L10n.of(context)!.username),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return L10n.of(context)!.pleaseEnterYourUsername;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: L10n.of(context)!.password),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return L10n.of(context)!.pleaseEnterPassword;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(L10n.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        Navigator.of(context).pop(); // To close ShowDialog
                      } catch (e) {
                        Navigator.of(context).pop();
                        // Display an error message
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Erreur'),
                              content: Text('Une erreur s\'est produite : $e'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text(L10n.of(context)!.login),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                L10n.of(context)!.addSocialMessagingAccounts,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFAAB22),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                L10n.of(context)!.addSocialMessagingAccountsText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            Center(
              child: SizedBox(
                width: PlatformInfos.isWeb
                    ? MediaQuery.of(context).size.width / 2
                    : null,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: socialNetwork.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: socialNetwork[index].logo,
                      title: Text(
                        socialNetwork[index].name,
                      ),
                      subtitle: Text(
                        socialNetwork[index].connected
                            ? L10n.of(context)!.connected
                            : L10n.of(context)!.notConnected,
                        style: TextStyle(
                            color: socialNetwork[index].connected
                                ? Colors.green
                                : Colors.grey),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.right_chevron,
                      ),
                      onTap: () {
                        showNetworkDialog(context, socialNetwork[index]);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

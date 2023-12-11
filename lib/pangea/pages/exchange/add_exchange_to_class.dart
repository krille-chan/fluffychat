import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/widgets/class/add_class_and_invite.dart';
import 'package:fluffychat/pangea/widgets/class/add_space_toggles.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AddExchangeToClass extends StatefulWidget {
  const AddExchangeToClass({super.key});

  @override
  AddExchangeToClassState createState() => AddExchangeToClassState();
}

class AddExchangeToClassState extends State<AddExchangeToClass> {
  final GlobalKey<AddToSpaceState> addToSpaceKey = GlobalKey<AddToSpaceState>();

  @override
  Widget build(BuildContext context) {
    final String spaceId =
        GoRouterState.of(context).pathParameters['exchangeid']!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context)!.addToClassTitle),
      ),
      body: FutureBuilder(
        future:
            Matrix.of(context).client.waitForRoomInSync(spaceId, join: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                const SizedBox(height: 40),
                AddToSpaceToggles(
                  roomId:
                      GoRouterState.of(context).pathParameters['exchangeid'],
                  key: addToSpaceKey,
                  startOpen: true,
                  mode: AddToClassMode.exchange,
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go("/rooms"),
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}

import 'package:fluffychat/controllers/new_group_controller.dart';
import 'package:fluffychat/views/widgets/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class NewGroupView extends StatelessWidget {
  final NewGroupController controller;

  const NewGroupView(
    this.controller, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).createNewGroup),
        elevation: 0,
      ),
      body: MaxWidthBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: controller.controller,
                autofocus: true,
                autocorrect: false,
                textInputAction: TextInputAction.go,
                onSubmitted: controller.submitAction,
                decoration: InputDecoration(
                    labelText: L10n.of(context).optionalGroupName,
                    prefixIcon: Icon(Icons.people_outlined),
                    hintText: L10n.of(context).enterAGroupName),
              ),
            ),
            SwitchListTile(
              title: Text(L10n.of(context).groupIsPublic),
              value: controller.publicGroup,
              onChanged: controller.setPublicGroup,
            ),
            Expanded(
              child: Image.asset('assets/new_group_wallpaper.png'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.submitAction,
        child: Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}

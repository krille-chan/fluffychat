import 'package:flutter/material.dart';

import '../../../widgets/avatar.dart';

class EditClassListTile extends StatefulWidget {
  String title = '';
  Function() onTap;
  String subtitle = "";
  EditClassListTile(
      {super.key,
      required this.title,
      required this.onTap,
      required this.subtitle,});

  @override
  State<EditClassListTile> createState() => _EditClassListTileState();
}

class _EditClassListTileState extends State<EditClassListTile> {
  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.bodyLarge!.color;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: iconColor,
        radius: Avatar.defaultSize / 2,
        child: const Icon(Icons.edit_outlined),
      ),
      title: Text('${widget.title}:',
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,),),
      subtitle: Text(
        widget.subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
      onTap: widget.onTap,
    );
  }
}

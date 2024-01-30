import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class MoreOptionsListTile extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final String title;
  final bool shouldPopOnPress;
  const MoreOptionsListTile({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.title,
    this.shouldPopOnPress = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await onPressed();
        if (shouldPopOnPress) GoRouter.of(context).pop();
      },
      minLeadingWidth: 1,
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.black),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
        size: 16,
      ),
    );
  }
}

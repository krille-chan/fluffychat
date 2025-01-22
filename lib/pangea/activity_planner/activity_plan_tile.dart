import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

class ActivityPlanTile extends StatefulWidget {
  final String activity;
  final VoidCallback onLaunch;
  final ValueChanged<String> onEdit;

  const ActivityPlanTile({
    super.key,
    required this.activity,
    required this.onLaunch,
    required this.onEdit,
  });

  @override
  ActivityPlanTileState createState() => ActivityPlanTileState();
}

class ActivityPlanTileState extends State<ActivityPlanTile> {
  late TextEditingController _controller;
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.activity);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (editMode)
              TextField(
                controller: _controller,
                onChanged: widget.onEdit,
                maxLines: null,
              )
            else
              Text(
                widget.activity,
                maxLines: null,
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      editMode = !editMode;
                    });
                  },
                  child: Text(!editMode ? l10n.edit : l10n.cancel),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: !editMode
                      ? widget.onLaunch
                      : () {
                          setState(() {
                            widget.onEdit(_controller.text);
                            editMode = !editMode;
                          });
                        },
                  child: Text(
                    !editMode ? l10n.launchActivityButton : l10n.saveChanges,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

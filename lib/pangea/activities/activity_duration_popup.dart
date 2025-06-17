import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';

class ActivityDurationPopup extends StatefulWidget {
  final Duration initialValue;
  const ActivityDurationPopup({
    super.key,
    required this.initialValue,
  });

  @override
  State<ActivityDurationPopup> createState() => ActivityDurationPopupState();
}

class ActivityDurationPopupState extends State<ActivityDurationPopup> {
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  String? error;

  final List<Duration> _durations = [
    const Duration(minutes: 15),
    const Duration(minutes: 30),
    const Duration(minutes: 45),
    const Duration(minutes: 60),
    const Duration(hours: 1, minutes: 30),
    const Duration(hours: 2),
    const Duration(hours: 24),
    const Duration(days: 2),
    const Duration(days: 7),
  ];

  @override
  void initState() {
    super.initState();
    _daysController.text = widget.initialValue.inDays.toString();
    _hoursController.text =
        widget.initialValue.inHours.remainder(24).toString();
    _minutesController.text =
        widget.initialValue.inMinutes.remainder(60).toString();

    _daysController.addListener(() => setState(() => error = null));
    _hoursController.addListener(() => setState(() => error = null));
    _minutesController.addListener(() => setState(() => error = null));
  }

  @override
  void dispose() {
    _daysController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _setDuration({int? days, int? hours, int? minutes}) {
    setState(() {
      if (days != null) _daysController.text = days.toString();
      if (hours != null) _hoursController.text = hours.toString();
      if (minutes != null) _minutesController.text = minutes.toString();
    });
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    final List<String> parts = [];
    if (days > 0) parts.add("${days}d");
    if (hours > 0) parts.add("${hours}h");
    if (minutes > 0) parts.add("${minutes}m");
    if (parts.isEmpty) return "0m";

    return parts.join(" ");
  }

  Duration get _duration {
    final days = int.tryParse(_daysController.text) ?? 0;
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    return Duration(days: days, hours: hours, minutes: minutes);
  }

  void _submit() {
    final days = int.tryParse(_daysController.text);
    final hours = int.tryParse(_hoursController.text);
    final minutes = int.tryParse(_minutesController.text);

    if (days == null || hours == null || minutes == null) {
      setState(() {
        error = "Invalid duration";
      });
      return;
    }

    Navigator.of(context).pop(_duration);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 12.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  L10n.of(context).setDuration,
                  style: const TextStyle(fontSize: 20.0, height: 1.2),
                ),
                Column(
                  children: [
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2,
                            color: theme.colorScheme.primary.withAlpha(100),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                        right: 24.0,
                        left: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectionArea(
                            child: Row(
                              spacing: 12.0,
                              children: [
                                _DatePickerInput(
                                  type: "d",
                                  controller: _daysController,
                                ),
                                _DatePickerInput(
                                  type: "h",
                                  controller: _hoursController,
                                ),
                                _DatePickerInput(
                                  type: "m",
                                  controller: _minutesController,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.alarm,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    AnimatedSize(
                      duration: FluffyThemes.animationDuration,
                      child: error != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                error!,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                  fontSize: 14.0,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: _durations
                        .map(
                          (d) => InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              _setDuration(
                                days: d.inDays,
                                hours: d.inHours.remainder(24),
                                minutes: d.inMinutes.remainder(60),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 0.0,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withAlpha(_duration == d ? 200 : 100),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(_formatDuration(d)),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _submit,
                      child: Text(L10n.of(context).confirm),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DatePickerInput extends StatelessWidget {
  final String type;
  final TextEditingController controller;

  const _DatePickerInput({
    required this.type,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 35.0,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(0.0),
              hintText: "0",
              hintStyle: TextStyle(
                fontSize: 20.0,
                color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
              ),
            ),
            style: const TextStyle(
              fontSize: 20.0,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        Text(type, style: const TextStyle(fontSize: 20.0)),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class PQuestionContainer extends StatelessWidget {
  final String title;
  const PQuestionContainer({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 650),
      padding: EdgeInsets.all(size.height * 0.01),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle().copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontSize: 14,
        ),
        overflow: TextOverflow.clip,
        textAlign: TextAlign.left,
      ),
    );
  }
}

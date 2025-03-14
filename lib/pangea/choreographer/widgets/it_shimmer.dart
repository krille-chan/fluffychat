import 'dart:ui';

import 'package:flutter/material.dart';

class ItShimmer extends StatelessWidget {
  const ItShimmer({
    super.key,
    required this.originalSpan,
    required this.fontSize,
  });

  final String originalSpan;
  final double fontSize;

  Iterable<Widget> renderShimmerIfListEmpty(
    BuildContext context, {
    int noOfBars = 3,
  }) {
    final List<String> dummyStrings = [];
    for (int i = 0; i < noOfBars; i++) {
      dummyStrings.add(originalSpan);
    }
    return dummyStrings.map(
      (e) => ITShimmerElement(
        text: e,
        fontSize: fontSize,
      ),
    );
  }

  // PTODO - bring this back, make it shimmer
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [...renderShimmerIfListEmpty(context, noOfBars: 3)],
    );
  }
}

class ITShimmerElement extends StatelessWidget {
  const ITShimmerElement({
    super.key,
    required this.text,
    required this.fontSize,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 50),
      margin: const EdgeInsets.all(2),
      padding: EdgeInsets.zero,
      // decoration: BoxDecoration(
      //   borderRadius: const BorderRadius.all(Radius.circular(10)),
      //   border: Border.all(
      //     color: Theme.of(context).colorScheme.primary,
      //     style: BorderStyle.solid,
      //     width: 2.0,
      //   ),
      // ),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 7),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary.withAlpha(50),
            ),
          ),
          onPressed: () {},
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.transparent, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}

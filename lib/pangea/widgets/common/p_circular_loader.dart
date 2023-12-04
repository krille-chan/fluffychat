import 'package:flutter/material.dart';

class PCircular extends StatelessWidget {
  final double? size;
  const PCircular({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: size ?? 25,
            width: size ?? 25,
            child: const CircularProgressIndicator()),
      ],
    );
  }
}

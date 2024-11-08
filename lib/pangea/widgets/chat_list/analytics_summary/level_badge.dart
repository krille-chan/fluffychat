import 'package:flutter/material.dart';

class LevelBadge extends StatelessWidget {
  final int level;
  const LevelBadge({
    required this.level,
    super.key,
  });

  Color levelColor(int level) {
    final colors = [
      const Color.fromARGB(255, 33, 97, 140), // Dark blue
      const Color.fromARGB(255, 186, 104, 200), // Soft purple
      const Color.fromARGB(255, 123, 31, 162), // Deep purple
      const Color.fromARGB(255, 0, 150, 136), // Teal
      const Color.fromARGB(255, 247, 143, 143), // Light pink
      const Color.fromARGB(255, 220, 20, 60), // Crimson red
    ];
    return colors[level % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: levelColor(level),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "$level",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

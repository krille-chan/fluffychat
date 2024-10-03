import 'package:flutter/material.dart';

class StarAnimationWidget extends StatefulWidget {
  const StarAnimationWidget({super.key});

  @override
  _StarAnimationWidgetState createState() => _StarAnimationWidgetState();
}

class _StarAnimationWidgetState extends State<StarAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duration of the animation
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation in reverse

    // Define the opacity animation
    _opacityAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(_controller);

    // Define the size animation
    _sizeAnimation = Tween<double>(begin: 56.0, end: 60.0).animate(_controller);
  }

  @override
  void dispose() {
    // Dispose of the controller to free resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Set constant height and width for the star container
      height: 80.0,
      width: 80.0,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Icon(
                Icons.star,
                color: Colors.amber,
                size: _sizeAnimation.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class GamifiedTextWidget extends StatelessWidget {
  final String userMessage;

  const GamifiedTextWidget({super.key, required this.userMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjusts the size to fit children
        children: [
          // Star animation above the text
          const StarAnimationWidget(),
          const SizedBox(height: 10), // Spacing between the star and text
          Container(
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            child: Text(
              userMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Center-align the text
            ),
          ),
        ],
      ),
    );
  }
}

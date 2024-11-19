import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/enum/instructions_enum.dart';
import 'package:fluffychat/pangea/utils/inline_tooltip.dart';
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
      height: 60.0,
      width: 60.0,
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
  const GamifiedTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppConfig.toolbarMinWidth,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          children: [
            StarAnimationWidget(),
            InlineTooltip(
              instructionsEnum: InstructionsEnum.unlockedLanguageTools,
            ),
          ],
        ),
      ),
    );
  }
}

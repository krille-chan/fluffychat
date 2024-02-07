import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tawkie/pages/welcome_slides/datas/sides_datas.dart';

class WelcomeSlidePage extends StatefulWidget {
  const WelcomeSlidePage({super.key});

  @override
  State<WelcomeSlidePage> createState() => _WelcomeSlidePageState();
}

class _WelcomeSlidePageState extends State<WelcomeSlidePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: slidesData.length,
        itemBuilder: (context, index) {
          final slide = slidesData[index];
          return SlideItem(
            gifAsset: slide.gifAsset,
            text: slide.text,
            isLastSlide: index == slidesData.length - 1,
            onNext: () {
              if (index == slidesData.length - 1) {
                GoRouter.of(context).go('/home');
              } else {
                setState(() {
                  currentIndex = index + 1;
                });
              }
            },
          );
        },
      ),
    );
  }
}

class SlideItem extends StatelessWidget {
  final String gifAsset;
  final String text;
  final bool isLastSlide;
  final VoidCallback onNext;

  SlideItem({
    required this.gifAsset,
    required this.text,
    required this.isLastSlide,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(gifAsset),
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 20),
        Text(
          text,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        if (isLastSlide)
          ElevatedButton(
            onPressed: onNext,
            child: Text('Next'),
          ),
      ],
    );
  }
}

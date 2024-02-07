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
      body: Stack(
        children: [
          PageView.builder(
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
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          if (currentIndex > 0)
            Positioned(
              left: 20,
              top: MediaQuery.of(context).size.height / 2,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    currentIndex--;
                  });
                },
              ),
            ),
          if (currentIndex < slidesData.length - 1)
            Positioned(
              right: 20,
              top: MediaQuery.of(context).size.height / 2,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    currentIndex++;
                  });
                },
              ),
            ),
          Positioned(
            right: 50,
            top: 50,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go('/home');
                },
                child: Text(
                    currentIndex == slidesData.length - 1 ? 'Next' : "Skip"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlideItem extends StatelessWidget {
  final String gifAsset;
  final String text;
  final bool isLastSlide;
  final VoidCallback onNext;

  const SlideItem({
    super.key,
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
        Flexible(
            child: Image(
          image: AssetImage(gifAsset),
          fit: BoxFit.contain,
        )),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

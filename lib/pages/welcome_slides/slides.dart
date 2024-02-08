import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tawkie/pages/welcome_slides/datas/sides_datas.dart';

class WelcomeSlidePage extends StatefulWidget {
  const WelcomeSlidePage({super.key});

  @override
  State<WelcomeSlidePage> createState() => _WelcomeSlidePageState();
}

class _WelcomeSlidePageState extends State<WelcomeSlidePage> {
  late final PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: slidesData.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              final slide = slidesData[index];
              return SlideItem(
                gifAsset: slide.gifAsset,
                textKey: slide.textKey,
                isLastSlide: index == slidesData.length - 1,
                onNext: () {
                  if (index == slidesData.length - 1) {
                    GoRouter.of(context).go('/home');
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
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
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
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
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class SlideItem extends StatelessWidget {
  final String gifAsset;
  final String Function(BuildContext) textKey;
  final bool isLastSlide;
  final VoidCallback onNext;

  const SlideItem({
    super.key,
    required this.gifAsset,
    required this.textKey,
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
            fit: BoxFit.fitWidth,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textKey(context), // Call function to obtain resolved localization key (for translations)
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/pangea/join_codes/space_code_repo.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class LoginOrSignupView extends StatefulWidget {
  const LoginOrSignupView({super.key});

  @override
  State<LoginOrSignupView> createState() => _LoginOrSignupViewState();
}

class _LoginOrSignupViewState extends State<LoginOrSignupView> {
  static const _breakpoint = 832.0;

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  bool _isMobile = PlatformInfos.isMobile;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final width = MediaQuery.sizeOf(context).width;
      _isMobile = width <= _breakpoint;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width <= _breakpoint;

    final breakpointChanged = _isMobile != isMobile;
    if (breakpointChanged) {
      _isMobile = isMobile;
    }
  }

  String? get _cachedSpaceCode => SpaceCodeRepo.spaceCode;

  List<String> get _imageFileNames {
    final ratio = _isMobile ? 'ratio4x5' : 'ratio2x1';
    return List.generate(6, (i) => 'Carousel_${i + 1}_$ratio.png');
  }

  List<String> get imageUrls => _imageFileNames
      .map((name) => '${AppConfig.assetsBaseURL}/$name')
      .toList();

  List<String> get _labels => [
    L10n.of(context).appDescription,
    L10n.of(context).writeAndSpeakWorryFree,
    L10n.of(context).joinLearningCommunities,
    L10n.of(context).playConversationGames,
    L10n.of(context).jumpIntoConversation,
    L10n.of(context).playPersonalizedGames,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth <= _breakpoint;
            final imageUrls = _imageFileNames
                .map((name) => '${AppConfig.assetsBaseURL}/$name')
                .toList();

            return Column(
              children: [
                _LoginCarousel(
                  isMobile: isMobile,
                  imageUrls: imageUrls,
                  labels: _labels,
                  onPageChange: (index) {
                    if (mounted) {
                      setState(() => _currentIndex = index);
                    }
                  },
                  controller: _carouselController,
                ),
                if (isMobile) ...[
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imageUrls.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              // push instead of go so the app bar back button doesn't go to the language selection page
                              // https://github.com/pangeachat/client/issues/4421
                              onPressed: () => context.push(
                                _cachedSpaceCode != null
                                    ? '/home/language/signup'
                                    : '/home/language',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                foregroundColor:
                                    theme.colorScheme.onPrimaryContainer,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    L10n.of(context).getStarted,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.onSurface,
                              ),
                              onPressed: () => context.go('/home/login'),
                              child: Text(
                                L10n.of(context).loginToAccount,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LoginCarousel extends StatelessWidget {
  final bool isMobile;
  final List<String> imageUrls;
  final List<String> labels;
  final Function(int) onPageChange;
  final CarouselSliderController controller;

  const _LoginCarousel({
    required this.isMobile,
    required this.imageUrls,
    required this.labels,
    required this.onPageChange,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.widthOf(context);

    if (isMobile) {
      return SizedBox(
        width: screenWidth,
        height: screenWidth * 1.25,
        child: CarouselSlider(
          items: imageUrls
              .mapIndexed(
                (index, imageUrl) => Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        errorWidget: (context, url, error) =>
                            Center(child: PangeaLogoSvg(width: 128.0)),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 20,
                      right: 20,
                      child: Text(
                        labels[index],
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          carouselController: controller,
          options: CarouselOptions(
            height: double.infinity,
            viewportFraction: 1.0,
            autoPlay: true,
            onPageChanged: (index, _) => onPageChange(index),
          ),
        ),
      );
    }

    // Desktop
    return Expanded(
      flex: 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 100.0),
            child: CarouselSlider(
              items: imageUrls
                  .mapIndexed(
                    (index, imageUrl) => SizedBox(
                      width: screenWidth * 0.8,
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(bottom: 32.0),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Center(child: PangeaLogoSvg(width: 256.0)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 20,
                            right: 20,
                            child: Text(
                              labels[index],
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              carouselController: controller,
              options: CarouselOptions(
                viewportFraction: 1.0,
                autoPlay: true,
                onPageChanged: (index, _) {
                  onPageChange(index);
                },
              ),
            ),
          ),
          Positioned(
            left: 20,
            child: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: controller.previousPage,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Positioned(
            right: 20,
            child: IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: controller.nextPage,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

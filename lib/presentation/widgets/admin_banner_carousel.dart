import 'dart:async';
import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/presentation/widgets/dots_indicator.dart';
import 'package:solofy_vendor_app/presentation/widgets/home_banner_slide.dart';

export 'package:solofy_vendor_app/presentation/widgets/home_banner_slide.dart';

class AdminBannerCarousel extends StatefulWidget {
  const AdminBannerCarousel({
    super.key,
    this.boxHeight = bannerHeight,
    this.itemCount = 4,
    this.bannerImages,
  });

  final double boxHeight;
  final int itemCount;
  final List<String>? bannerImages;

  static const double bannerHeight = 98.0; // FIXED height, named constant (~98 design dp)
  static const double bannerRadius = 16.0;
  static const double iconHeight = 36.0;
  static const double gapToDots = 8.0;

  @override
  State<AdminBannerCarousel> createState() => _AdminBannerCarouselState();
}

class _AdminBannerCarouselState extends State<AdminBannerCarousel>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;
  bool _isUserDragging = false;

  // Virtual index multiplier for infinite loop
  static const int _infiniteMultiplier = 1000;

  int get _initialPage =>
      widget.itemCount > 0 ? widget.itemCount * (_infiniteMultiplier ~/ 2) : 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(initialPage: _initialPage);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.itemCount <= 1) return;
    _timer = Timer.periodic(AppConstants.bannerAutoScrollDuration, (timer) {
      if (!mounted || !_pageController.hasClients || _isUserDragging) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Solid Primary Blue Banner Box - FIXED height, radius 16.s, clipped
        SizedBox(
          height: widget.boxHeight.s,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ColorResources.primary,
              borderRadius:
                  BorderRadius.circular(AdminBannerCarousel.bannerRadius.s),
              boxShadow: [
                BoxShadow(
                  color: ColorResources.primary.withValues(alpha: 0.25),
                  blurRadius: 10.s,
                  offset: Offset(0, 3.s),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(AdminBannerCarousel.bannerRadius.s),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    if (notification.dragDetails != null) {
                      _isUserDragging = true;
                      _timer?.cancel();
                    }
                  } else if (notification is ScrollEndNotification) {
                    if (_isUserDragging) {
                      _isUserDragging = false;
                      _startTimer();
                    }
                  }
                  return false;
                },
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (virtualIndex) {
                    final realIndex = widget.itemCount > 0
                        ? virtualIndex % widget.itemCount
                        : 0;
                    if (_currentIndex != realIndex) {
                      setState(() => _currentIndex = realIndex);
                    }
                  },
                  itemBuilder: (context, virtualIndex) {
                    final realIndex = widget.itemCount > 0
                        ? virtualIndex % widget.itemCount
                        : 0;
                    final images = widget.bannerImages;
                    final imageUrl =
                        (images != null && realIndex < images.length)
                            ? images[realIndex]
                            : null;

                    return HomeBannerSlide(
                      imageUrl: imageUrl,
                      iconHeight: AdminBannerCarousel.iconHeight,
                      showDotsInside: false,
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // 2. Dots Indicator BELOW the box, outside the banner (inactive light blue-grey, active primary)
        SizedBox(height: AdminBannerCarousel.gapToDots.s),
        DotsIndicator(
          itemCount: widget.itemCount,
          currentIndex: _currentIndex,
          dotHeight: 6.s,
          activeWidth: 6.s,
          inactiveWidth: 6.s,
          spacing: 3.s,
          activeColor: ColorResources.primary,
          inactiveColor: const Color(0xFFC2D6E7),
        ),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/diamentions.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/presentation/widgets/dots_indicator.dart';

class AdImageCarousel extends StatefulWidget {
  const AdImageCarousel({super.key, required this.images});

  final List<String> images;

  @override
  State<AdImageCarousel> createState() => _AdImageCarouselState();
}

class _AdImageCarouselState extends State<AdImageCarousel> {
  int _currentIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: ColorResources.lightBlue,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ColorResources.primary,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: ColorResources.lightBlue,
            child: const Center(
              child: Icon(Icons.broken_image, color: ColorResources.grey),
            ),
          );
        },
      );
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: ColorResources.lightBlue,
            child: const Center(
              child: Icon(Icons.broken_image, color: ColorResources.grey),
            ),
          );
        },
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: ColorResources.lightBlue,
          child: const Center(
            child: Icon(Icons.broken_image, color: ColorResources.grey),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    final count = widget.images.length;

    return Column(
      children: [
        SizedBox(
          height: AppConstants.adCarouselHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImage(widget.images[index]),
                ),
              );
            },
          ),
        ),
        gap8,
        DotsIndicator(
          itemCount: count,
          currentIndex: _currentIndex,
        ),
      ],
    );
  }
}


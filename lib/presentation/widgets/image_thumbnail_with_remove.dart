import 'dart:io';
import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';

class ImageThumbnailWithRemove extends StatelessWidget {
  const ImageThumbnailWithRemove({
    super.key,
    required this.imagePath,
    required this.onRemove,
    this.width = 96,
    this.height = 76,
  });

  final String imagePath;
  final VoidCallback onRemove;
  final double width;
  final double height;

  Widget _buildImage() {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, fit: BoxFit.cover, width: width, height: height);
    }
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(imagePath, fit: BoxFit.cover, width: width, height: height);
    }
    return Image.file(File(imagePath), fit: BoxFit.cover, width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: width,
            height: height,
            child: _buildImage(),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: ColorResources.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


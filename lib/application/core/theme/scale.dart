import 'package:solofy_vendor_app/application/core/app_details.dart';

/// Figma design frame width.
const double figmaWidth = 393.0;

/// Returns current screen width or falls back to [figmaWidth] if not yet initialized.
double get screenWidth {
  final w = AppDetails.screenSize.width;
  return w > 0 ? w : figmaWidth;
}

/// Dynamic scale factor clamped to prevent excessive shrinking or blowing up on tablets/foldables.
double get scaleFactor => (screenWidth / figmaWidth).clamp(0.85, 1.25);

/// Number extension to scale design px to device px.
extension ScaleNum on num {
  double get s => this * scaleFactor;
}


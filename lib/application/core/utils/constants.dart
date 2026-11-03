/// App-wide constant values (limits, durations, defaults).
/// UI text lives in `string_file.dart`, sizes/spacing in `theme/diamentions.dart`.
class AppConstants {
  static const countryCode = '+91';
  static const phoneLength = 10;
  static const otpLength = 6;
  static const pincodeLength = 6;
  static const otpResendSeconds = 30;
  static const splashDuration = Duration(seconds: 2);
  static const bannerAutoScrollDuration = Duration(seconds: 3);
  static const adCarouselHeight = 170.0;
  static const defaultAdRadius = 16.0;
  static const pricePerDay = 50;
  static const maxDisplayDescription = 50;
  static const maxDescription = 150;
  static const maxImages = 5;
  static const maxComment = 500;
  static const defaultVendorPhone = '+91 8606449640';

  // TODO(api): Replace with categories API when backend is ready
  static const defaultCategories = [
    'All',
    'Property',
    'Vehicles',
    'Jobs',
    'Electronics',
  ];

  // TODO(api): Replace with plans API when backend is ready
  static const defaultPlans = [
    'All',
    'Regular',
    'Featured',
    'Urgent',
  ];
}

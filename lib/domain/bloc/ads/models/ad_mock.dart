import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';

class AdMock {
  static const commonDescription =
      "Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. "
      "Lorem Ipsum Has Been The Industry's Standard Dummy Text Ever Since The 1500s, "
      "When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type "
      "Specimen Book. Scrambled It To Make A Type When An Unknown Printer Took A Galley "
      "Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type";

  static const jobOtherInfo =
      "Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. "
      "Lorem Ipsum Has Been The Industry's Standard Dummy Text Ever Since The 1500s";

  /// 1. Screenshot 1: Property, Active, isInterested = false
  static const propertyActive = AdDetail(
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025 | 10:00 AM',
    description: commonDescription,
    isNew: true,
    isUrgent: true,
    viewCount: 200,
    images: [
      AppAssets.housePng,
      AppAssets.housePng,
      AppAssets.housePng,
      AppAssets.housePng,
    ],
    skills: [],
    otherInfo: '',
    locationLabel: 'Pincode, Palazhi , Calicut',
    latitude: 11.2335,
    longitude: 75.8335,
    expiresInDays: 10,
    posterName: 'Wade Warren',
    posterPhone: '+91 8606449640',
    posterOnWhatsApp: true,
    posterAvatarUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    type: AdType.property,
    status: AdStatus.active,
    registeredNumber: '+91 8606449640',
  );

  /// 2. Screenshot 2: Job, Expiring Soon, isInterested = false
  static const jobExpiringSoon = AdDetail(
    adRef: '0123456789',
    title: 'Job Opening',
    postedAt: '22 Jul 2025 | 10:00 AM',
    description: commonDescription,
    isNew: false,
    isUrgent: true,
    viewCount: 200,
    images: [],
    skills: [
      'Communication',
      'Adobe Suites',
      'Problem Solving',
    ],
    otherInfo: jobOtherInfo,
    locationLabel: 'Govt. Cyberpark , Calicut',
    latitude: 11.2842,
    longitude: 75.8756,
    expiresInDays: 2,
    posterName: 'Wade Warren',
    posterPhone: '+91 8606449640',
    posterOnWhatsApp: true,
    posterAvatarUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    type: AdType.job,
    status: AdStatus.expiringSoon,
    registeredNumber: '+91 8606449640',
  );

  /// 3. Screenshot 3: Job, Expired
  static const jobExpired = AdDetail(
    adRef: '0123456789',
    title: 'Job Opening',
    postedAt: '22 Jul 2025 | 10:00 AM',
    description: commonDescription,
    isNew: false,
    isUrgent: false,
    viewCount: 200,
    images: [],
    skills: [
      'Communication',
      'Adobe Suites',
      'Problem Solving',
    ],
    otherInfo: jobOtherInfo,
    locationLabel: 'Govt. Cyberpark , Calicut',
    latitude: 11.2842,
    longitude: 75.8756,
    expiresInDays: 0,
    posterName: 'Wade Warren',
    posterPhone: '+91 8606449640',
    posterOnWhatsApp: false,
    posterAvatarUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    type: AdType.job,
    status: AdStatus.expired,
    registeredNumber: '+91 8606449640',
  );

  /// 4. Screenshot 4: Property, Active, isInterested = true
  static const propertyInterested = AdDetail(
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025 | 10:00 AM',
    description: commonDescription,
    isNew: true,
    isUrgent: true,
    viewCount: 200,
    images: [
      AppAssets.housePng,
      AppAssets.housePng,
      AppAssets.housePng,
      AppAssets.housePng,
    ],
    skills: [],
    otherInfo: '',
    locationLabel: 'Pincode, Palazhi , Calicut',
    latitude: 11.2335,
    longitude: 75.8335,
    expiresInDays: 10,
    posterName: 'Wade Warren',
    posterPhone: '+91 8606449640',
    posterOnWhatsApp: true,
    posterAvatarUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    type: AdType.property,
    status: AdStatus.active,
    registeredNumber: '+91 8606449640',
  );
}


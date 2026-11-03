import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';

enum AdSection { today, yesterday }

enum AdStatus { viewed, unread, suitable }

enum AdRibbon { newBadge, featured, urgent }

class AdItem {
  const AdItem({
    required this.id,
    required this.title,
    required this.date,
    required this.dateTime,
    required this.views,
    required this.description,
    required this.location,
    required this.category,
    required this.distanceKm,
    this.pincode = '673014',
    this.section = AdSection.today,
    this.status = AdStatus.viewed,
    this.ribbon,
    this.dotColor,
    this.isBanner = false,
    this.adRef = '0123456789',
    this.postedTime = '22 Jul 2025 | 10:00 AM',
    this.isActive = true,
    this.expiringInDays = 10,
    this.registeredNumber = '+91 8606449640',
    this.hasNewBadge = false,
    this.hasUrgentBadge = false,
    this.skills,
    this.images = const [],
  });

  final String id;
  final String title;
  final String date;
  final DateTime dateTime;
  final int views;
  final String description;
  final String location;
  final String category;
  final double distanceKm;
  final String pincode;
  final AdSection section;
  final AdStatus status;
  final AdRibbon? ribbon;
  final Color? dotColor;
  final bool isBanner;
  final String adRef;
  final String postedTime;
  final bool isActive;
  final int expiringInDays;
  final String registeredNumber;
  final bool hasNewBadge;
  final bool hasUrgentBadge;
  final List<String>? skills;
  final List<String> images;

  /// Default mock items matching the designs in Image 2, 3 & detail screens.
  static List<AdItem> get initialMockAds => [
        // ---- Today Section ----
        AdItem(
          id: '1',
          title: 'Property For Rent',
          date: '22 Jul 2025',
          dateTime: DateTime(2025, 7, 22),
          views: 200,
          description:
              "Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry's Standard Dummy Text Ever Since The 1500s, When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type",
          location: 'Pincode, Palazhi , Calicut',
          category: 'Property',
          distanceKm: 12,
          pincode: '673014',
          section: AdSection.today,
          status: AdStatus.viewed,
          ribbon: AdRibbon.newBadge,
          hasNewBadge: true,
          hasUrgentBadge: true,
          images: const [AppAssets.housePng, AppAssets.housePng],
        ),
        AdItem(
          id: '2',
          title: 'Car For Sale',
          date: '22 Jul 2025',
          dateTime: DateTime(2025, 7, 22),
          views: 100,
          description:
              'Lorem Ipsum Dolor Sit Amet, Consectetur Elit Sed. Well maintained car in pristine condition with complete service history.',
          location: 'Pantheramkavu, Calicut',
          category: 'Car',
          distanceKm: 28,
          pincode: '673019',
          section: AdSection.today,
          status: AdStatus.unread,
          ribbon: AdRibbon.featured,
          hasUrgentBadge: false,
        ),
        AdItem(
          id: '3',
          title: 'Job Opening',
          date: '22 Jul 2025',
          dateTime: DateTime(2025, 7, 22),
          views: 200,
          description:
              "Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry's Standard Dummy Text Ever Since The 1500s, When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type",
          location: 'Govt. Cyberpark , Calicut',
          category: 'Job',
          distanceKm: 42,
          pincode: '673016',
          section: AdSection.today,
          status: AdStatus.suitable,
          ribbon: AdRibbon.urgent,
          hasUrgentBadge: true,
          expiringInDays: 2,
          isActive: false, // Expiring soon
          skills: const [
            'Communication',
            'Adobe Suites',
            'Problem Solving',
          ],
        ),
        // Item 4: In-feed banner in Today section
        AdItem(
          id: 'banner-today',
          title: 'Admin Banner',
          date: '',
          dateTime: DateTime(2025, 7, 22),
          views: 0,
          description: '',
          location: '',
          category: '',
          distanceKm: 0,
          section: AdSection.today,
          isBanner: true,
        ),

        // ---- Yesterday Section ----
        AdItem(
          id: '5',
          title: 'Car For Sale',
          date: '21 Jul 2025',
          dateTime: DateTime(2025, 7, 21),
          views: 108,
          description: 'Lorem Ipsum Dolor Sit Amet, Consectetur Elit Sed.',
          location: 'Pantheramkavu, Calicut',
          category: 'Car',
          distanceKm: 25,
          pincode: '673019',
          section: AdSection.yesterday,
          status: AdStatus.unread,
          dotColor: const Color(0xFFFF9800), // Orange dot
        ),
        AdItem(
          id: '6',
          title: 'Rent House',
          date: '21 Jul 2025',
          dateTime: DateTime(2025, 7, 21),
          views: 280,
          description: 'Lorem Ipsum Dolor Sit Amet, Consectetur Elit Sed.',
          location: 'Palazhi, Calicut',
          category: 'House',
          distanceKm: 18,
          pincode: '673014',
          section: AdSection.yesterday,
          status: AdStatus.unread,
          dotColor: const Color(0xFF00B72E), // Green dot
          images: const [AppAssets.housePng],
        ),
        AdItem(
          id: '7',
          title: 'Car For Sale',
          date: '21 Jul 2025',
          dateTime: DateTime(2025, 7, 21),
          views: 108,
          description: 'Lorem Ipsum Dolor Sit Amet, Consectetur Elit Sed.',
          location: 'Pantheramkavu, Calicut',
          category: 'Car',
          distanceKm: 34,
          pincode: '673019',
          section: AdSection.yesterday,
          status: AdStatus.unread,
          dotColor: const Color(0xFFFF9800), // Orange dot
        ),
        AdItem(
          id: '8',
          title: 'Rent House',
          date: '21 Jul 2025',
          dateTime: DateTime(2025, 7, 21),
          views: 280,
          description: 'Lorem Ipsum Dolor Sit Amet, Consectetur Elit Sed.',
          location: 'Palazhi, Calicut',
          category: 'House',
          distanceKm: 49,
          pincode: '673014',
          section: AdSection.yesterday,
          status: AdStatus.unread,
          dotColor: const Color(0xFF00B72E), // Green dot
          images: const [AppAssets.housePng],
        ),
      ];
}

class AdFilter {
  const AdFilter({
    this.searchQuery = '',
    this.category = 'All',
    this.sort = 'Latest',
    this.maxDistanceKm = 50.0,
    this.selectedDate,
    this.pincode = '',
  });

  final String searchQuery;
  final String category;
  final String sort;
  final double maxDistanceKm;
  final DateTime? selectedDate;
  final String pincode;

  AdFilter copyWith({
    String? searchQuery,
    String? category,
    String? sort,
    double? maxDistanceKm,
    DateTime? selectedDate,
    bool clearDate = false,
    String? pincode,
  }) {
    return AdFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      selectedDate: clearDate ? null : (selectedDate ?? this.selectedDate),
      pincode: pincode ?? this.pincode,
    );
  }
}

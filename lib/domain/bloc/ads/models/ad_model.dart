import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';

enum AdRibbonType {
  newBadge,
  featured,
  urgent,
}

class AdModel {
  const AdModel({
    required this.id,
    required this.adRef,
    required this.title,
    required this.postedAt,
    required this.viewCount,
    required this.description,
    required this.locationLabel,
    this.category = 'Property',
    this.subCategory = 'Rent',
    this.status = AdStatus.active,
    this.dotColor = ColorResources.statusActive,
    this.ribbonType,
    this.feedback,
    this.isUnread = false,
    this.isFeatured = false,
    this.isBanner = false,
  });

  final String id;
  final String adRef;
  final String title;
  final String postedAt;
  final int viewCount;
  final String description;
  final String locationLabel;
  final String category;
  final String subCategory;
  final AdStatus status;
  final Color dotColor;
  final AdRibbonType? ribbonType;
  final InterestFeedback? feedback;
  final bool isUnread;
  final bool isFeatured;
  final bool isBanner;

  AdModel copyWith({
    String? id,
    String? adRef,
    String? title,
    String? postedAt,
    int? viewCount,
    String? description,
    String? locationLabel,
    String? category,
    String? subCategory,
    AdStatus? status,
    Color? dotColor,
    AdRibbonType? ribbonType,
    InterestFeedback? feedback,
    bool? isUnread,
    bool? isFeatured,
    bool? isBanner,
  }) {
    return AdModel(
      id: id ?? this.id,
      adRef: adRef ?? this.adRef,
      title: title ?? this.title,
      postedAt: postedAt ?? this.postedAt,
      viewCount: viewCount ?? this.viewCount,
      description: description ?? this.description,
      locationLabel: locationLabel ?? this.locationLabel,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      status: status ?? this.status,
      dotColor: dotColor ?? this.dotColor,
      ribbonType: ribbonType ?? this.ribbonType,
      feedback: feedback ?? this.feedback,
      isUnread: isUnread ?? this.isUnread,
      isFeatured: isFeatured ?? this.isFeatured,
      isBanner: isBanner ?? this.isBanner,
    );
  }

  AdDetail toAdDetail() {
    return AdDetail(
      adRef: adRef,
      title: title,
      postedAt: postedAt,
      description: description,
      viewCount: viewCount,
      locationLabel: locationLabel,
      type: title.toLowerCase().contains('job') ? AdType.job : AdType.property,
      status: status,
      isNew: ribbonType == AdRibbonType.newBadge,
      isUrgent: ribbonType == AdRibbonType.urgent,
      expiresInDays: 10,
      images: const ['assets/images/pngs/house.png'],
      skills: const ['Flutter', 'Dart', 'UI/UX'],
      otherInfo: 'Immediate joining preferred.',
      latitude: 11.2588,
      longitude: 75.7804,
      posterName: 'Ad Poster',
      posterPhone: '+91 8606449640',
      posterOnWhatsApp: true,
      posterAvatarUrl: '',
    );
  }
}

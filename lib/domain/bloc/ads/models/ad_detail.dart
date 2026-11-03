import 'package:equatable/equatable.dart';

enum AdType { property, job }

enum AdStatus { active, expiringSoon, expired, stopped }

enum InterestFeedback { suitable, contactAgain, notSuitable }

class AdDetail extends Equatable {
  const AdDetail({
    required this.adRef,
    required this.title,
    required this.postedAt,
    required this.description,
    required this.isNew,
    required this.isUrgent,
    required this.viewCount,
    required this.images,
    required this.skills,
    required this.otherInfo,
    required this.locationLabel,
    required this.latitude,
    required this.longitude,
    required this.expiresInDays,
    required this.posterName,
    required this.posterPhone,
    required this.posterOnWhatsApp,
    required this.posterAvatarUrl,
    required this.type,
    required this.status,
    this.registeredNumber = '+91 8606449640',
  });

  final String adRef;
  final String title;
  final String postedAt;
  final String description;
  final bool isNew;
  final bool isUrgent;
  final int viewCount;
  final List<String> images;
  final List<String> skills;
  final String otherInfo;
  final String locationLabel;
  final double latitude;
  final double longitude;
  final int expiresInDays;
  final String posterName;
  final String posterPhone;
  final bool posterOnWhatsApp;
  final String posterAvatarUrl;
  final AdType type;
  final AdStatus status;
  final String registeredNumber;

  AdDetail copyWith({
    String? adRef,
    String? title,
    String? postedAt,
    String? description,
    bool? isNew,
    bool? isUrgent,
    int? viewCount,
    List<String>? images,
    List<String>? skills,
    String? otherInfo,
    String? locationLabel,
    double? latitude,
    double? longitude,
    int? expiresInDays,
    String? posterName,
    String? posterPhone,
    bool? posterOnWhatsApp,
    String? posterAvatarUrl,
    AdType? type,
    AdStatus? status,
    String? registeredNumber,
  }) {
    return AdDetail(
      adRef: adRef ?? this.adRef,
      title: title ?? this.title,
      postedAt: postedAt ?? this.postedAt,
      description: description ?? this.description,
      isNew: isNew ?? this.isNew,
      isUrgent: isUrgent ?? this.isUrgent,
      viewCount: viewCount ?? this.viewCount,
      images: images ?? this.images,
      skills: skills ?? this.skills,
      otherInfo: otherInfo ?? this.otherInfo,
      locationLabel: locationLabel ?? this.locationLabel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      expiresInDays: expiresInDays ?? this.expiresInDays,
      posterName: posterName ?? this.posterName,
      posterPhone: posterPhone ?? this.posterPhone,
      posterOnWhatsApp: posterOnWhatsApp ?? this.posterOnWhatsApp,
      posterAvatarUrl: posterAvatarUrl ?? this.posterAvatarUrl,
      type: type ?? this.type,
      status: status ?? this.status,
      registeredNumber: registeredNumber ?? this.registeredNumber,
    );
  }

  @override
  List<Object?> get props => [
        adRef,
        title,
        postedAt,
        description,
        isNew,
        isUrgent,
        viewCount,
        images,
        skills,
        otherInfo,
        locationLabel,
        latitude,
        longitude,
        expiresInDays,
        posterName,
        posterPhone,
        posterOnWhatsApp,
        posterAvatarUrl,
        type,
        status,
        registeredNumber,
      ];
}


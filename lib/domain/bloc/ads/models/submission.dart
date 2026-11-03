import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interest_round.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';

class Submission extends Equatable {
  const Submission({
    required this.id,
    required this.adRef,
    required this.title,
    required this.postedAt,
    required this.viewCount,
    required this.description,
    required this.locationLabel,
    required this.interestedCount,
    required this.status,
    this.category = 'Property',
    this.plan = 'Featured',
    this.contactNumber = '8606449640',
    this.alternateNumber = '8606449640',
    this.photos = const [],
    this.stoppedAt,
    this.rejectionReason,
    this.rePostedAt,
    this.rounds = const [],
    this.stoppedAtFormatted,
    this.rePostedAtFormatted,
  });

  final String id;
  final String adRef;
  final String title;
  final String postedAt;
  final int viewCount;
  final String description;
  final String locationLabel;
  final int interestedCount;
  final SubmissionStatus status;
  final String category;
  final String plan;
  final String contactNumber;
  final String alternateNumber;
  final List<String> photos;
  final DateTime? stoppedAt;
  final String? rejectionReason;
  final DateTime? rePostedAt;
  final List<InterestRound> rounds;
  final String? stoppedAtFormatted;
  final String? rePostedAtFormatted;

  AdDetail toAdDetail() {
    return AdDetail(
      adRef: adRef,
      title: title,
      postedAt: postedAt,
      description: description,
      viewCount: viewCount,
      locationLabel: locationLabel,
      type: title.toLowerCase().contains('job') ? AdType.job : AdType.property,
      status: status.toAdStatus(),
      isNew: false,
      isUrgent: plan.toLowerCase() == 'urgent',
      expiresInDays: 10,
      images: photos.isNotEmpty ? photos : const ['assets/images/pngs/house.png'],
      skills: const ['Flutter', 'Dart', 'UI/UX'],
      otherInfo: 'Immediate response preferred.',
      latitude: 11.2588,
      longitude: 75.7804,
      posterName: 'Ad Poster',
      posterPhone: contactNumber,
      posterOnWhatsApp: true,
      posterAvatarUrl: '',
      registeredNumber: contactNumber,
    );
  }

  Submission copyWith({
    String? id,
    String? adRef,
    String? title,
    String? postedAt,
    int? viewCount,
    String? description,
    String? locationLabel,
    int? interestedCount,
    SubmissionStatus? status,
    String? category,
    String? plan,
    String? contactNumber,
    String? alternateNumber,
    List<String>? photos,
    DateTime? stoppedAt,
    String? rejectionReason,
    DateTime? rePostedAt,
    List<InterestRound>? rounds,
    String? stoppedAtFormatted,
    String? rePostedAtFormatted,
  }) {
    return Submission(
      id: id ?? this.id,
      adRef: adRef ?? this.adRef,
      title: title ?? this.title,
      postedAt: postedAt ?? this.postedAt,
      viewCount: viewCount ?? this.viewCount,
      description: description ?? this.description,
      locationLabel: locationLabel ?? this.locationLabel,
      interestedCount: interestedCount ?? this.interestedCount,
      status: status ?? this.status,
      category: category ?? this.category,
      plan: plan ?? this.plan,
      contactNumber: contactNumber ?? this.contactNumber,
      alternateNumber: alternateNumber ?? this.alternateNumber,
      photos: photos ?? this.photos,
      stoppedAt: stoppedAt ?? this.stoppedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      rePostedAt: rePostedAt ?? this.rePostedAt,
      rounds: rounds ?? this.rounds,
      stoppedAtFormatted: stoppedAtFormatted ?? this.stoppedAtFormatted,
      rePostedAtFormatted: rePostedAtFormatted ?? this.rePostedAtFormatted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        adRef,
        title,
        postedAt,
        viewCount,
        description,
        locationLabel,
        interestedCount,
        status,
        category,
        plan,
        contactNumber,
        alternateNumber,
        photos,
        stoppedAt,
        rejectionReason,
        rePostedAt,
        rounds,
        stoppedAtFormatted,
        rePostedAtFormatted,
      ];
}

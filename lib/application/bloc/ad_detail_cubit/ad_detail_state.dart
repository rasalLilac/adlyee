import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';

class AdDetailState extends Equatable {
  const AdDetailState({
    required this.ad,
    this.isInterested = false,
    this.feedback = InterestFeedback.suitable,
    this.isFavorite = false,
  });

  final AdDetail ad;
  final bool isInterested;
  final InterestFeedback? feedback;
  final bool isFavorite;

  AdDetailState copyWith({
    AdDetail? ad,
    bool? isInterested,
    InterestFeedback? feedback,
    bool? isFavorite,
  }) {
    return AdDetailState(
      ad: ad ?? this.ad,
      isInterested: isInterested ?? this.isInterested,
      feedback: feedback ?? this.feedback,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [ad, isInterested, feedback, isFavorite];
}


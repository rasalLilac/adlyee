import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';

class MyAdDetailState extends Equatable {
  const MyAdDetailState({
    required this.ad,
    this.interestedUsers = const [],
    this.isStopping = false,
    this.isStopped = false,
  });

  final Submission ad;
  final List<InterestedUser> interestedUsers;
  final bool isStopping;
  final bool isStopped;

  MyAdDetailState copyWith({
    Submission? ad,
    List<InterestedUser>? interestedUsers,
    bool? isStopping,
    bool? isStopped,
  }) {
    return MyAdDetailState(
      ad: ad ?? this.ad,
      interestedUsers: interestedUsers ?? this.interestedUsers,
      isStopping: isStopping ?? this.isStopping,
      isStopped: isStopped ?? this.isStopped,
    );
  }

  @override
  List<Object?> get props => [ad, interestedUsers, isStopping, isStopped];
}


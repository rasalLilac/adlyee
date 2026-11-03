import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user.dart';

class InterestRound extends Equatable {
  const InterestRound({
    required this.number,
    required this.contacts,
  });

  final int number; // 1-based (1, 2, 3...)
  final List<InterestedUser> contacts;

  String get ordinalLabel {
    switch (number) {
      case 1:
        return 'First';
      case 2:
        return 'Second';
      case 3:
        return 'Third';
      case 4:
        return 'Fourth';
      case 5:
        return 'Fifth';
      default:
        return '$number-th';
    }
  }

  @override
  List<Object?> get props => [number, contacts];
}


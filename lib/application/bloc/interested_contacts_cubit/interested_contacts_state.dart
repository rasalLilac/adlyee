import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user.dart';

class InterestedContactsState extends Equatable {
  const InterestedContactsState({
    required this.contacts,
    this.query = '',
    required this.filtered,
  });

  final List<InterestedUser> contacts;
  final String query;
  final List<InterestedUser> filtered;

  InterestedContactsState copyWith({
    List<InterestedUser>? contacts,
    String? query,
    List<InterestedUser>? filtered,
  }) {
    return InterestedContactsState(
      contacts: contacts ?? this.contacts,
      query: query ?? this.query,
      filtered: filtered ?? this.filtered,
    );
  }

  @override
  List<Object?> get props => [contacts, query, filtered];
}


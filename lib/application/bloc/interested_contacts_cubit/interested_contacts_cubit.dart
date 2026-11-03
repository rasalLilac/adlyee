import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/interested_contacts_cubit/interested_contacts_state.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user_mock.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/owner_mark.dart';

class InterestedContactsCubit extends Cubit<InterestedContactsState> {
  InterestedContactsCubit({List<InterestedUser>? initialContacts})
      : super(
          InterestedContactsState(
            contacts: initialContacts ?? InterestedContactsStore.instance.contacts,
            query: '',
            filtered: initialContacts ?? InterestedContactsStore.instance.contacts,
          ),
        );

  // TODO(api): Replace with backend API search & filter
  void updateQuery(String query) {
    final clean = query.trim().toLowerCase();
    final contacts = state.contacts;
    if (clean.isEmpty) {
      emit(state.copyWith(query: query, filtered: contacts));
      return;
    }

    final filtered = contacts.where((u) {
      final nameMatches = u.name.toLowerCase().contains(clean);
      final phoneMatches = u.phone.replaceAll(RegExp(r'[^0-9]'), '').contains(clean);
      return nameMatches || phoneMatches;
    }).toList();

    emit(state.copyWith(query: query, filtered: filtered));
  }

  // TODO(api): Sync mark with backend API
  void setMark(String userId, OwnerMark? mark) {
    InterestedContactsStore.instance.setMark(userId, mark);

    final updatedContacts = state.contacts.map((u) {
      if (u.id == userId) {
        return u.copyWith(mark: () => mark);
      }
      return u;
    }).toList();

    final clean = state.query.trim().toLowerCase();
    final filtered = clean.isEmpty
        ? updatedContacts
        : updatedContacts.where((u) {
            final nameMatches = u.name.toLowerCase().contains(clean);
            final phoneMatches = u.phone.replaceAll(RegExp(r'[^0-9]'), '').contains(clean);
            return nameMatches || phoneMatches;
          }).toList();

    emit(state.copyWith(contacts: updatedContacts, filtered: filtered));
  }

  void refreshFromStore() {
    final contacts = InterestedContactsStore.instance.contacts;
    final clean = state.query.trim().toLowerCase();
    final filtered = clean.isEmpty
        ? contacts
        : contacts.where((u) {
            final nameMatches = u.name.toLowerCase().contains(clean);
            final phoneMatches = u.phone.replaceAll(RegExp(r'[^0-9]'), '').contains(clean);
            return nameMatches || phoneMatches;
          }).toList();

    emit(state.copyWith(contacts: contacts, filtered: filtered));
  }
}


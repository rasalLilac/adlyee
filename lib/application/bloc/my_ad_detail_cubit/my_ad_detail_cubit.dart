import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:solofy_vendor_app/application/bloc/my_ad_detail_cubit/my_ad_detail_state.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interest_round.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user_mock.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/owner_mark.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_mock_data.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';

class MyAdDetailCubit extends Cubit<MyAdDetailState> {
  MyAdDetailCubit({
    required Submission ad,
    List<InterestedUser>? initialUsers,
  }) : super(
          MyAdDetailState(
            ad: ad,
            interestedUsers: initialUsers ?? _resolveUsers(ad),
          ),
        );

  static List<InterestedUser> _resolveUsers(Submission ad) {
    if ((ad.status == SubmissionStatus.active ||
            ad.status == SubmissionStatus.expiringSoon ||
            ad.status == SubmissionStatus.expired) &&
        ad.interestedCount > 0) {
      return List<InterestedUser>.of(InterestedContactsStore.instance.contacts);
    }
    return const [];
  }

  void setMark(String userId, OwnerMark? mark) {
    InterestedContactsStore.instance.setMark(userId, mark);

    final updatedUsers = state.interestedUsers.map((u) {
      if (u.id == userId) {
        return u.copyWith(mark: () => mark);
      }
      return u;
    }).toList();

    final updatedRounds = state.ad.rounds.map((round) {
      final updatedRoundContacts = round.contacts.map((u) {
        if (u.id == userId) {
          return u.copyWith(mark: () => mark);
        }
        return u;
      }).toList();
      return InterestRound(number: round.number, contacts: updatedRoundContacts);
    }).toList();

    emit(state.copyWith(
      interestedUsers: updatedUsers,
      ad: state.ad.copyWith(rounds: updatedRounds),
    ));
  }

  void refreshContacts() {
    final contacts = InterestedContactsStore.instance.contacts;
    final updatedRounds = state.ad.rounds.map((round) {
      final updatedRoundContacts = round.contacts.map((u) {
        final found = contacts.firstWhere(
          (c) => c.id == u.id,
          orElse: () => u,
        );
        return found;
      }).toList();
      return InterestRound(number: round.number, contacts: updatedRoundContacts);
    }).toList();

    emit(state.copyWith(
      interestedUsers: List<InterestedUser>.of(contacts),
      ad: state.ad.copyWith(rounds: updatedRounds),
    ));
  }

  Future<void> stopAd() async {
    emit(state.copyWith(isStopping: true));
    // TODO(api): Call API to stop ad
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final formatted = DateFormat('dd MMM yyyy | hh:mm a').format(now);
    final updatedAd = state.ad.copyWith(
      status: SubmissionStatus.stopped,
      stoppedAt: now,
      stoppedAtFormatted: formatted,
    );
    emit(state.copyWith(
      ad: updatedAd,
      isStopping: false,
      isStopped: true,
    ));
  }

  Future<void> deleteAd() async {
    // TODO(api): Call API to delete ad
    SubmissionStore.instance.deleteSubmission(state.ad.id);
  }
}

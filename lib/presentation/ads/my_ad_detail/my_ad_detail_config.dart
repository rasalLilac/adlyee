import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';

enum MyAdDetailActionType {
  stopAd,
  editOrUpdateAndStop,
  modifyAndRePost,
  reRunAd,
  deleteAndModify,
  none,
}

/// Central configuration encapsulating ALL status-dependent rules for MyAdDetail.
class MyAdDetailConfig {
  const MyAdDetailConfig({
    required this.headerTitle,
    required this.statusChip,
    required this.showRePostedRow,
    this.rePostedText,
    required this.phoneLabel,
    required this.showStoppedAtRow,
    this.stoppedAtText,
    required this.showRejectionReason,
    this.rejectionReasonText,
    required this.showInterestedSection,
    required this.showPostingRounds,
    required this.showRunAdDaysDropdown,
    required this.actionType,
    this.overrideViewsCount,
  });

  final String headerTitle;
  final SubmissionStatus statusChip;
  final bool showRePostedRow;
  final String? rePostedText;
  final String phoneLabel;
  final bool showStoppedAtRow;
  final String? stoppedAtText;
  final bool showRejectionReason;
  final String? rejectionReasonText;
  final bool showInterestedSection;
  final bool showPostingRounds;
  final bool showRunAdDaysDropdown;
  final MyAdDetailActionType actionType;
  final int? overrideViewsCount;

  factory MyAdDetailConfig.fromAd(Submission ad) {
    final status = ad.status;
    final isRePosted = ad.rePostedAt != null &&
        (status == SubmissionStatus.active ||
            status == SubmissionStatus.expiringSoon);

    if (isRePosted) {
      return MyAdDetailConfig(
        headerTitle: StringFile.rePostTheAd,
        statusChip: status,
        showRePostedRow: true,
        rePostedText: ad.rePostedAtFormatted ?? '30 Jul 2025 | 04:00 PM',
        phoneLabel: StringFile.regPhonePrefix,
        showStoppedAtRow: false,
        showRejectionReason: false,
        showInterestedSection: true,
        showPostingRounds: true,
        showRunAdDaysDropdown: true,
        actionType: MyAdDetailActionType.editOrUpdateAndStop,
      );
    }

    switch (status) {
      case SubmissionStatus.pendingApproval:
        return const MyAdDetailConfig(
          headerTitle: StringFile.viewDetails,
          statusChip: SubmissionStatus.pendingApproval,
          showRePostedRow: false,
          phoneLabel: StringFile.contactNumberPrefix,
          showStoppedAtRow: false,
          showRejectionReason: false,
          showInterestedSection: false,
          showPostingRounds: false,
          showRunAdDaysDropdown: false,
          actionType: MyAdDetailActionType.stopAd,
        );

      case SubmissionStatus.active:
      case SubmissionStatus.expiringSoon:
        return MyAdDetailConfig(
          headerTitle: StringFile.viewDetails,
          statusChip: status,
          showRePostedRow: false,
          phoneLabel: StringFile.regPhonePrefix,
          showStoppedAtRow: false,
          showRejectionReason: false,
          showInterestedSection: true,
          showPostingRounds: false,
          showRunAdDaysDropdown: false,
          actionType: MyAdDetailActionType.editOrUpdateAndStop,
        );

      case SubmissionStatus.expired:
        return const MyAdDetailConfig(
          headerTitle: StringFile.viewDetails,
          statusChip: SubmissionStatus.expired,
          showRePostedRow: false,
          phoneLabel: StringFile.contactNumberPrefix,
          showStoppedAtRow: false,
          showRejectionReason: false,
          showInterestedSection: true,
          showPostingRounds: false,
          showRunAdDaysDropdown: false,
          actionType: MyAdDetailActionType.modifyAndRePost,
        );

      case SubmissionStatus.stopped:
        return MyAdDetailConfig(
          headerTitle: StringFile.stoppedAdDetails,
          statusChip: SubmissionStatus.stopped,
          showRePostedRow: false,
          phoneLabel: StringFile.regPhonePrefix,
          showStoppedAtRow: true,
          stoppedAtText: ad.stoppedAtFormatted ?? '26 Jul 2025 | 04:00 PM',
          showRejectionReason: false,
          showInterestedSection: false,
          showPostingRounds: false,
          showRunAdDaysDropdown: false,
          actionType: MyAdDetailActionType.reRunAd,
        );

      case SubmissionStatus.rejected:
        return MyAdDetailConfig(
          headerTitle: StringFile.rejectedAdDetails,
          statusChip: SubmissionStatus.rejected,
          showRePostedRow: false,
          phoneLabel: StringFile.regPhonePrefix,
          showStoppedAtRow: false,
          showRejectionReason: true,
          rejectionReasonText: ad.rejectionReason ??
              'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s.',
          showInterestedSection: false,
          showPostingRounds: false,
          showRunAdDaysDropdown: false,
          actionType: MyAdDetailActionType.deleteAndModify,
          overrideViewsCount: 0,
        );
    }
  }
}


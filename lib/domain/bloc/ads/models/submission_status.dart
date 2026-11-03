import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';

enum SubmissionStatus {
  pendingApproval,
  active,
  expiringSoon,
  expired,
  stopped,
  rejected;

  String get label {
    switch (this) {
      case SubmissionStatus.pendingApproval:
        return StringFile.pendingApproval;
      case SubmissionStatus.active:
        return StringFile.active;
      case SubmissionStatus.expiringSoon:
        return StringFile.expiringSoon;
      case SubmissionStatus.expired:
        return StringFile.expired;
      case SubmissionStatus.stopped:
        return StringFile.stopped;
      case SubmissionStatus.rejected:
        return StringFile.rejected;
    }
  }

  Color get bgColor {
    switch (this) {
      case SubmissionStatus.pendingApproval:
        return ColorResources.statusPendingApprovalBg;
      case SubmissionStatus.active:
        return ColorResources.statusActiveBg;
      case SubmissionStatus.expiringSoon:
        return ColorResources.statusExpiringBg;
      case SubmissionStatus.expired:
        return ColorResources.statusExpiredBg;
      case SubmissionStatus.stopped:
        return ColorResources.statusStoppedBg;
      case SubmissionStatus.rejected:
        return ColorResources.statusRejectedBg;
    }
  }

  Color get textColor {
    switch (this) {
      case SubmissionStatus.pendingApproval:
        return ColorResources.statusPendingApprovalText;
      case SubmissionStatus.active:
        return ColorResources.statusActiveText;
      case SubmissionStatus.expiringSoon:
        return ColorResources.statusExpiringText;
      case SubmissionStatus.expired:
        return ColorResources.statusExpiredText;
      case SubmissionStatus.stopped:
        return ColorResources.statusStoppedText;
      case SubmissionStatus.rejected:
        return ColorResources.statusRejectedText;
    }
  }

  AdStatus toAdStatus() {
    switch (this) {
      case SubmissionStatus.pendingApproval:
      case SubmissionStatus.active:
        return AdStatus.active;
      case SubmissionStatus.expiringSoon:
        return AdStatus.expiringSoon;
      case SubmissionStatus.expired:
      case SubmissionStatus.rejected:
        return AdStatus.expired;
      case SubmissionStatus.stopped:
        return AdStatus.stopped;
    }
  }

  static SubmissionStatus fromAdStatus(AdStatus adStatus) {
    switch (adStatus) {
      case AdStatus.active:
        return SubmissionStatus.active;
      case AdStatus.expiringSoon:
        return SubmissionStatus.expiringSoon;
      case AdStatus.expired:
        return SubmissionStatus.expired;
      case AdStatus.stopped:
        return SubmissionStatus.stopped;
    }
  }
}

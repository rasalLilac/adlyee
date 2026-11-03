import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/application/core/utils/constants.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';

enum AdPlan { regular, featured, urgent }

enum ReportReason {
  spam,
  falseInfo,
  offensive,
  wrongCategory,
  other,
}

extension ReportReasonX on ReportReason {
  String get label {
    switch (this) {
      case ReportReason.spam:
        return "It's spam or scam";
      case ReportReason.falseInfo:
        return 'False information / misleading content';
      case ReportReason.offensive:
        return 'Offensive or inappropriate content';
      case ReportReason.wrongCategory:
        return 'Wrong category / irrelevant content';
      case ReportReason.other:
        return 'Other';
    }
  }
}

class AdDraft extends Equatable {
  const AdDraft({
    this.adRef = '0123456789',
    this.category = '',
    this.subCategory = '',
    this.localityOrPincode = '',
    this.plan = AdPlan.regular,
    this.displayDescription = '',
    this.description = '',
    this.showRegisteredNumber = true,
    this.alternatePhone = '',
    this.connectUsingWhatsApp = true,
    this.getInterestedContactDetails = true,
    this.images = const [],
    this.runDays = 10,
    this.currentDays = 4,
    this.additionalDays = 0,
    this.agreeTerms = false,
  });

  final String adRef;
  final String category;
  final String subCategory;
  final String localityOrPincode;
  final AdPlan plan;
  final String displayDescription;
  final String description;
  final bool showRegisteredNumber;
  final String alternatePhone;
  final bool connectUsingWhatsApp;
  final bool getInterestedContactDetails;
  final List<String> images;
  final int runDays;
  final int currentDays;
  final int additionalDays;
  final bool agreeTerms;

  factory AdDraft.fromSubmission(Submission submission) {
    AdPlan plan;
    switch (submission.plan.toLowerCase()) {
      case 'featured':
        plan = AdPlan.featured;
        break;
      case 'urgent':
        plan = AdPlan.urgent;
        break;
      default:
        plan = AdPlan.regular;
    }

    final phoneDigits = submission.contactNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final alternatePhone = phoneDigits.length >= 10
        ? phoneDigits.substring(phoneDigits.length - 10)
        : phoneDigits;

    return AdDraft(
      adRef: submission.adRef,
      category: submission.category.isNotEmpty ? submission.category : 'Property',
      subCategory: 'Rent',
      localityOrPincode: submission.locationLabel,
      plan: plan,
      displayDescription: submission.title,
      description: submission.description,
      showRegisteredNumber: true,
      alternatePhone: alternatePhone,
      connectUsingWhatsApp: true,
      getInterestedContactDetails: true,
      images: submission.photos.isNotEmpty
          ? submission.photos
          : const ['assets/images/pngs/house.png'],
      runDays: 4,
      currentDays: 4,
      additionalDays: 0,
      agreeTerms: false,
    );
  }

  int get price => runDays * AppConstants.pricePerDay;

  // TODO(design): Price calculation rule for additional days in edit mode
  int get additionalPrice => additionalDays * AppConstants.pricePerDay;

  AdDraft copyWith({
    String? adRef,
    String? category,
    String? subCategory,
    String? localityOrPincode,
    AdPlan? plan,
    String? displayDescription,
    String? description,
    bool? showRegisteredNumber,
    String? alternatePhone,
    bool? connectUsingWhatsApp,
    bool? getInterestedContactDetails,
    List<String>? images,
    int? runDays,
    int? currentDays,
    int? additionalDays,
    bool? agreeTerms,
  }) {
    return AdDraft(
      adRef: adRef ?? this.adRef,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      localityOrPincode: localityOrPincode ?? this.localityOrPincode,
      plan: plan ?? this.plan,
      displayDescription: displayDescription ?? this.displayDescription,
      description: description ?? this.description,
      showRegisteredNumber: showRegisteredNumber ?? this.showRegisteredNumber,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      connectUsingWhatsApp: connectUsingWhatsApp ?? this.connectUsingWhatsApp,
      getInterestedContactDetails:
          getInterestedContactDetails ?? this.getInterestedContactDetails,
      images: images ?? this.images,
      runDays: runDays ?? this.runDays,
      currentDays: currentDays ?? this.currentDays,
      additionalDays: additionalDays ?? this.additionalDays,
      agreeTerms: agreeTerms ?? this.agreeTerms,
    );
  }

  @override
  List<Object?> get props => [
        adRef,
        category,
        subCategory,
        localityOrPincode,
        plan,
        displayDescription,
        description,
        showRegisteredNumber,
        alternatePhone,
        connectUsingWhatsApp,
        getInterestedContactDetails,
        images,
        runDays,
        currentDays,
        additionalDays,
        agreeTerms,
      ];
}


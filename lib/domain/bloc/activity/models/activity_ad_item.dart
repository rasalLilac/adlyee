import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_detail.dart';

enum ActivityTab { favourites, interests, viewed }

extension ActivityTabX on ActivityTab {
  String get label {
    switch (this) {
      case ActivityTab.favourites:
        return StringFile.favourites;
      case ActivityTab.interests:
        return StringFile.interests;
      case ActivityTab.viewed:
        return StringFile.viewed;
    }
  }
}

class ActivityAdItem extends Equatable {
  const ActivityAdItem({
    required this.id,
    required this.adRef,
    required this.title,
    required this.date,
    required this.views,
    required this.description,
    required this.location,
    required this.status,
    this.category = 'Property',
    this.feedback,
  });

  final String id;
  final String adRef;
  final String title;
  final String date;
  final int views;
  final String description;
  final String location;
  final AdStatus status;
  final String category;
  final InterestFeedback? feedback;

  Color get dotColor {
    switch (status) {
      case AdStatus.active:
        return ColorResources.green;
      case AdStatus.expiringSoon:
        return ColorResources.orange;
      case AdStatus.expired:
      case AdStatus.stopped:
        return ColorResources.red;
    }
  }

  ActivityAdItem copyWith({
    String? id,
    String? adRef,
    String? title,
    String? date,
    int? views,
    String? description,
    String? location,
    AdStatus? status,
    String? category,
    InterestFeedback? feedback,
  }) {
    return ActivityAdItem(
      id: id ?? this.id,
      adRef: adRef ?? this.adRef,
      title: title ?? this.title,
      date: date ?? this.date,
      views: views ?? this.views,
      description: description ?? this.description,
      location: location ?? this.location,
      status: status ?? this.status,
      category: category ?? this.category,
      feedback: feedback ?? this.feedback,
    );
  }

  @override
  List<Object?> get props => [
        id,
        adRef,
        title,
        date,
        views,
        description,
        location,
        status,
        category,
        feedback,
      ];
}

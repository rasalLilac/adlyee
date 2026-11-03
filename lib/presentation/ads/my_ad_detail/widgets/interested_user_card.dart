import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/owner_mark.dart';
import 'package:solofy_vendor_app/presentation/widgets/interested_contact_row.dart';

/// Backward-compatibility wrapper for [InterestedContactRow].
class InterestedUserCard extends StatelessWidget {
  const InterestedUserCard({
    super.key,
    required this.user,
    this.onActionSelected,
    this.onMarkChanged,
  });

  final InterestedUser user;
  final ValueChanged<String>? onActionSelected;
  final ValueChanged<OwnerMark?>? onMarkChanged;

  @override
  Widget build(BuildContext context) {
    return InterestedContactRow(
      user: user,
      onMarkChanged: onMarkChanged,
    );
  }
}

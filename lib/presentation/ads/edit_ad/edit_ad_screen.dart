import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/post_ad_cubit/post_ad_cubit.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/presentation/ads/widgets/ad_form.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';

class EditAdScreen extends StatelessWidget {
  const EditAdScreen({
    super.key,
    required this.ad,
  });

  final Submission ad;

  static const routeName = 'edit-ad';

  @override
  Widget build(BuildContext context) {
    final initialDraft = AdDraft.fromSubmission(ad);

    return BlocProvider(
      create: (_) => PostAdCubit(initialDraft: initialDraft),
      child: const AppPageScaffold(
        scrollable: false,
        child: AdForm(mode: AdFormMode.edit),
      ),
    );
  }
}

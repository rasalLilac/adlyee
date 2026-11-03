import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/post_ad_cubit/post_ad_cubit.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/ad_draft.dart';
import 'package:solofy_vendor_app/presentation/ads/post_ad/ad_preview_screen.dart';
import 'package:solofy_vendor_app/presentation/ads/widgets/ad_form.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';

class PostAdScreen extends StatelessWidget {
  const PostAdScreen({super.key, this.initialDraft});

  final AdDraft? initialDraft;

  static const routeName = 'post-ad';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostAdCubit(initialDraft: initialDraft),
      child: const _PostAdView(),
    );
  }
}

class _PostAdView extends StatelessWidget {
  const _PostAdView();

  void _onPreview(BuildContext context) {
    final draft = context.read<PostAdCubit>().state.draft;
    AppRoute.pushNamed(
      AdPreviewScreen.routeName,
      arguments: draft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      scrollable: false,
      child: AdForm(
        mode: AdFormMode.create,
        onPreview: () => _onPreview(context),
      ),
    );
  }
}

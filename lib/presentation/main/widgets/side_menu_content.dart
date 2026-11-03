import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/bloc/main_shell_cubit/main_shell_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/profile_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/user_profile.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/app_assets.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/side_menu_item.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/side_menu_scope.dart';
import 'package:solofy_vendor_app/presentation/splash/auth/mobile_login_screen.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_confirm_dialog.dart';
import 'package:solofy_vendor_app/presentation/widgets/pattern_background.dart';

class SideMenuContent extends StatelessWidget {
  const SideMenuContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return PatternBackground(
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: SizedBox(
            width: screenWidth * 0.70,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.s, 20.s, 16.s, 24.s),
              child: BlocBuilder<ProfileCubit, UserProfile>(
                builder: (context, profile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Header: Avatar 40 + Name + User ID
                    GestureDetector(
                      onTap: () {
                        SideMenuScope.of(context).close();
                        AppRoute.pushNamed('edit-profile');
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Container(
                            width: 44.s,
                            height: 44.s,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorResources.white.withValues(alpha: 0.2),
                              border: Border.all(
                                color: ColorResources.white.withValues(alpha: 0.8),
                                width: 1.5.s,
                              ),
                            ),
                            child: ClipOval(
                              child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                                  ? Image.network(
                                      profile.avatarUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _buildAvatarFallback(),
                                    )
                                  : _buildAvatarFallback(),
                            ),
                          ),
                          Gap(12.s),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.s,
                                    fontWeight: FontWeight.w500,
                                    color: ColorResources.white,
                                    height: 1.2,
                                  ),
                                ),
                                Gap(3.s),
                                Text(
                                  '${StringFile.userIdPrefix}${profile.userId}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.s,
                                    fontWeight: FontWeight.w400,
                                    color: ColorResources.white.withValues(alpha: 0.8),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(32.s),

                    // Navigation Items
                    SideMenuItem(
                      icon: SvgPicture.asset(
                        AppAssets.frameSvg,
                        width: 20.s,
                        height: 20.s,
                        colorFilter: const ColorFilter.mode(
                          ColorResources.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: StringFile.profile,
                      onTap: () {
                        SideMenuScope.of(context).close();
                        AppRoute.pushNamed('edit-profile');
                      },
                    ),
                    Gap(8.s),
                    SideMenuItem(
                      icon: SvgPicture.asset(
                        AppAssets.favouritesSvg,
                        width: 20.s,
                        height: 20.s,
                        colorFilter: const ColorFilter.mode(
                          ColorResources.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: StringFile.favourites,
                      onTap: () {
                        SideMenuScope.of(context).close();
                        context.read<MainShellCubit>().selectTab(1);
                      },
                    ),
                    Gap(8.s),
                    SideMenuItem(
                      icon: SvgPicture.asset(
                        AppAssets.playCircleSvg,
                        width: 20.s,
                        height: 20.s,
                        colorFilter: const ColorFilter.mode(
                          ColorResources.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: StringFile.submissions,
                      onTap: () {
                        SideMenuScope.of(context).close();
                        context.read<MainShellCubit>().selectTab(2);
                      },
                    ),

                    const Spacer(),

                    // Bottom items: Log Out & Contact Us
                    SideMenuItem(
                      icon: SvgPicture.asset(
                        AppAssets.logoutSvg,
                        width: 20.s,
                        height: 20.s,
                        colorFilter: const ColorFilter.mode(
                          ColorResources.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: StringFile.logOut,
                      onTap: () {
                        AppConfirmDialog.show(
                          context,
                          title: StringFile.areYouLoggingOut,
                          message: StringFile.areYouSureDoYouWantToLogout,
                          cancelLabel: StringFile.cancel,
                          confirmLabel: StringFile.logout,
                          isDestructive: true,
                          onConfirm: () {
                            SideMenuScope.of(context).close();
                            AppRoute.pushNamedAndRemoveUntil(
                              MobileLoginScreen.routeName,
                              predicate: (_) => false,
                            );
                          },
                        );
                      },
                    ),
                    Gap(8.s),
                    SideMenuItem(
                      icon: SvgPicture.asset(
                        AppAssets.profileCallSvg,
                        width: 20.s,
                        height: 20.s,
                        colorFilter: const ColorFilter.mode(
                          ColorResources.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: StringFile.contactUs,
                      onTap: () {
                        SideMenuScope.of(context).close();
                        AppRoute.pushNamed('contact-us');
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildAvatarFallback() {
    return Container(
      color: ColorResources.lightBlue,
      child: Center(
        child: Icon(
          Icons.person,
          color: ColorResources.primary,
          size: 26.s,
        ),
      ),
    );
  }
}


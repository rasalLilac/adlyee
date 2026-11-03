// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tixongo_user_app/application/core/theme/colors.dart';
// import 'package:tixongo_user_app/application/core/theme/text_styles.dart';
// import 'package:tixongo_user_app/presentation/widgets/primary_button.dart';
// import 'package:url_launcher/url_launcher.dart';

// /// Full-screen non-dismissable force update overlay designed as a popup.
// class ForceUpdateScreen extends StatelessWidget {
//   const ForceUpdateScreen({
//     super.key,
//     this.storeUrl,
//     this.currentVersion,
//     this.minimumVersion,
//   });

//   final String? storeUrl;
//   final String? currentVersion;
//   final String? minimumVersion;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black54, // Semi-transparent dark background
//       body: Center(
//         child: Container(
//           width: 320.w,
//           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
//           decoration: BoxDecoration(
//             color: context.colors.white,
//             borderRadius: BorderRadius.circular(24.r),
//             boxShadow: [
//               BoxShadow(
//                 color: context.colors.primaryShadow.withValues(alpha: 0.2),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Premium Icon Container
//               Container(
//                 width: 80.w,
//                 height: 80.w,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: context.colors.primaryGradient,
//                   boxShadow: [
//                     BoxShadow(
//                       color: context.colors.primaryShadow.withValues(
//                         alpha: 0.4,
//                       ),
//                       blurRadius: 15,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Icon(
//                     Icons.rocket_launch_rounded,
//                     size: 38.w,
//                     color: context.colors.white,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24.h),

//               // Title
//               Text(
//                 'Update Required',
//                 style: baseTextStyle.s20.w700.black,
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 12.h),

//               // Subtitle
//               Text(
//                 'A newer, faster, and better version of the app is available. Please update to continue using the app.',
//                 style: baseTextStyle.s14.w400.slateGray.copyWith(height: 1.5),
//                 textAlign: TextAlign.center,
//               ),

//               // Version Info
//               if (currentVersion != null && minimumVersion != null) ...[
//                 SizedBox(height: 20.h),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 8.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: context.colors.lightBlue,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Text(
//                     'Current: $currentVersion   •   Required: $minimumVersion',
//                     style: baseTextStyle.s12.w600.copyWith(
//                       color: context.colors.primary,
//                     ),
//                   ),
//                 ),
//               ],

//               SizedBox(height: 32.h),

//               // Update Button
//               PrimaryButton(
//                 title: 'Update Now',
//                 onPressed: () {
//                   if (storeUrl != null) {
//                     _launchStore(storeUrl!);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _launchStore(String url) async {
//     final uri = Uri.tryParse(url);
//     if (uri != null && await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
// }

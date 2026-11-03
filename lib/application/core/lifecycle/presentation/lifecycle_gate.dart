// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../application/lifecycle_bloc.dart';
// import '../application/lifecycle_state.dart';
// import 'force_update_screen.dart';

// /// Wraps the app content and gates it behind lifecycle checks.
// ///
// /// Shows [ForceUpdateScreen] when a force update is required,
// /// otherwise passes through to [child].
// class LifecycleGate extends StatelessWidget {
//   const LifecycleGate({
//     super.key,
//     required this.child,
//     required this.currentVersion,
//   });

//   final Widget child;

//   /// The current app version to display in the force update screen
//   final String currentVersion;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LifecycleBloc, LifecycleState>(
//       builder: (context, state) {
//         return Stack(
//           children: [
//             // Always render the app behind the gate
//             child,

//             // Overlay the force update screen if required
//             if (state is LifecycleForceUpdate)
//               Positioned.fill(
//                 child: ForceUpdateScreen(
//                   storeUrl: state.config.storeUrl,
//                   currentVersion: currentVersion,
//                   minimumVersion: state.config.minimumVersion,
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

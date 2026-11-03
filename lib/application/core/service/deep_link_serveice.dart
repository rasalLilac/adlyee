// import 'dart:async';

// import 'package:app_links/app_links.dart';
// import 'package:gsl_student_app/application/core/utils/logger.dart';
// import 'package:injectable/injectable.dart';

// class DeeplinkServeice {
//   DeeplinkServeice._();
//   factory DeeplinkServeice() => DeeplinkServeice._();
//   final _appLinks = AppLinks(); // AppLinks is singleton
//   StreamController<Uri>? appLinkController;
//   StreamSubscription<Uri>? _controller;
// // Subscribe to all events (initial link and further)

//   void init() {
//     Logger.logSuccess('DeeplinkServeice initalized');
//     appLinkController = StreamController<Uri>.broadcast();
//     _controller = _appLinks.uriLinkStream.listen(
//       (uri) {
//         // Logger.logSuccess('Uri Data: $uri');
//         appLinkController!.add(uri);
//       },
//     );
//   }

//   @disposeMethod
//   void dispose() {
//     _controller?.cancel();
//     appLinkController?.close();
//   }
// }

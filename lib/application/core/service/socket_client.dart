// import 'dart:async';

// import 'package:dartz/dartz.dart';
// import 'package:gsl_student_app/application/core/utils/typedefs.dart';
// import 'package:injectable/injectable.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// @lazySingleton
// class SocketClient {
//   SocketClient();
//   late StreamController<Result<String>> chatController;

//   late IO.Socket socket;

//   void initSocket() {
//     chatController = StreamController.broadcast();
//     socket =
//         IO.io('https://test.gsladmin.lilacinfotech.com/', <String, dynamic>{
//       'autoConnect': false,
//       'transports': ['websocket'],
//     });
//     if (!socket.connected) {
//       socket.connect();
//       _getMsg();
//     }
//   }

//   void _getMsg() {
//     socket.on(
//       'message',
//       (data) => chatController.add(
//         right('New Meassage Reseved $data'),
//       ),
//     );
//   }

//   void disconnect() {
//     socket.disconnect();
//   }

//   void getInitalChats() {
//     chatController.add(
//       right('Calling Intial Chats'),
//     );
//   }
// }

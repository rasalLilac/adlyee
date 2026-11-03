// import 'package:beauting/application/core/serveice/dio_client.dart';
// import 'package:beauting/application/core/utils/typedefs.dart';
// import 'package:beauting/application/core/utils/urls.dart';
// import 'package:beauting/domain/auth/i_auth_facade.dart';
// import 'package:beauting/domain/auth/models/auth_response.dart';
// import 'package:beauting/domain/core/exception/custom_exception.dart';
// import 'package:beauting/domain/core/failures/failures.dart';
// import 'package:dartz/dartz.dart';
// import 'package:injectable/injectable.dart';

// @LazySingleton(as: IAuthFacade)
// class AuthFacadeImpl implements IAuthFacade {
//   final DioClient _dioClient;

//   AuthFacadeImpl(this._dioClient);

//   @override
//   ResultFuture<AuthResponse> sendOtp({required String phone}) async {
//     try {
//       final response = await _dioClient.post(
//         Urls.sendOtp,
//         data: {'phone': phone},
//       );
      
//       final data = AuthResponse.fromJson(response.data);
//       if (data.success == true) {
//         return Right(data);
//       } else {
//         return Left(MainFailure.customError(errorMsg: data.message ?? 'Unknown error'));
//       }
//     } on CustomException catch (e) {
//       return Left(MainFailure.customError(errorMsg: e.errMsg));
//     } catch (e) {
//       return Left(MainFailure.customError(errorMsg: e.toString()));
//     }
//   }

//   @override
//   ResultFuture<AuthResponse> verifyOtp({
//     required String phone,
//     required String otp,
//   }) async {
//     try {
//       final response = await _dioClient.post(
//         Urls.verifyOtp,
//         data: {'phone': phone, 'otp': otp},
//       );
      
//       final data = AuthResponse.fromJson(response.data);
//       if (data.success == true) {
//         return Right(data);
//       } else {
//         return Left(MainFailure.customError(errorMsg: data.message ?? 'Unknown error'));
//       }
//     } on CustomException catch (e) {
//       return Left(MainFailure.customError(errorMsg: e.errMsg));
//     } catch (e) {
//       return Left(MainFailure.customError(errorMsg: e.toString()));
//     }
//   }

//   @override
//   ResultFuture<AuthResponse> signup({
//     required String fullName,
//     required String email,
//     required String phone,
//     String? referralId,
//   }) async {
//     try {
//       final body = {
//         'full_name': fullName,
//         'email': email,
//         'phone': phone,
//       };
//       if (referralId != null && referralId.isNotEmpty) {
//         body['referral_id'] = referralId;
//       }

//       final response = await _dioClient.post(
//         Urls.signup,
//         data: body,
//       );

//       final data = AuthResponse.fromJson(response.data);
//       if (data.success == true) {
//         return Right(data);
//       } else {
//         return Left(MainFailure.customError(errorMsg: data.message ?? 'Unknown error'));
//       }
//     } on CustomException catch (e) {
//       return Left(MainFailure.customError(errorMsg: e.errMsg));
//     } catch (e) {
//       return Left(MainFailure.customError(errorMsg: e.toString()));
//     }
//   }
// }

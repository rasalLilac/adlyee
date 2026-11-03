// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:injectable/injectable.dart';
// import 'package:beauting/application/core/utils/api_status.dart';
// import 'package:beauting/domain/auth/i_auth_facade.dart';
// import 'package:beauting/domain/auth/models/auth_response.dart';

// part 'auth_event.dart';
// part 'auth_state.dart';
// part 'auth_bloc.freezed.dart';

// @injectable
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final IAuthFacade _authFacade;

//   AuthBloc(this._authFacade) : super(const AuthState()) {
//     on<_SendOTPEvent>(_onSendOTP);
//     on<_VerifyOTPEvent>(_onVerifyOTP);
//     on<_SignupEvent>(_onSignup);
//     on<_ResetAuthStatusEvent>(_onResetAuthStatus);
//   }

//   Future<void> _onSignup(_SignupEvent event, Emitter<AuthState> emit) async {
//     emit(state.copyWith(
//       signupStatus: ApiStatus.loading,
//       errorMessage: null,
//       successMessage: null,
//     ));
//     final response = await _authFacade.signup(
//       fullName: event.fullName,
//       email: event.email,
//       phone: event.phone,
//       referralId: event.referralId,
//     );
//     response.fold(
//       (failure) {
//         emit(state.copyWith(
//           signupStatus: ApiStatus.error,
//           errorMessage: failure.errorMsg,
//         ));
//       },
//       (success) {
//         emit(state.copyWith(
//           signupStatus: ApiStatus.success,
//           authResponse: success,
//           successMessage: success.message,
//         ));
//       },
//     );
//   }

//   Future<void> _onSendOTP(_SendOTPEvent event, Emitter<AuthState> emit) async {
//     emit(state.copyWith(
//       otpSendStatus: ApiStatus.loading,
//       errorMessage: null,
//       successMessage: null,
//     ));
//     final response = await _authFacade.sendOtp(phone: event.phone);
//     response.fold(
//       (failure) {
//         emit(state.copyWith(
//           otpSendStatus: ApiStatus.error,
//           errorMessage: failure.errorMsg,
//         ));
//       },
//       (success) {
//         emit(state.copyWith(
//           otpSendStatus: ApiStatus.success,
//           authResponse: success,
//           successMessage: success.message,
//         ));
//       },
//     );
//   }

//   Future<void> _onVerifyOTP(_VerifyOTPEvent event, Emitter<AuthState> emit) async {
//     emit(state.copyWith(
//       otpVerifyStatus: ApiStatus.loading,
//       errorMessage: null,
//       successMessage: null,
//     ));
//     final response = await _authFacade.verifyOtp(phone: event.phone, otp: event.otp);
//     response.fold(
//       (failure) {
//         emit(state.copyWith(
//           otpVerifyStatus: ApiStatus.error,
//           errorMessage: failure.errorMsg,
//         ));
//       },
//       (success) {
//         emit(state.copyWith(
//           otpVerifyStatus: ApiStatus.success,
//           authResponse: success,
//           successMessage: success.message,
//         ));
//       },
//     );
//   }

//   void _onResetAuthStatus(_ResetAuthStatusEvent event, Emitter<AuthState> emit) {
//     emit(state.copyWith(
//       otpSendStatus: ApiStatus.initial,
//       otpVerifyStatus: ApiStatus.initial,
//     ));
//   }
// }

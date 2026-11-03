// // coverage:ignore-file
// // GENERATED CODE - DO NOT MODIFY BY HAND
// // ignore_for_file: type=lint
// // ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

// part of 'auth_bloc.dart';

// // **************************************************************************
// // FreezedGenerator
// // **************************************************************************

// T _$identity<T>(T value) => value;

// final _privateConstructorUsedError = UnsupportedError(
//     'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

// /// @nodoc
// mixin _$AuthEvent {
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(String phone) sendOTP,
//     required TResult Function(String phone, String otp) verifyOTP,
//     required TResult Function(
//             String fullName, String email, String phone, String? referralId)
//         signup,
//     required TResult Function() resetAuthStatus,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult? whenOrNull<TResult extends Object?>({
//     TResult? Function(String phone)? sendOTP,
//     TResult? Function(String phone, String otp)? verifyOTP,
//     TResult? Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult? Function()? resetAuthStatus,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(String phone)? sendOTP,
//     TResult Function(String phone, String otp)? verifyOTP,
//     TResult Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult Function()? resetAuthStatus,
//     required TResult orElse(),
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(_SendOTPEvent value) sendOTP,
//     required TResult Function(_VerifyOTPEvent value) verifyOTP,
//     required TResult Function(_SignupEvent value) signup,
//     required TResult Function(_ResetAuthStatusEvent value) resetAuthStatus,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult? mapOrNull<TResult extends Object?>({
//     TResult? Function(_SendOTPEvent value)? sendOTP,
//     TResult? Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult? Function(_SignupEvent value)? signup,
//     TResult? Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(_SendOTPEvent value)? sendOTP,
//     TResult Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult Function(_SignupEvent value)? signup,
//     TResult Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//     required TResult orElse(),
//   }) =>
//       throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class $AuthEventCopyWith<$Res> {
//   factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
//       _$AuthEventCopyWithImpl<$Res, AuthEvent>;
// }

// /// @nodoc
// class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
//     implements $AuthEventCopyWith<$Res> {
//   _$AuthEventCopyWithImpl(this._value, this._then);

//   // ignore: unused_field
//   final $Val _value;
//   // ignore: unused_field
//   final $Res Function($Val) _then;

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
// }

// /// @nodoc
// abstract class _$$SendOTPEventImplCopyWith<$Res> {
//   factory _$$SendOTPEventImplCopyWith(
//           _$SendOTPEventImpl value, $Res Function(_$SendOTPEventImpl) then) =
//       __$$SendOTPEventImplCopyWithImpl<$Res>;
//   @useResult
//   $Res call({String phone});
// }

// /// @nodoc
// class __$$SendOTPEventImplCopyWithImpl<$Res>
//     extends _$AuthEventCopyWithImpl<$Res, _$SendOTPEventImpl>
//     implements _$$SendOTPEventImplCopyWith<$Res> {
//   __$$SendOTPEventImplCopyWithImpl(
//       _$SendOTPEventImpl _value, $Res Function(_$SendOTPEventImpl) _then)
//       : super(_value, _then);

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
//   @pragma('vm:prefer-inline')
//   @override
//   $Res call({
//     Object? phone = null,
//   }) {
//     return _then(_$SendOTPEventImpl(
//       phone: null == phone
//           ? _value.phone
//           : phone // ignore: cast_nullable_to_non_nullable
//               as String,
//     ));
//   }
// }

// /// @nodoc

// class _$SendOTPEventImpl implements _SendOTPEvent {
//   const _$SendOTPEventImpl({required this.phone});

//   @override
//   final String phone;

//   @override
//   String toString() {
//     return 'AuthEvent.sendOTP(phone: $phone)';
//   }

//   @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         (other.runtimeType == runtimeType &&
//             other is _$SendOTPEventImpl &&
//             (identical(other.phone, phone) || other.phone == phone));
//   }

//   @override
//   int get hashCode => Object.hash(runtimeType, phone);

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
//   @JsonKey(includeFromJson: false, includeToJson: false)
//   @override
//   @pragma('vm:prefer-inline')
//   _$$SendOTPEventImplCopyWith<_$SendOTPEventImpl> get copyWith =>
//       __$$SendOTPEventImplCopyWithImpl<_$SendOTPEventImpl>(this, _$identity);

//   @override
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(String phone) sendOTP,
//     required TResult Function(String phone, String otp) verifyOTP,
//     required TResult Function(
//             String fullName, String email, String phone, String? referralId)
//         signup,
//     required TResult Function() resetAuthStatus,
//   }) {
//     return sendOTP(phone);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? whenOrNull<TResult extends Object?>({
//     TResult? Function(String phone)? sendOTP,
//     TResult? Function(String phone, String otp)? verifyOTP,
//     TResult? Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult? Function()? resetAuthStatus,
//   }) {
//     return sendOTP?.call(phone);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(String phone)? sendOTP,
//     TResult Function(String phone, String otp)? verifyOTP,
//     TResult Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult Function()? resetAuthStatus,
//     required TResult orElse(),
//   }) {
//     if (sendOTP != null) {
//       return sendOTP(phone);
//     }
//     return orElse();
//   }

//   @override
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(_SendOTPEvent value) sendOTP,
//     required TResult Function(_VerifyOTPEvent value) verifyOTP,
//     required TResult Function(_SignupEvent value) signup,
//     required TResult Function(_ResetAuthStatusEvent value) resetAuthStatus,
//   }) {
//     return sendOTP(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? mapOrNull<TResult extends Object?>({
//     TResult? Function(_SendOTPEvent value)? sendOTP,
//     TResult? Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult? Function(_SignupEvent value)? signup,
//     TResult? Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//   }) {
//     return sendOTP?.call(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(_SendOTPEvent value)? sendOTP,
//     TResult Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult Function(_SignupEvent value)? signup,
//     TResult Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//     required TResult orElse(),
//   }) {
//     if (sendOTP != null) {
//       return sendOTP(this);
//     }
//     return orElse();
//   }
// }

// abstract class _SendOTPEvent implements AuthEvent {
//   const factory _SendOTPEvent({required final String phone}) =
//       _$SendOTPEventImpl;

//   String get phone;

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
//   @JsonKey(includeFromJson: false, includeToJson: false)
//   _$$SendOTPEventImplCopyWith<_$SendOTPEventImpl> get copyWith =>
//       throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class _$$VerifyOTPEventImplCopyWith<$Res> {
//   factory _$$VerifyOTPEventImplCopyWith(_$VerifyOTPEventImpl value,
//           $Res Function(_$VerifyOTPEventImpl) then) =
//       __$$VerifyOTPEventImplCopyWithImpl<$Res>;
//   @useResult
//   $Res call({String phone, String otp});
// }

// /// @nodoc
// class __$$VerifyOTPEventImplCopyWithImpl<$Res>
//     extends _$AuthEventCopyWithImpl<$Res, _$VerifyOTPEventImpl>
//     implements _$$VerifyOTPEventImplCopyWith<$Res> {
//   __$$VerifyOTPEventImplCopyWithImpl(
//       _$VerifyOTPEventImpl _value, $Res Function(_$VerifyOTPEventImpl) _then)
//       : super(_value, _then);

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
//   @pragma('vm:prefer-inline')
//   @override
//   $Res call({
//     Object? phone = null,
//     Object? otp = null,
//   }) {
//     return _then(_$VerifyOTPEventImpl(
//       phone: null == phone
//           ? _value.phone
//           : phone // ignore: cast_nullable_to_non_nullable
//               as String,
//       otp: null == otp
//           ? _value.otp
//           : otp // ignore: cast_nullable_to_non_nullable
//               as String,
//     ));
//   }
// }

// /// @nodoc

// class _$VerifyOTPEventImpl implements _VerifyOTPEvent {
//   const _$VerifyOTPEventImpl({required this.phone, required this.otp});

//   @override
//   final String phone;
//   @override
//   final String otp;

//   @override
//   String toString() {
//     return 'AuthEvent.verifyOTP(phone: $phone, otp: $otp)';
//   }

//   @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         (other.runtimeType == runtimeType &&
//             other is _$VerifyOTPEventImpl &&
//             (identical(other.phone, phone) || other.phone == phone) &&
//             (identical(other.otp, otp) || other.otp == otp));
//   }

//   @override
//   int get hashCode => Object.hash(runtimeType, phone, otp);

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
//   @JsonKey(includeFromJson: false, includeToJson: false)
//   @override
//   @pragma('vm:prefer-inline')
//   _$$VerifyOTPEventImplCopyWith<_$VerifyOTPEventImpl> get copyWith =>
//       __$$VerifyOTPEventImplCopyWithImpl<_$VerifyOTPEventImpl>(
//           this, _$identity);

//   @override
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(String phone) sendOTP,
//     required TResult Function(String phone, String otp) verifyOTP,
//     required TResult Function(
//             String fullName, String email, String phone, String? referralId)
//         signup,
//     required TResult Function() resetAuthStatus,
//   }) {
//     return verifyOTP(phone, otp);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? whenOrNull<TResult extends Object?>({
//     TResult? Function(String phone)? sendOTP,
//     TResult? Function(String phone, String otp)? verifyOTP,
//     TResult? Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult? Function()? resetAuthStatus,
//   }) {
//     return verifyOTP?.call(phone, otp);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(String phone)? sendOTP,
//     TResult Function(String phone, String otp)? verifyOTP,
//     TResult Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult Function()? resetAuthStatus,
//     required TResult orElse(),
//   }) {
//     if (verifyOTP != null) {
//       return verifyOTP(phone, otp);
//     }
//     return orElse();
//   }

//   @override
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(_SendOTPEvent value) sendOTP,
//     required TResult Function(_VerifyOTPEvent value) verifyOTP,
//     required TResult Function(_SignupEvent value) signup,
//     required TResult Function(_ResetAuthStatusEvent value) resetAuthStatus,
//   }) {
//     return verifyOTP(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? mapOrNull<TResult extends Object?>({
//     TResult? Function(_SendOTPEvent value)? sendOTP,
//     TResult? Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult? Function(_SignupEvent value)? signup,
//     TResult? Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//   }) {
//     return verifyOTP?.call(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(_SendOTPEvent value)? sendOTP,
//     TResult Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult Function(_SignupEvent value)? signup,
//     TResult Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//     required TResult orElse(),
//   }) {
//     if (verifyOTP != null) {
//       return verifyOTP(this);
//     }
//     return orElse();
//   }
// }

// abstract class _VerifyOTPEvent implements AuthEvent {
//   const factory _VerifyOTPEvent(
//       {required final String phone,
//       required final String otp}) = _$VerifyOTPEventImpl;

//   String get phone;
//   String get otp;

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
//   @JsonKey(includeFromJson: false, includeToJson: false)
//   _$$VerifyOTPEventImplCopyWith<_$VerifyOTPEventImpl> get copyWith =>
//       throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class _$$SignupEventImplCopyWith<$Res> {
//   factory _$$SignupEventImplCopyWith(
//           _$SignupEventImpl value, $Res Function(_$SignupEventImpl) then) =
//       __$$SignupEventImplCopyWithImpl<$Res>;
//   @useResult
//   $Res call({String fullName, String email, String phone, String? referralId});
// }

// /// @nodoc
// class __$$SignupEventImplCopyWithImpl<$Res>
//     extends _$AuthEventCopyWithImpl<$Res, _$SignupEventImpl>
//     implements _$$SignupEventImplCopyWith<$Res> {
//   __$$SignupEventImplCopyWithImpl(
//       _$SignupEventImpl _value, $Res Function(_$SignupEventImpl) _then)
//       : super(_value, _then);

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
//   @pragma('vm:prefer-inline')
//   @override
//   $Res call({
//     Object? fullName = null,
//     Object? email = null,
//     Object? phone = null,
//     Object? referralId = freezed,
//   }) {
//     return _then(_$SignupEventImpl(
//       fullName: null == fullName
//           ? _value.fullName
//           : fullName // ignore: cast_nullable_to_non_nullable
//               as String,
//       email: null == email
//           ? _value.email
//           : email // ignore: cast_nullable_to_non_nullable
//               as String,
//       phone: null == phone
//           ? _value.phone
//           : phone // ignore: cast_nullable_to_non_nullable
//               as String,
//       referralId: freezed == referralId
//           ? _value.referralId
//           : referralId // ignore: cast_nullable_to_non_nullable
//               as String?,
//     ));
//   }
// }

// /// @nodoc

// class _$SignupEventImpl implements _SignupEvent {
//   const _$SignupEventImpl(
//       {required this.fullName,
//       required this.email,
//       required this.phone,
//       this.referralId});

//   @override
//   final String fullName;
//   @override
//   final String email;
//   @override
//   final String phone;
//   @override
//   final String? referralId;

//   @override
//   String toString() {
//     return 'AuthEvent.signup(fullName: $fullName, email: $email, phone: $phone, referralId: $referralId)';
//   }

//   @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         (other.runtimeType == runtimeType &&
//             other is _$SignupEventImpl &&
//             (identical(other.fullName, fullName) ||
//                 other.fullName == fullName) &&
//             (identical(other.email, email) || other.email == email) &&
//             (identical(other.phone, phone) || other.phone == phone) &&
//             (identical(other.referralId, referralId) ||
//                 other.referralId == referralId));
//   }

//   @override
//   int get hashCode =>
//       Object.hash(runtimeType, fullName, email, phone, referralId);

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
//   @JsonKey(includeFromJson: false, includeToJson: false)
//   @override
//   @pragma('vm:prefer-inline')
//   _$$SignupEventImplCopyWith<_$SignupEventImpl> get copyWith =>
//       __$$SignupEventImplCopyWithImpl<_$SignupEventImpl>(this, _$identity);

//   @override
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(String phone) sendOTP,
//     required TResult Function(String phone, String otp) verifyOTP,
//     required TResult Function(
//             String fullName, String email, String phone, String? referralId)
//         signup,
//     required TResult Function() resetAuthStatus,
//   }) {
//     return signup(fullName, email, phone, referralId);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? whenOrNull<TResult extends Object?>({
//     TResult? Function(String phone)? sendOTP,
//     TResult? Function(String phone, String otp)? verifyOTP,
//     TResult? Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult? Function()? resetAuthStatus,
//   }) {
//     return signup?.call(fullName, email, phone, referralId);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(String phone)? sendOTP,
//     TResult Function(String phone, String otp)? verifyOTP,
//     TResult Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult Function()? resetAuthStatus,
//     required TResult orElse(),
//   }) {
//     if (signup != null) {
//       return signup(fullName, email, phone, referralId);
//     }
//     return orElse();
//   }

//   @override
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(_SendOTPEvent value) sendOTP,
//     required TResult Function(_VerifyOTPEvent value) verifyOTP,
//     required TResult Function(_SignupEvent value) signup,
//     required TResult Function(_ResetAuthStatusEvent value) resetAuthStatus,
//   }) {
//     return signup(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? mapOrNull<TResult extends Object?>({
//     TResult? Function(_SendOTPEvent value)? sendOTP,
//     TResult? Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult? Function(_SignupEvent value)? signup,
//     TResult? Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//   }) {
//     return signup?.call(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(_SendOTPEvent value)? sendOTP,
//     TResult Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult Function(_SignupEvent value)? signup,
//     TResult Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//     required TResult orElse(),
//   }) {
//     if (signup != null) {
//       return signup(this);
//     }
//     return orElse();
//   }
// }

// abstract class _SignupEvent implements AuthEvent {
//   const factory _SignupEvent(
//       {required final String fullName,
//       required final String email,
//       required final String phone,
//       final String? referralId}) = _$SignupEventImpl;

//   String get fullName;
//   String get email;
//   String get phone;
//   String? get referralId;

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
//   @JsonKey(includeFromJson: false, includeToJson: false)
//   _$$SignupEventImplCopyWith<_$SignupEventImpl> get copyWith =>
//       throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class _$$ResetAuthStatusEventImplCopyWith<$Res> {
//   factory _$$ResetAuthStatusEventImplCopyWith(_$ResetAuthStatusEventImpl value,
//           $Res Function(_$ResetAuthStatusEventImpl) then) =
//       __$$ResetAuthStatusEventImplCopyWithImpl<$Res>;
// }

// /// @nodoc
// class __$$ResetAuthStatusEventImplCopyWithImpl<$Res>
//     extends _$AuthEventCopyWithImpl<$Res, _$ResetAuthStatusEventImpl>
//     implements _$$ResetAuthStatusEventImplCopyWith<$Res> {
//   __$$ResetAuthStatusEventImplCopyWithImpl(_$ResetAuthStatusEventImpl _value,
//       $Res Function(_$ResetAuthStatusEventImpl) _then)
//       : super(_value, _then);

//   /// Create a copy of AuthEvent
//   /// with the given fields replaced by the non-null parameter values.
// }

// /// @nodoc

// class _$ResetAuthStatusEventImpl implements _ResetAuthStatusEvent {
//   const _$ResetAuthStatusEventImpl();

//   @override
//   String toString() {
//     return 'AuthEvent.resetAuthStatus()';
//   }

//   @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         (other.runtimeType == runtimeType &&
//             other is _$ResetAuthStatusEventImpl);
//   }

//   @override
//   int get hashCode => runtimeType.hashCode;

//   @override
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(String phone) sendOTP,
//     required TResult Function(String phone, String otp) verifyOTP,
//     required TResult Function(
//             String fullName, String email, String phone, String? referralId)
//         signup,
//     required TResult Function() resetAuthStatus,
//   }) {
//     return resetAuthStatus();
//   }

//   @override
//   @optionalTypeArgs
//   TResult? whenOrNull<TResult extends Object?>({
//     TResult? Function(String phone)? sendOTP,
//     TResult? Function(String phone, String otp)? verifyOTP,
//     TResult? Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult? Function()? resetAuthStatus,
//   }) {
//     return resetAuthStatus?.call();
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(String phone)? sendOTP,
//     TResult Function(String phone, String otp)? verifyOTP,
//     TResult Function(
//             String fullName, String email, String phone, String? referralId)?
//         signup,
//     TResult Function()? resetAuthStatus,
//     required TResult orElse(),
//   }) {
//     if (resetAuthStatus != null) {
//       return resetAuthStatus();
//     }
//     return orElse();
//   }

//   @override
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(_SendOTPEvent value) sendOTP,
//     required TResult Function(_VerifyOTPEvent value) verifyOTP,
//     required TResult Function(_SignupEvent value) signup,
//     required TResult Function(_ResetAuthStatusEvent value) resetAuthStatus,
//   }) {
//     return resetAuthStatus(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? mapOrNull<TResult extends Object?>({
//     TResult? Function(_SendOTPEvent value)? sendOTP,
//     TResult? Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult? Function(_SignupEvent value)? signup,
//     TResult? Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//   }) {
//     return resetAuthStatus?.call(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(_SendOTPEvent value)? sendOTP,
//     TResult Function(_VerifyOTPEvent value)? verifyOTP,
//     TResult Function(_SignupEvent value)? signup,
//     TResult Function(_ResetAuthStatusEvent value)? resetAuthStatus,
//     required TResult orElse(),
//   }) {
//     if (resetAuthStatus != null) {
//       return resetAuthStatus(this);
//     }
//     return orElse();
//   }
// }

// abstract class _ResetAuthStatusEvent implements AuthEvent {
//   const factory _ResetAuthStatusEvent() = _$ResetAuthStatusEventImpl;
// }

// /// @nodoc
// mixin _$AuthState {
//   ApiStatus get otpSendStatus => throw _privateConstructorUsedError;
//   ApiStatus get otpVerifyStatus => throw _privateConstructorUsedError;
//   ApiStatus get signupStatus => throw _privateConstructorUsedError;
//   String? get errorMessage => throw _privateConstructorUsedError;
//   String? get successMessage => throw _privateConstructorUsedError;
//   AuthResponse? get authResponse => throw _privateConstructorUsedError;

//   /// Create a copy of AuthState
//   /// with the given fields replaced by the non-null parameter values.
//   @JsonKey(includeFromJson: false, includeToJson: false)
//   $AuthStateCopyWith<AuthState> get copyWith =>
//       throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class $AuthStateCopyWith<$Res> {
//   factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
//       _$AuthStateCopyWithImpl<$Res, AuthState>;
//   @useResult
//   $Res call(
//       {ApiStatus otpSendStatus,
//       ApiStatus otpVerifyStatus,
//       ApiStatus signupStatus,
//       String? errorMessage,
//       String? successMessage,
//       AuthResponse? authResponse});

//   $AuthResponseCopyWith<$Res>? get authResponse;
// }

// /// @nodoc
// class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
//     implements $AuthStateCopyWith<$Res> {
//   _$AuthStateCopyWithImpl(this._value, this._then);

//   // ignore: unused_field
//   final $Val _value;
//   // ignore: unused_field
//   final $Res Function($Val) _then;

//   /// Create a copy of AuthState
//   /// with the given fields replaced by the non-null parameter values.
//   @pragma('vm:prefer-inline')
//   @override
//   $Res call({
//     Object? otpSendStatus = null,
//     Object? otpVerifyStatus = null,
//     Object? signupStatus = null,
//     Object? errorMessage = freezed,
//     Object? successMessage = freezed,
//     Object? authResponse = freezed,
//   }) {
//     return _then(_value.copyWith(
//       otpSendStatus: null == otpSendStatus
//           ? _value.otpSendStatus
//           : otpSendStatus // ignore: cast_nullable_to_non_nullable
//               as ApiStatus,
//       otpVerifyStatus: null == otpVerifyStatus
//           ? _value.otpVerifyStatus
//           : otpVerifyStatus // ignore: cast_nullable_to_non_nullable
//               as ApiStatus,
//       signupStatus: null == signupStatus
//           ? _value.signupStatus
//           : signupStatus // ignore: cast_nullable_to_non_nullable
//               as ApiStatus,
//       errorMessage: freezed == errorMessage
//           ? _value.errorMessage
//           : errorMessage // ignore: cast_nullable_to_non_nullable
//               as String?,
//       successMessage: freezed == successMessage
//           ? _value.successMessage
//           : successMessage // ignore: cast_nullable_to_non_nullable
//               as String?,
//       authResponse: freezed == authResponse
//           ? _value.authResponse
//           : authResponse // ignore: cast_nullable_to_non_nullable
//               as AuthResponse?,
//     ) as $Val);
//   }

//   /// Create a copy of AuthState
//   /// with the given fields replaced by the non-null parameter values.
//   @override
//   @pragma('vm:prefer-inline')
//   $AuthResponseCopyWith<$Res>? get authResponse {
//     if (_value.authResponse == null) {
//       return null;
//     }

//     return $AuthResponseCopyWith<$Res>(_value.authResponse!, (value) {
//       return _then(_value.copyWith(authResponse: value) as $Val);
//     });
//   }
// }

// /// @nodoc
// abstract class _$$AuthStateImplCopyWith<$Res>
//     implements $AuthStateCopyWith<$Res> {
//   factory _$$AuthStateImplCopyWith(
//           _$AuthStateImpl value, $Res Function(_$AuthStateImpl) then) =
//       __$$AuthStateImplCopyWithImpl<$Res>;
//   @override
//   @useResult
//   $Res call(
//       {ApiStatus otpSendStatus,
//       ApiStatus otpVerifyStatus,
//       ApiStatus signupStatus,
//       String? errorMessage,
//       String? successMessage,
//       AuthResponse? authResponse});

//   @override
//   $AuthResponseCopyWith<$Res>? get authResponse;
// }

// /// @nodoc
// class __$$AuthStateImplCopyWithImpl<$Res>
//     extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
//     implements _$$AuthStateImplCopyWith<$Res> {
//   __$$AuthStateImplCopyWithImpl(
//       _$AuthStateImpl _value, $Res Function(_$AuthStateImpl) _then)
//       : super(_value, _then);

//   /// Create a copy of AuthState
//   /// with the given fields replaced by the non-null parameter values.
//   @pragma('vm:prefer-inline')
//   @override
//   $Res call({
//     Object? otpSendStatus = null,
//     Object? otpVerifyStatus = null,
//     Object? signupStatus = null,
//     Object? errorMessage = freezed,
//     Object? successMessage = freezed,
//     Object? authResponse = freezed,
//   }) {
//     return _then(_$AuthStateImpl(
//       otpSendStatus: null == otpSendStatus
//           ? _value.otpSendStatus
//           : otpSendStatus // ignore: cast_nullable_to_non_nullable
//               as ApiStatus,
//       otpVerifyStatus: null == otpVerifyStatus
//           ? _value.otpVerifyStatus
//           : otpVerifyStatus // ignore: cast_nullable_to_non_nullable
//               as ApiStatus,
//       signupStatus: null == signupStatus
//           ? _value.signupStatus
//           : signupStatus // ignore: cast_nullable_to_non_nullable
//               as ApiStatus,
//       errorMessage: freezed == errorMessage
//           ? _value.errorMessage
//           : errorMessage // ignore: cast_nullable_to_non_nullable
//               as String?,
//       successMessage: freezed == successMessage
//           ? _value.successMessage
//           : successMessage // ignore: cast_nullable_to_non_nullable
//               as String?,
//       authResponse: freezed == authResponse
//           ? _value.authResponse
//           : authResponse // ignore: cast_nullable_to_non_nullable
//               as AuthResponse?,
//     ));
//   }
// }

// /// @nodoc

// class _$AuthStateImpl implements _AuthState {
//   const _$AuthStateImpl(
//       {this.otpSendStatus = ApiStatus.initial,
//       this.otpVerifyStatus = ApiStatus.initial,
//       this.signupStatus = ApiStatus.initial,
//       this.errorMessage,
//       this.successMessage,
//       this.authResponse});

//   @override
//   @JsonKey()
//   final ApiStatus otpSendStatus;
//   @override
//   @JsonKey()
//   final ApiStatus otpVerifyStatus;
//   @override
//   @JsonKey()
//   final ApiStatus signupStatus;
//   @override
//   final String? errorMessage;
//   @override
//   final String? successMessage;
//   @override
//   final AuthResponse? authResponse;

//   @override
//   String toString() {
//     return 'AuthState(otpSendStatus: $otpSendStatus, otpVerifyStatus: $otpVerifyStatus, signupStatus: $signupStatus, errorMessage: $errorMessage, successMessage: $successMessage, authResponse: $authResponse)';
//   }

//   @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         (other.runtimeType == runtimeType &&
//             other is _$AuthStateImpl &&
//             (identical(other.otpSendStatus, otpSendStatus) ||
//                 other.otpSendStatus == otpSendStatus) &&
//             (identical(other.otpVerifyStatus, otpVerifyStatus) ||
//                 other.otpVerifyStatus == otpVerifyStatus) &&
//             (identical(other.signupStatus, signupStatus) ||
//                 other.signupStatus == signupStatus) &&
//             (identical(other.errorMessage, errorMessage) ||
//                 other.errorMessage == errorMessage) &&
//             (identical(other.successMessage, successMessage) ||
//                 other.successMessage == successMessage) &&
//             (identical(other.authResponse, authResponse) ||
//                 other.authResponse == authResponse));
//   }

//   @override
//   int get hashCode => Object.hash(runtimeType, otpSendStatus, otpVerifyStatus,
//       signupStatus, errorMessage, successMessage, authResponse);

//   /// Create a copy of AuthState
//   /// with the given fields replaced by the non-null parameter values.
//   @JsonKey(includeFromJson: false, includeToJson: false)
//   @override
//   @pragma('vm:prefer-inline')
//   _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
//       __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
// }

// abstract class _AuthState implements AuthState {
//   const factory _AuthState(
//       {final ApiStatus otpSendStatus,
//       final ApiStatus otpVerifyStatus,
//       final ApiStatus signupStatus,
//       final String? errorMessage,
//       final String? successMessage,
//       final AuthResponse? authResponse}) = _$AuthStateImpl;

//   @override
//   ApiStatus get otpSendStatus;
//   @override
//   ApiStatus get otpVerifyStatus;
//   @override
//   ApiStatus get signupStatus;
//   @override
//   String? get errorMessage;
//   @override
//   String? get successMessage;
//   @override
//   AuthResponse? get authResponse;

//   /// Create a copy of AuthState
//   /// with the given fields replaced by the non-null parameter values.
//   @override
//   @JsonKey(includeFromJson: false, includeToJson: false)
//   _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
//       throw _privateConstructorUsedError;
// }

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ThemeState {
  AppThemeMode get themeMode => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  bool get visible => throw _privateConstructorUsedError;
  bool get showNewWidget => throw _privateConstructorUsedError;
  double get bottomPosition => throw _privateConstructorUsedError;

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ThemeStateCopyWith<ThemeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeStateCopyWith<$Res> {
  factory $ThemeStateCopyWith(
          ThemeState value, $Res Function(ThemeState) then) =
      _$ThemeStateCopyWithImpl<$Res, ThemeState>;
  @useResult
  $Res call(
      {AppThemeMode themeMode,
      int index,
      bool visible,
      bool showNewWidget,
      double bottomPosition});
}

/// @nodoc
class _$ThemeStateCopyWithImpl<$Res, $Val extends ThemeState>
    implements $ThemeStateCopyWith<$Res> {
  _$ThemeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? index = null,
    Object? visible = null,
    Object? showNewWidget = null,
    Object? bottomPosition = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      showNewWidget: null == showNewWidget
          ? _value.showNewWidget
          : showNewWidget // ignore: cast_nullable_to_non_nullable
              as bool,
      bottomPosition: null == bottomPosition
          ? _value.bottomPosition
          : bottomPosition // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThemeStateImplCopyWith<$Res>
    implements $ThemeStateCopyWith<$Res> {
  factory _$$ThemeStateImplCopyWith(
          _$ThemeStateImpl value, $Res Function(_$ThemeStateImpl) then) =
      __$$ThemeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AppThemeMode themeMode,
      int index,
      bool visible,
      bool showNewWidget,
      double bottomPosition});
}

/// @nodoc
class __$$ThemeStateImplCopyWithImpl<$Res>
    extends _$ThemeStateCopyWithImpl<$Res, _$ThemeStateImpl>
    implements _$$ThemeStateImplCopyWith<$Res> {
  __$$ThemeStateImplCopyWithImpl(
      _$ThemeStateImpl _value, $Res Function(_$ThemeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? index = null,
    Object? visible = null,
    Object? showNewWidget = null,
    Object? bottomPosition = null,
  }) {
    return _then(_$ThemeStateImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      showNewWidget: null == showNewWidget
          ? _value.showNewWidget
          : showNewWidget // ignore: cast_nullable_to_non_nullable
              as bool,
      bottomPosition: null == bottomPosition
          ? _value.bottomPosition
          : bottomPosition // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$ThemeStateImpl implements _ThemeState {
  const _$ThemeStateImpl(
      {required this.themeMode,
      required this.index,
      this.visible = false,
      this.showNewWidget = false,
      this.bottomPosition = -200});

  @override
  final AppThemeMode themeMode;
  @override
  final int index;
  @override
  @JsonKey()
  final bool visible;
  @override
  @JsonKey()
  final bool showNewWidget;
  @override
  @JsonKey()
  final double bottomPosition;

  @override
  String toString() {
    return 'ThemeState(themeMode: $themeMode, index: $index, visible: $visible, showNewWidget: $showNewWidget, bottomPosition: $bottomPosition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeStateImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.showNewWidget, showNewWidget) ||
                other.showNewWidget == showNewWidget) &&
            (identical(other.bottomPosition, bottomPosition) ||
                other.bottomPosition == bottomPosition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, themeMode, index, visible, showNewWidget, bottomPosition);

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeStateImplCopyWith<_$ThemeStateImpl> get copyWith =>
      __$$ThemeStateImplCopyWithImpl<_$ThemeStateImpl>(this, _$identity);
}

abstract class _ThemeState implements ThemeState {
  const factory _ThemeState(
      {required final AppThemeMode themeMode,
      required final int index,
      final bool visible,
      final bool showNewWidget,
      final double bottomPosition}) = _$ThemeStateImpl;

  @override
  AppThemeMode get themeMode;
  @override
  int get index;
  @override
  bool get visible;
  @override
  bool get showNewWidget;
  @override
  double get bottomPosition;

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThemeStateImplCopyWith<_$ThemeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

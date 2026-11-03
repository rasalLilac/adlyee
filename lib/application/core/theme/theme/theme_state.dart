part of 'theme_cubit.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    required AppThemeMode themeMode,
    required int index,
    @Default(false) bool visible,
    @Default(false) bool showNewWidget,
    @Default(-200) double bottomPosition,
  }) = _ThemeState;

  factory ThemeState.initial() => const ThemeState(
        themeMode: AppThemeMode.light,
        index: 0,
      );
}

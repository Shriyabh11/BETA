part of 'navigation_bloc.dart';

@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({
    @Default(0) int selectedIndex,
    @Default([]) List<NavigationItem> items,
  }) = _NavigationState;
} 
part of 'navigation_bloc.dart';

@freezed
class NavigationEvent with _$NavigationEvent {
  const factory NavigationEvent.initialized() = _Initialized;
  const factory NavigationEvent.itemSelected(int index) = _ItemSelected;
} 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/navigation_item.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';
part 'navigation_bloc.freezed.dart';

@injectable
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc()
      : super(NavigationState(
          selectedIndex: 0,
          items: NavigationItem.items,
        )) {
    on<NavigationEvent>((event, emit) {
      event.map(
        initialized: (_) => _onInitialized(emit),
        itemSelected: (e) => _onItemSelected(e, emit),
      );
    });
  }

  void _onInitialized(Emitter<NavigationState> emit) {
    emit(state.copyWith(
      selectedIndex: 0,
      items: NavigationItem.items,
    ));
  }

  void _onItemSelected(_ItemSelected event, Emitter<NavigationState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }
}

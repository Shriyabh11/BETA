import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ask_entity.dart';
import '../../domain/repositories/ask_repository.dart';

// Events
abstract class AskEvent {}

class FetchAsks extends AskEvent {}

class FetchAskById extends AskEvent {
  final String id;
  FetchAskById(this.id);
}

// States
abstract class AskState {}

class AskInitial extends AskState {}

class AskLoading extends AskState {}

class AskLoaded extends AskState {
  final List<AskEntity> asks;
  AskLoaded(this.asks);
}

class AskError extends AskState {
  final String message;
  AskError(this.message);
}

// Bloc
class AskBloc extends Bloc<AskEvent, AskState> {
  final AskRepository repository;

  AskBloc(this.repository) : super(AskInitial()) {
    on<FetchAsks>((event, emit) async {
      emit(AskLoading());
      try {
        final asks = await repository.getAsks();
        emit(AskLoaded(asks));
      } catch (e) {
        emit(AskError(e.toString()));
      }
    });

    on<FetchAskById>((event, emit) async {
      emit(AskLoading());
      try {
        final ask = await repository.getAskById(event.id);
        emit(AskLoaded([ask]));
      } catch (e) {
        emit(AskError(e.toString()));
      }
    });
  }
}

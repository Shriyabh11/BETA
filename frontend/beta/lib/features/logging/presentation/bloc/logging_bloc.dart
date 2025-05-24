import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/log_entry.dart';
import '../../domain/repositories/logging_repository.dart';
import 'logging_state.dart';

//part 'logging_bloc.freezed.dart';
/*@injectable
class LoggingBloc extends Bloc<LoggingEvent, LoggingState> {
  final LoggingRepository _repository;

  LoggingBloc(this._repository) : super(const LoggingState()) {
    on<_TextChanged>(_onTextChanged);
    on<_ExtractData>(_onExtractData);
    on<_SubmitPressed>(_onSubmitPressed);
  }

  void _onTextChanged(_TextChanged event, Emitter<LoggingState> emit) {
    emit(state.copyWith(text: event.text));
  }

  Future<void> _onExtractData(_ExtractData event, Emitter<LoggingState> emit) async {
    try {
      emit(state.copyWith(isExtracting: true, error: null));
      final extractedData = await _repository.extractData(state.text);
      emit(state.copyWith(
        isExtracting: false,
        extractedData: extractedData,
      ));
    } catch (e) {
      emit(state.copyWith(
        isExtracting: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitPressed(_SubmitPressed event, Emitter<LoggingState> emit) async {
    try {
      emit(state.copyWith(isSubmitting: true, error: null));
      await _repository.submitLog(
        userId: event.userId,
        text: state.text,
        extractedData: state.extractedData,
      );
      emit(state.copyWith(
        isSubmitting: false,
        text: '',
        extractedData: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        error: e.toString(),
      ));
    }
  }
}

// Events
@freezed
class LoggingEvent with _$LoggingEvent {
  const factory LoggingEvent.textChanged(String text) = _TextChanged;
  const factory LoggingEvent.extractData() = _ExtractData;
  const factory LoggingEvent.submitPressed(String userId) = _SubmitPressed;
}

// State
@freezed
class LoggingState with _$LoggingState {
  const factory LoggingState({
    @Default('') String text,
    @Default(false) bool isSubmitting,
    @Default(false) bool isExtracting,
    LogEntry? lastSubmittedLog,
    Map<String, dynamic>? extractedData,
    String? error,
  }) = _LoggingState;
} */

// TODO: Uncomment when backend is ready
/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/chat_entry.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc(this._repository) : super(const ChatState()) {
    on<_QuestionAsked>(_onQuestionAsked);
    on<_HistoryRequested>(_onHistoryRequested);
    on<_FavoriteToggled>(_onFavoriteToggled);
    on<_FavoritesRequested>(_onFavoritesRequested);
  }

  Future<void> _onQuestionAsked(_QuestionAsked event, Emitter<ChatState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      
      final result = await _repository.askQuestion(event.request);
      
      result.fold(
        (error) => emit(state.copyWith(
          isLoading: false,
          error: error.toString(),
        )),
        (entry) => emit(state.copyWith(
          isLoading: false,
          currentResponse: entry,
          chatHistory: [entry, ...state.chatHistory],
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onHistoryRequested(_HistoryRequested event, Emitter<ChatState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      
      final result = await _repository.getChatHistory(event.userId);
      
      result.fold(
        (error) => emit(state.copyWith(
          isLoading: false,
          error: error.toString(),
        )),
        (history) => emit(state.copyWith(
          isLoading: false,
          chatHistory: history,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onFavoriteToggled(_FavoriteToggled event, Emitter<ChatState> emit) async {
    try {
      final result = await _repository.toggleFavorite(event.entryId);
      
      result.fold(
        (error) => emit(state.copyWith(error: error.toString())),
        (_) {
          // Update the entry in chat history
          final updatedHistory = state.chatHistory.map((entry) {
            if (entry.id == event.entryId) {
              return entry.copyWith(isFavorite: !entry.isFavorite);
            }
            return entry;
          }).toList();
          
          emit(state.copyWith(chatHistory: updatedHistory));
        },
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onFavoritesRequested(_FavoritesRequested event, Emitter<ChatState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      
      final result = await _repository.getFavorites(event.userId);
      
      result.fold(
        (error) => emit(state.copyWith(
          isLoading: false,
          error: error.toString(),
        )),
        (favorites) => emit(state.copyWith(
          isLoading: false,
          favorites: favorites,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.questionAsked(ChatRequest request) = _QuestionAsked;
  const factory ChatEvent.historyRequested(String userId) = _HistoryRequested;
  const factory ChatEvent.favoriteToggled(String entryId) = _FavoriteToggled;
  const factory ChatEvent.favoritesRequested(String userId) = _FavoritesRequested;
}

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatEntry> chatHistory,
    @Default([]) List<ChatEntry> favorites,
    ChatEntry? currentResponse,
    @Default(false) bool isLoading,
    String? error,
  }) = _ChatState;
}
*/ 
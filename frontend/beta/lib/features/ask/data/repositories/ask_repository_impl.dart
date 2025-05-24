import 'dart:async';
import '../../domain/entities/ask_entity.dart';
import '../../domain/repositories/ask_repository.dart';
import '../datasource/ask_reponse_datasource.dart';

class AskRepositoryImpl implements AskRepository {
  final AskDataSource dataSource;
  final Map<String, AskEntity> _cache = {};
  final Duration _cacheDuration = const Duration(minutes: 30);
  final Map<String, DateTime> _cacheTimestamps = {};

  AskRepositoryImpl({required this.dataSource});

  @override
  Future<List<AskEntity>> getAsks() async {
    try {
      // Clear expired cache entries
      _clearExpiredCache();

      // Return cached questions if available
      if (_cache.isNotEmpty) {
        return _cache.values.toList();
      }

      // You might want to implement a method to get all questions
      // For now, returning empty list as this might not be needed
      return [];
    } catch (e) {
      throw Exception('Failed to fetch asks: $e');
    }
  }

  @override
  Future<AskEntity> getAskById(String id) async {
    try {
      // Check cache first
      if (_isCacheValid(id)) {
        return _cache[id]!;
      }

      final response = await dataSource.askQuestion(id);
      final ask = AskEntity(
        id: id,
        question: id,
        answer: response.response,
      );

      // Cache the response
      _cache[id] = ask;
      _cacheTimestamps[id] = DateTime.now();

      return ask;
    } catch (e) {
      // If there's an error but we have a cached response, return it
      if (_isCacheValid(id)) {
        return _cache[id]!;
      }
      throw Exception('Failed to fetch ask: $e');
    }
  }

  bool _isCacheValid(String id) {
    if (!_cache.containsKey(id) || !_cacheTimestamps.containsKey(id)) {
      return false;
    }

    final timestamp = _cacheTimestamps[id]!;
    return DateTime.now().difference(timestamp) < _cacheDuration;
  }

  void _clearExpiredCache() {
    final now = DateTime.now();
    _cacheTimestamps.removeWhere((id, timestamp) {
      if (now.difference(timestamp) > _cacheDuration) {
        _cache.remove(id);
        return true;
      }
      return false;
    });
  }
}

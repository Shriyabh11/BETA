import '../entities/ask_entity.dart';

abstract class AskRepository {
  Future<List<AskEntity>> getAsks();
  Future<AskEntity> getAskById(String id);
}

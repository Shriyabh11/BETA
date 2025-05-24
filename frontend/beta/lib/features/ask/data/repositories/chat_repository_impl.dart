// repository/ask_repository.dart
import 'package:beta/features/ask/data/datasource/ask_reponse_datasource.dart';
import '../model/ask_response.dart';

class AskRepository {
  final AskDataSource dataSource;

  AskRepository({required this.dataSource});

  Future<AskResponse> getAnswer(String question, {String? token}) {
    return dataSource.askQuestion(question, token: token);
  }
}

// repository/log_repository.dart
import 'package:beta/features/logging/data/datasource/logging_remote_datasource.dart';
import 'package:beta/features/logging/data/models/log_response_model.dart';

class LogRepository {
  final LogDataSource dataSource;

  LogRepository({required this.dataSource});

  Future<LogResponse> sendLog({
    required String text,
    required String timestamp,
    required String userId,
    String? token,
  }) {
    return dataSource.processLog(
      text: text,
      timestamp: timestamp,
      userId: userId,
      token: token,
    );
  }
}

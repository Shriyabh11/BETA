// models/log_response.dart
import 'logging_entity.dart';

class LogResponse {
  final List<Entity> entities;
  final String timestamp;
  final String userId;

  LogResponse({
    required this.entities,
    required this.timestamp,
    required this.userId,
  });

  factory LogResponse.fromJson(Map<String, dynamic> json) {
    return LogResponse(
      entities: (json['entities'] as List<dynamic>)
          .map((e) => Entity.fromJson(e))
          .toList(),
      timestamp: json['timestamp'],
      userId: json['user_id'],
    );
  }
}

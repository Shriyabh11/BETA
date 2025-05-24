// data/remote/log_data_source.dart
import 'dart:convert';
import 'package:beta/features/logging/data/models/log_response_model.dart';
import 'package:http/http.dart' as http;

class LogDataSource {
  final String baseUrlLogger;

  LogDataSource({required this.baseUrlLogger});

  Future<LogResponse> processLog({
    required String text,
    required String timestamp,
    required String userId,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrlLogger/process_log');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'text': text,
        'timestamp': timestamp,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LogResponse.fromJson(data);
    } else {
      throw Exception('Failed to process log: ${response.body}');
    }
  }
}

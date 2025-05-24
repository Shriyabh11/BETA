// data/remote/ask_data_source.dart
import 'dart:convert';
import 'package:beta/features/ask/data/model/ask_response.dart';
import 'package:http/http.dart' as http;

class AskDataSource {
  final String baseUrlQandA;
  static const Duration timeout = Duration(seconds: 30);

  AskDataSource({required this.baseUrlQandA});

  Future<AskResponse> askQuestion(String query, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrlQandA/qa/ask');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'query': query,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AskResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests. Please try again later.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get response');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response from server');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('An unexpected error occurred: $e');
    }
  }
}

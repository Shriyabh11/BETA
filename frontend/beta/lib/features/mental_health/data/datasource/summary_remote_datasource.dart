// data/remote/summary_data_source.dart
import 'dart:convert';
import 'package:beta/features/mental_health/data/model/summary_response_model.dart';
import 'package:http/http.dart' as http;

class SummaryDataSource {
  final String baseUrl;

  SummaryDataSource({required this.baseUrl});

  Future<SummaryResponse> fetchSummary({String? token}) async {
    final url = Uri.parse('$baseUrl/summary');

    final response = await http.get(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return SummaryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch summary: ${response.body}');
    }
  }
}

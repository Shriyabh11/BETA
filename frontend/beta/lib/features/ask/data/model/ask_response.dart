// models/ask_response.dart
class AskResponse {
  final String response;
  final String category;
  final String source;

  AskResponse({
    required this.response,
    required this.category,
    required this.source,
  });

  factory AskResponse.fromJson(Map<String, dynamic> json) {
    return AskResponse(
      response: json['response'],
      category: json['category'],
      source: json['source'],
    );
  }
}

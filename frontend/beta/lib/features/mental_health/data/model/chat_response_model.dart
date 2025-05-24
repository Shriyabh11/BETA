// models/chat_response.dart
class ChatResponse {
  final String response;

  ChatResponse({required this.response});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(response: json['response']);
  }
}

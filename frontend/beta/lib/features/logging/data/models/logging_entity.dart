// models/entity.dart
class Entity {
  final String text;
  final String type;
  final int start;
  final int end;

  Entity({
    required this.text,
    required this.type,
    required this.start,
    required this.end,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      text: json['text'] ?? 'Not mentioned',
      type: json['type'] ?? 'Not mentioned',
      start: json['start'] ?? 0,
      end: json['end'] ?? 0,
    );
  }
}

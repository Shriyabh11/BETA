import 'package:hive/hive.dart';

part 'log_entry.g.dart';

@HiveType(typeId: 0)
class LogEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  String value;

  @HiveField(3)
  DateTime timestamp;

  LogEntry({
    required this.id,
    required this.type,
    required this.value,
    required this.timestamp,
  });
}

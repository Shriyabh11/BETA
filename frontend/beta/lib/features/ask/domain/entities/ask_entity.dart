import 'package:hive/hive.dart';

part 'ask_entity.g.dart';

@HiveType(typeId: 1)
class AskEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String question;
  @HiveField(2)
  final String answer;

  AskEntity({required this.id, required this.question, required this.answer});
}

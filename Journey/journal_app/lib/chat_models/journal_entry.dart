import 'package:hive/hive.dart';
part 'journal_entry.g.dart';

@HiveType(typeId: 6)
class JournalEntry {
  @HiveField(0)
  String id;

  @HiveField(1)
  String sessionId;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  String title;

  @HiveField(4)
  String reflection;

  @HiveField(5)
  String gratitude;

  @HiveField(6)
  String tomorrow;

  JournalEntry(
      {required this.id,
      required this.sessionId,
      required this.createdAt,
      required this.title,
      required this.reflection,
      required this.gratitude,
      required this.tomorrow});
}

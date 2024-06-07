import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime date;

  Task(this.name, this.date);
}

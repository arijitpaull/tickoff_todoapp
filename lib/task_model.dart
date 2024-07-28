import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime dueDate;

  @HiveField(3)
  late DateTime creationDate;

  @HiveField(4)
  late String priority;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.creationDate,
    required this.priority,
  });
}
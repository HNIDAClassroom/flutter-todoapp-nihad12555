import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category { personal, work, shopping, others }

class Task {
  Task({
    required this.title,
    this.description,
    required this.date,
    this.category,
    this.isCompleted = false,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final Category? category;
  bool isCompleted;
}

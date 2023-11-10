// task_item.dart

import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(Task) onDelete;
  final Function(Task) onToggleCompletion;

  TaskItem({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onToggleCompletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? value) {
          onToggleCompletion(task);
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description: ${task.description ?? "Aucune description"}'),
          Text('Category: ${task.category?.toString() ?? "Aucune catégorie"}'),
          Text('Date: ${task.date?.toString() ?? "Aucune date"}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onDelete(task);
            },
          ),
        ],
      ),
    );
  }
}

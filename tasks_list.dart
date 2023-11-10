// tasks_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/services/firestore.dart';
import '../models/task.dart';
import 'task_item.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    Key? key,
    required this.tasks,
    required this.onDelete,
    required this.onToggleCompletion,
  }) : super(key: key);

  final List<Task> tasks;
  final Function(Task) onDelete;
  final Function(Task) onToggleCompletion;

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No tasks available.'),
          );
        }

        final taskLists = snapshot.data!.docs;
        List<Task> taskItems = [];

        for (int index = 0; index < taskLists.length; index++) {
          DocumentSnapshot document = taskLists[index];
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String title = data['taskTitle'];
          String description = data['taskDesc'];
          DateTime date = DateTime.parse(data['taskDate']);
          String categoryString = data['taskCategory'];

          Category category;
          switch (categoryString) {
            case 'personal':
              category = Category.personal;
              break;
            case 'work':
              category = Category.work;
              break;
            case 'shopping':
              category = Category.shopping;
              break;
            default:
              category = Category.others;
          }

          Task task = Task(
            title: title,
            description: description,
            date: date,
            category: category,
          );
          taskItems.add(task);
        }

        return ListView.builder(
          itemCount: taskItems.length,
          itemBuilder: (ctx, index) {
            return TaskItem(
              task: taskItems[index],
              onDelete: onDelete,
              onToggleCompletion: onToggleCompletion,
            );
          },
        );
      },
    );
  }
}

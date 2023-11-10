import 'package:flutter/material.dart';
import 'package:todolist_app/services/firestore.dart';
import 'package:todolist_app/widgets/tasks_list.dart';

import '../models/task.dart';

import 'new_task.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() {
    return _TasksState();
  }
}

class _TasksState extends State<Tasks> {
  final FirestoreService firestoreService = FirestoreService();
  final List<Task> _registeredTasks = [
    Task(
      title: 'Apprendre Flutter',
      description: 'Suivre le cours pour apprendre de nouvelles compétences',
      date: DateTime.now(),
      category: Category.work,
    ),
    Task(
      title: 'Faire les courses',
      description: 'Acheter des provisions pour la semaine',
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.shopping,
    ),
    Task(
      title: 'Rediger un CR',
      description: '',
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: Category.personal,
    ),
    // Add more tasks with descriptions as needed
  ];
  void _openAddTaskOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewTask(onAddTask: _addTask, registeredTasks: []),
    );
  }

  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });

    // Mettez à jour la tâche dans Firestore
    firestoreService.updateTaskCompletion(task.id, task.isCompleted);
  }
  /*void _openEditTaskOverlay(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewTask(
        onAddTask: (editedTask) {
          _editTask(task, editedTask);
        },
        initialTask: task,
      ),
    );
  }*/

  /* void _editTask(Task oldTask, Task editedTask) {
    setState(() {
      _registeredTasks.remove(oldTask);
      _registeredTasks.add(editedTask);
      /*firestoreService.updateTask(editedTask);*/
      Navigator.pop(context);
    });
  }*/

  void _deleteTask(Task task) {
    setState(() {
      _registeredTasks.remove(task);
      firestoreService.deleteTask(task.id);
    });
  }

  void _addTask(Task task) {
    setState(() {
      _registeredTasks.add(task);
      firestoreService.addTask(task);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ToDoList'),
        actions: [
          IconButton(
            onPressed: _openAddTaskOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: TasksList(
        tasks: _registeredTasks,
        onDelete: _deleteTask,
        /*onEdit: _openEditTaskOverlay),*/
        onToggleCompletion: _toggleTaskCompletion,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/services/firestore.dart';
import 'package:intl/intl.dart';

class NewTask extends StatefulWidget {
  const NewTask({
    Key? key,
    required this.onAddTask,
    required this.registeredTasks,
    /*this.initialTask,*/
  }) : super(key: key);

  final void Function(Task task) onAddTask;
  final List<Task> registeredTasks;
/*final Task? initialTask;*/
  @override
  State<NewTask> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  /*@override
  void initState() {
    super.initState();
    // Si initialTask est fourni, initialisez les contrôleurs avec ses valeurs
    if (widget.initialTask != null) {
      _titleController.text = widget.initialTask!.title;
      _descriptionController.text = widget.initialTask!.description ?? '';
      _categoryController.text = widget.initialTask!.category?.toString() ?? '';
      _dateController.text =
          widget.initialTask!.date?.toLocal().toString().split(' ')[0] ?? '';
    }
  }*/
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submitTaskData() {
    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erreur'),
          content: const Text(
              'Merci de saisir le titre de la tâche à ajouter dans la liste'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    String title = _titleController.text;
    String description = _descriptionController.text;
    String category = _categoryController.text;
    String date = _dateController.text;

    Task newTask = Task(
      title: title,
      description: description,
      category: Category.values.firstWhere(
        (e) => e.toString() == 'Category.$category',
      ),
      date: DateTime.parse(date),
    );

    setState(() {
      widget.registeredTasks.add(newTask);
    });

    widget.onAddTask(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: _descriptionController,
            maxLength: 150,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: 'Category',
            ),
          ),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              labelText: 'Date',
            ),
            readOnly: true,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (selectedDate != null && selectedDate != DateTime.now()) {
                String formattedDate = DateFormat('yyyy-MM-dd')
                    .format(selectedDate); // Formatage de la date
                setState(() {
                  _dateController.text = formattedDate;
                });
              }
            },
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _submitTaskData();
                },
                child: Text('Save Task'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

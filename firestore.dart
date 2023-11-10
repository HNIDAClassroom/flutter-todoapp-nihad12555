import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/models/task.dart';

class FirestoreService {
  /*final FirebaseFirestore _firestore = FirebaseFirestore.instance;*/
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');
  Future<void> addTask(Task task) {
    return FirebaseFirestore.instance.collection('tasks').add(
      {
        'taskTitle': task.title.toString(),
        'taskDesc': task.description.toString(),
        'taskDate': task.date != null ? task.date!.toIso8601String() : 'NoDate',
        'taskCategory': task.category != null ? task.category.toString() : null,
      },
    );
    print('Tâche ajoutée avec succès');
  }

  Future<void> deleteTask(String taskId) {
    return tasks.doc(taskId).delete();
  }

  /*Future<void> updateTask(Task task) {
    return tasks.doc(task.id).update({
      'taskTitle': task.title.toString(),
      'taskDesc': task.description.toString(),
      'taskDate': task.date != null ? task.date!.toIso8601String() : 'NoDate',
      'taskCategory': task.category != null ? task.category.toString() : null,
    });
  }*/
  /*Stream<QuerySnapshot> getTasks() {
  return FirebaseFirestore.instance.collection('tasks').snapshots();
}*/
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'isCompleted': isCompleted});
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'état de complétion : $e');
    }
  }
  Stream <QuerySnapshot> getTasks()
{
final taskStream= tasks.snapshots();
return taskStream;
}
}

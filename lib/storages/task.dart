import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_candidate.dart';

class TaskStorage {
  static const name = "tasks";

  static final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection(name);

  static Future<void> update(String documentId, TaskCandidate candidate) {
    return collectionReference.doc(documentId).update({
      'updated_at': Timestamp.now(),
      'due_date_time': candidate.dueDateTime!.isEmpty
          ? null
          : DateTime.parse(candidate.dueDateTime!),
      'is_completed': candidate.isCompleted,
      'title': candidate.title,
      'description': candidate.description,
    });
  }

  static Future<void> setIsCompleted(String documentId, bool value) {
    return collectionReference.doc(documentId).update({'is_completed': value});
  }

  static Future<void> delete(String documentId) {
    return collectionReference.doc(documentId).delete();
  }

  static Future<DocumentSnapshot<Object?>> get(String documentId) {
    return collectionReference.doc(documentId).get();
    
  }

  static Future<void> add(TaskCandidate candidate) {

    /**
     * Validation
     */
    if (candidate.title.isEmpty) throw Exception('Title cannot be empty.');

    return collectionReference.add({
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
      'due_date_time': candidate.dueDateTime!.isEmpty
          ? null
          : DateTime.parse(candidate.dueDateTime!),
      'is_completed': candidate.isCompleted,
      'title': candidate.title,
      'description': candidate.description,
    });
  }

  static Stream<QuerySnapshot> getStream() {
    return collectionReference
        .orderBy('is_completed')
        .orderBy('due_date_time', descending: true)
        .snapshots();
  }
}

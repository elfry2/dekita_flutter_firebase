import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dekita_flutter_firebase/models/task_candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_router/go_router.dart';

import '../../components/my_text_form_field.dart';
import '../../config.dart';
import '../../models/task.dart';
import '../../scaffolds/form.dart';
import '../../storages/task.dart';

class TaskModificationPage extends StatefulWidget {
  final String documentId;

  const TaskModificationPage({super.key, required this.documentId});

  @override
  State<TaskModificationPage> createState() => _TaskModificationPageState();
}

class _TaskModificationPageState extends State<TaskModificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleTextEditingController =
      TextEditingController();
  final TextEditingController _taskDescriptionTextEditingController =
      TextEditingController();
  final TextEditingController _taskDueDateTimeTextEditingController =
      TextEditingController();
  bool _isTaskCompleted = false;
  Exception? exception;
  bool _initial = true;

  void _save() {
    TaskCandidate taskCandidate = TaskCandidate(
      title: _taskTitleTextEditingController.text,
      description: _taskDescriptionTextEditingController.text,
      dueDateTime: _taskDueDateTimeTextEditingController.text,
      isCompleted: _isTaskCompleted,
    );

    try {
      TaskStorage.update(widget.documentId, taskCandidate);
      
      context.goNamed('task.index', queryParameters: {'message': 'Task updated'});
    } on Exception catch (exception) {
      setState(() {
        this.exception = exception;
      });
    }
  }

  void _delete() {
    try {
      TaskStorage.delete(widget.documentId);

      context.goNamed('task.index', queryParameters: {'message': 'Task deleted'});
    } on Exception catch (exception) {
      setState(() {
        this.exception = exception;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: 'Edit task',
      actions: [
        IconButton(onPressed: _delete, icon: Icon(Icons.delete)),
        TextButton(
          onPressed: _save,
          child: Row(spacing: 4.0, children: [Icon(Icons.save), Text('Save')]),
        ),
      ],
      body: FutureBuilder(
        future: TaskStorage.get(widget.documentId),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasError) {
            print(asyncSnapshot.error);
            return Center(child: Text("An error occurred"));
          }

          DocumentSnapshot<Object?> documentSnapshot = asyncSnapshot.data!;

          if (!documentSnapshot.exists) {
            return Center(child: Text('Data does not exist'));
          }

          Map<String, dynamic> documentSnapshotData =
              documentSnapshot.data() as Map<String, dynamic>;

          Task task = Task(
            id: documentSnapshot.id,
            title: documentSnapshotData['title'],
            description: documentSnapshotData['description'],
            dueDateTime: documentSnapshotData['due_date_time']?.toDate(),
            isCompleted: documentSnapshotData['is_completed'],
          );

          _taskTitleTextEditingController.text = task.title;
          _taskDescriptionTextEditingController.text = task.description ?? '';
          _taskDueDateTimeTextEditingController.text =
              task.dueDateTime?.toString() ?? '';
          _isTaskCompleted = _initial ? task.isCompleted : _isTaskCompleted;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: config.defaultSpacing,
              children: [
                if (exception != null)
                  Text(
                    exception.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                MyTextFormField(
                  labelText: 'Title',
                  controller: _taskTitleTextEditingController,
                  autofocus: true,
                ),
                MyTextFormField(
                  labelText: 'Description',
                  controller: _taskDescriptionTextEditingController,
                ),
                MyTextFormField(
                  labelText: 'Due date',
                  controller: _taskDueDateTimeTextEditingController,

                  onTap: () async {
                    DateTime? selectedDueDateTime =
                        await DatePicker.showDateTimePicker(context);

                    _taskDueDateTimeTextEditingController.text =
                        selectedDueDateTime.toString();
                  },
                ),
                CheckboxListTile(
                  title: Text('The task is completed'),
                  value: _isTaskCompleted,
                  onChanged: (value) {
                    setState(() {
                      _initial = false;
                      _isTaskCompleted = value ?? false;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

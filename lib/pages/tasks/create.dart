import 'package:dekita_flutter_firebase/models/task_candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_router/go_router.dart';

import '../../components/my_text_form_field.dart';
import '../../config.dart';
import '../../scaffolds/form.dart';
import '../../storages/task.dart';

class TaskCreationPage extends StatefulWidget {
  const TaskCreationPage({super.key});

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleTextEditingController =
      TextEditingController();
  final TextEditingController _taskDescriptionTextEditingController =
      TextEditingController();
  final TextEditingController _taskDueDateTimeTextEditingController =
      TextEditingController();
  bool _isTaskCompleted = false;
  Exception? exception;

  void _save() {
    TaskCandidate taskCandidate = TaskCandidate(
      title: _taskTitleTextEditingController.text,
      description: _taskDescriptionTextEditingController.text,
      dueDateTime: _taskDueDateTimeTextEditingController.text,
      isCompleted: _isTaskCompleted,
    );

    try {
      TaskStorage.add(taskCandidate);
    } on Exception catch (exception) {
      setState(() {
        this.exception = exception;
      });
      return;
    }

    context.goNamed('task.index', queryParameters: {'message': 'Task created'});
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: 'Add new task',
      actions: [
        TextButton(
          onPressed: _save,
          child: Row(spacing: 4.0, children: [Icon(Icons.save), Text('Save')]),
        ),
      ],
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: config.defaultSpacing,
          children: [
            if(exception != null) Text(exception.toString(), style: TextStyle(color: Colors.red)),
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
                  _isTaskCompleted = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

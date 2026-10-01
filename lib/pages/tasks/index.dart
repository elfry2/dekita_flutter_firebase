import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:relative_time/relative_time.dart';

import '../../config.dart';
import '../../scaffolds/main.dart';
import '../../storages/task.dart';

class TaskIndexPage extends StatefulWidget {
  final String? message;

  const TaskIndexPage({super.key, this.message});

  @override
  State<TaskIndexPage> createState() => _TaskIndexPageState();
}

class _TaskIndexPageState extends State<TaskIndexPage> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          context.pushNamed('task.create');
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: TaskStorage.getStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("An error occurred"));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data. Tap + to create'));
          }

          List<DocumentSnapshot> documentSnapshotList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documentSnapshotList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = documentSnapshotList
                  .elementAt(index);
              Map<String, dynamic> task =
                  documentSnapshot.data() as Map<String, dynamic>;

              DateTime? dueDateTime;

              if (task['due_date_time'] != null) {
                dueDateTime = (task['due_date_time'] as Timestamp).toDate();
              }

              return Column(
                spacing: config.defaultSpacing,
                children: [
                  if (widget.message != null)
                    Text(widget.message!, style: TextStyle(color: Colors.red)),
                  ListTile(
                    key: Key(documentSnapshot.id),
                    title: Text(task['title']),
                    subtitle: Text(
                      (dueDateTime == null
                              ? ''
                              : dueDateTime.toString() + ' · ') +
                          task['description'],
                    ),
                    trailing: Checkbox(
                      value: task['is_completed'],
                      onChanged: (value) {
                        try {
                          TaskStorage.setIsCompleted(
                            documentSnapshot.id,
                            value ?? false,
                          );
                        } on Exception catch (exception) {
                          print(exception);
                        }
                      },
                    ),
                    onTap: () {
                      context.pushNamed(
                        'task.edit',
                        pathParameters: {'id': documentSnapshot.id},
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

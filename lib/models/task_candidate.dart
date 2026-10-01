class TaskCandidate {
  final String title;
  final String? description;
  final String? dueDateTime;
  final bool isCompleted;

  TaskCandidate({required this.title, this.description, this.dueDateTime, this.isCompleted = false});
}
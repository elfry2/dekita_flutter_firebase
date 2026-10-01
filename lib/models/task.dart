class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDateTime;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDateTime,
    this.isCompleted = false,
  });
}

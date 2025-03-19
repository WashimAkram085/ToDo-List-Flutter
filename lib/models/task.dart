class Task {
  String title;
  bool isCompleted;
  DateTime? targetDate;
  List<Task> subtasks; // 🔹 Now stores a list of Task objects

  Task({
    required this.title,
    this.isCompleted = false,
    this.targetDate,
    List<Task>? subtasks,
  }) : subtasks = subtasks ?? [];

  // Convert Task to Map (for shared preferences storage)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'targetDate': targetDate?.toIso8601String(),
      'subtasks': subtasks.map((subtask) => subtask.toJson()).toList(), // 🔹 Convert subtasks to JSON
    };
  }

  // Convert JSON to Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'],
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate']) : null,
      subtasks: (json['subtasks'] as List<dynamic>?)
          ?.map((subtaskJson) => Task.fromJson(subtaskJson))
          .toList() ?? [],
    );
  }
}

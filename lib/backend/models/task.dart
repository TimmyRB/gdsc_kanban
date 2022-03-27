class Task {
  final int id;
  final String description;
  final String assignee;
  final DateTime dueDate;

  Task(this.id, this.description, this.assignee, this.dueDate);

  Task.fromJson(Map<String, dynamic> json)
      : description = json['task_description'],
        assignee = json['task_assignee'],
        dueDate = DateTime.parse(json['task_duedate']),
        id = json['id'];

  @override
  String toString() {
    return 'Task{id: $id, description: $description, assignee: $assignee, dueDate: ${dueDate.toString()}}';
  }
}

import 'package:gdsc_kanban/backend/models/task.dart';

class Status {
  final int id;
  final String title;
  int order;
  final List<Task> tasks;

  Status(this.id, this.title, this.order, this.tasks);

  Status.fromJson(Map<String, dynamic> json, this.tasks)
      : title = json['status_title'],
        order = json['status_order'],
        id = json['id'];

  @override
  String toString() {
    return 'Status{id: $id, title: $title, order: $order, tasks: ${tasks.toString()}}';
  }
}

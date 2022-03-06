import 'package:gdsc_kanban/backend/models/task.dart';

class Status {
  final int id;
  String _title;
  int _order;
  final List<Task> tasks;

  Status(this.id, this._title, this._order, this.tasks);

  Status.fromJson(Map<String, dynamic> json, this.tasks)
      : _title = json['status_title'],
        _order = json['status_order'],
        id = json['id'];

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get order => _order;

  set order(int value) {
    _order = value;
  }

  @override
  String toString() {
    return 'Status{id: $id, title: $_title, order: $_order, tasks: ${tasks.toString()}}';
  }
}

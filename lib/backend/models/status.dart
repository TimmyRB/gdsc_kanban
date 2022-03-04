import 'package:gdsc_kanban/backend/models/task.dart';

class Status {
  String _title;
  final List<Task> tasks;

  Status(this._title, this.tasks);

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}

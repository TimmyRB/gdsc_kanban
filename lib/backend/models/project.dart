import 'package:gdsc_kanban/backend/models/status.dart';

class Project {
  String _title;
  final List<Status> statuses;
  final List<int> assignes;

  Project(this._title, this.statuses, this.assignes);

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}

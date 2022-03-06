import 'package:gdsc_kanban/backend/models/status.dart';

class Project {
  final int id;
  String _title;
  final List<Status> statuses;

  Project(this.id, this._title, this.statuses);

  Project.fromJson(Map<String, dynamic> json, this.statuses)
      : id = json['id'],
        _title = json['project_title'];

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  @override
  String toString() {
    return 'Project{id: $id, title: $title, statuses: ${statuses.toString()}}';
  }
}

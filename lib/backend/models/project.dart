import 'package:gdsc_kanban/backend/models/status.dart';

class Project {
  final int id;
  final String title;
  final List<Status> statuses;

  Project(this.id, this.title, this.statuses);

  Project.fromJson(Map<String, dynamic> json, this.statuses)
      : id = json['id'],
        title = json['project_title'];

  @override
  String toString() {
    return 'Project{id: $id, title: $title, statuses: ${statuses.toString()}}';
  }
}

import 'dart:convert';

import 'package:gdsc_kanban/backend/config.dart';
import 'package:gdsc_kanban/backend/controllers/status_controller.dart';
import 'package:gdsc_kanban/backend/models/project.dart';
import 'package:gdsc_kanban/backend/models/status.dart';
import 'package:http/http.dart' as http;

class ProjectController {
  static Future<Project> createProject(String title) async {
    http.Client client = http.Client();
    http.Response res = await client.post(Config.uri('projects'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'project': {
            'project_title': title,
          }
        }));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);

      client.close();
      return Project.fromJson(json, []);
    }

    client.close();
    throw Exception('Failed to create project: ${res.statusCode}');
  }

  static Future<List<Project>> getProjects() async {
    http.Client client = http.Client();
    http.Response res = await client.get(Config.uri('/projects'));

    var json = jsonDecode(res.body);

    List<Project> projects = [];

    for (var p in json) {
      projects.add(Project(p['id'], p['project_title'], []));
    }

    client.close();
    return projects;
  }

  static Future<Project> fetchById(int id) async {
    http.Client client = http.Client();

    http.Response res = await client.get(Config.uri('projects/$id'));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);

      List<Status> statuses = await StatusController.getStatuses(json['id']);

      client.close();
      return Project(json['id'], json['project_title'], statuses);
    }

    client.close();
    throw Exception('Failed to fetch project: Something went wrong');
  }

  static Future<void> deleteProject(int id) async {
    http.Client client = http.Client();
    http.Response res = await client.delete(Config.uri('projects/$id'));

    if (res.statusCode == 200) {
      client.close();
      return;
    }

    client.close();
    throw Exception('Failed to delete project: ${res.statusCode}');
  }
}

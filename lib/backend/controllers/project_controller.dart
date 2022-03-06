import 'dart:convert';

import 'package:gdsc_kanban/backend/config.dart';
import 'package:gdsc_kanban/backend/models/project.dart';
import 'package:gdsc_kanban/backend/models/status.dart';
import 'package:gdsc_kanban/backend/models/task.dart';
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

    http.Response projectRes = await client.get(Config.uri('projects/$id'));
    http.Response statusRes = await client.get(Config.uri('status/$id'));

    if (projectRes.statusCode == 200 && statusRes.statusCode == 200) {
      var projJson = jsonDecode(projectRes.body);

      List<Status> statuses = [];

      var statusJson = jsonDecode(statusRes.body);

      for (var status in statusJson) {
        http.Response taskRes =
            await client.get(Config.uri('tasks/${status['id']}'));

        if (taskRes.statusCode == 200) {
          var taskJson = jsonDecode(taskRes.body);

          List<Task> tasks = [];

          for (var task in taskJson) {
            tasks.add(Task.fromJson(task));
          }

          statuses.add(Status.fromJson(status, tasks));
        } else {
          throw Exception('Failed to fetch tasks: ${taskRes.statusCode}');
        }
      }

      client.close();
      return Project(projJson['id'], projJson['project_title'], statuses);
    } else if (projectRes.statusCode != 200) {
      throw Exception('Failed to fetch project: ${projectRes.statusCode}');
    } else if (statusRes.statusCode != 200) {
      throw Exception(
          'Failed to fetch project\'s statuses: ${statusRes.statusCode}');
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

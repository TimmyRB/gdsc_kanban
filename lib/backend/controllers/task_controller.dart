import 'dart:convert';

import 'package:gdsc_kanban/backend/config.dart';
import 'package:gdsc_kanban/backend/models/task.dart';
import 'package:http/http.dart' as http;

class TaskController {
  static Future<Task> createTask(Task task, int statusId) async {
    http.Client client = http.Client();
    http.Response res = await client.post(Config.uri('tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'task': {
            'status_id': statusId,
            'task_assignee': task.assignee,
            'task_description': task.description,
            'task_duedate': task.dueDate.toLocal().toString(),
          }
        }));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);

      client.close();
      return Task.fromJson(json);
    }

    client.close();
    throw Exception('Failed to create task: ${res.statusCode}');
  }

  static Future<List<Task>> getTasks(int statusId) async {
    http.Client client = http.Client();
    http.Response res = await client.get(Config.uri('tasks/$statusId'));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);

      List<Task> tasks = [];

      for (var task in json) {
        tasks.add(Task.fromJson(task));
      }

      client.close();
      return tasks;
    }

    client.close();
    throw Exception('Failed to fetch tasks: ${res.statusCode}');
  }

  static Future<void> deleteTask(int id) async {
    http.Client client = http.Client();
    http.Response res = await client.delete(Config.uri('tasks/$id'));

    if (res.statusCode == 200) {
      client.close();
      return;
    }

    client.close();
    throw Exception('Failed to delete task: ${res.statusCode}');
  }
}

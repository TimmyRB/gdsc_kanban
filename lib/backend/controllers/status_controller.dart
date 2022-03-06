import 'dart:convert';

import 'package:gdsc_kanban/backend/config.dart';
import 'package:gdsc_kanban/backend/controllers/task_controller.dart';
import 'package:gdsc_kanban/backend/models/status.dart';
import 'package:gdsc_kanban/backend/models/task.dart';
import 'package:http/http.dart' as http;

class StatusController {
  static Future<Status> createStatus(Status status, int projectId) async {
    http.Client client = http.Client();
    http.Response res = await client.post(Config.uri('status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': {
            'project_id': projectId,
            'status_title': status.title,
            'status_order': status.order,
          }
        }));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);

      client.close();
      return Status.fromJson(json, []);
    }

    client.close();
    throw Exception('Failed to create status: ${res.statusCode}');
  }

  static Future<List<Status>> getStatuses(int projectId) async {
    http.Client client = http.Client();
    http.Response res = await client.get(Config.uri('status/$projectId'));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);

      List<Status> statuses = [];

      for (var status in json) {
        List<Task> tasks = await TaskController.getTasks(status['id']);
        statuses.add(Status.fromJson(status, tasks));
      }

      client.close();
      return statuses;
    }

    client.close();
    throw Exception('Failed to get statuses: ${res.statusCode}');
  }

  static Future<void> deleteStatus(int id) async {
    http.Client client = http.Client();
    http.Response res = await client.delete(Config.uri('status/$id'));

    if (res.statusCode == 200) {
      client.close();
      return;
    }

    client.close();
    throw Exception('Failed to delete status: ${res.statusCode}');
  }

  static Future<void> updateOrder(
      Status status, int newOrder, int projectId) async {
    http.Client client = http.Client();
    http.Response res = await client.put(Config.uri('status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': {
            'id': status.id,
            'status_order': newOrder,
            'project_id': projectId,
            'status_title': status.title,
          }
        }));

    if (res.statusCode == 200) {
      client.close();
      return;
    }

    client.close();
    throw Exception('Failed to update status order: ${res.statusCode}');
  }
}

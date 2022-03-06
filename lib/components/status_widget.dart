import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gdsc_kanban/backend/controllers/task_controller.dart';
import 'package:gdsc_kanban/backend/models/status.dart';
import 'package:gdsc_kanban/components/add_button.dart';

class StatusWidget extends StatefulWidget {
  final Status status;
  final Function()? onDelete;
  final Function(int) onOrderChange;
  final Function()? onAddTask;

  const StatusWidget(
      {Key? key,
      required this.status,
      this.onDelete,
      this.onAddTask,
      required this.onOrderChange})
      : super(key: key);

  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          title: Text(
            widget.status.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Order: ${widget.status.order}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: () => widget.onOrderChange(widget.status.order - 1),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () => widget.onOrderChange(widget.status.order + 1),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          tileColor: Colors.grey[900],
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
        const SizedBox(height: 8.0),
        for (var task in widget.status.tasks)
          ListTile(
            title: Text(
              task.description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                'Assigned: ${task.assignee}\nDue: ${DateFormat('MMMM d, yyyy').format(task.dueDate)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => TaskController.deleteTask(task.id).then(
                (_) => setState(
                  () {
                    widget.status.tasks.remove(task);
                  },
                ),
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.all(4.0),
          child: AddButton(
            addType: 'Task',
            onPressed: widget.onAddTask,
          ),
        ),
      ]),
    );
  }
}

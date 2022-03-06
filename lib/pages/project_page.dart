import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdsc_kanban/backend/controllers/project_controller.dart';
import 'package:gdsc_kanban/backend/controllers/status_controller.dart';
import 'package:gdsc_kanban/backend/controllers/task_controller.dart';
import 'package:gdsc_kanban/backend/models/project.dart';
import 'package:gdsc_kanban/backend/models/status.dart';
import 'package:gdsc_kanban/backend/models/task.dart';
import 'package:gdsc_kanban/components/add_button.dart';
import 'package:gdsc_kanban/components/status_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum PanelType {
  add_status,
  add_task,
}

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final PanelController _panelController = PanelController();
  Widget _panel = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
      controller: _panelController,
      backdropEnabled: true,
      minHeight: 0.0,
      maxHeight: MediaQuery.of(context).size.height * 0.5,
      panel: _panel,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(widget.project.title),
            pinned: true,
          ),
          FutureBuilder<Project>(
              future: ProjectController.fetchById(widget.project.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Status> statuses = snapshot.data!.statuses;
                  statuses.sort((a, b) => a.order.compareTo(b.order));
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return StatusWidget(
                            status: statuses[index],
                            onAddTask: () {
                              setState(() {
                                _panel = _addTask(statuses[index].id);
                              });
                              _panelController.open();
                            },
                            onDelete: () => StatusController.deleteStatus(
                                    statuses[index].id)
                                .then((_) =>
                                    setState(() => statuses.removeAt(index))),
                            onOrderChange: (order) =>
                                StatusController.updateOrder(
                                  statuses[index],
                                  order,
                                  widget.project.id,
                                ).then((_) => setState(() => statuses.sort(
                                    (a, b) => a.order.compareTo(b.order)))));
                      },
                      childCount: statuses.length,
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: const CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  );
                }
              }),
          SliverToBoxAdapter(
            child: Container(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 32.0),
              child: AddButton(
                addType: 'Status',
                onPressed: () {
                  setState(() {
                    _panel = _addStatus();
                  });
                  _panelController.open();
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _addStatus() {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController _titleController = TextEditingController();
    TextEditingController _orderController = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Status Title', hintText: 'Status #1'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _orderController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an order';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Order',
                hintText: '1',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _panelController.close();
                  StatusController.createStatus(
                          Status(0, _titleController.text,
                              int.parse(_orderController.text), []),
                          widget.project.id)
                      .then((_) => setState(() {}));
                  _titleController.clear();
                  _orderController.clear();
                }
              },
              child: const Text('Create Status'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.resolveWith((states) {
                  return const Size(double.infinity, 48.0);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addTask(int statusId) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    DateTime _dueDate = DateTime.now();
    TextEditingController _titleController = TextEditingController();
    TextEditingController _assigneeController = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Task Title', hintText: 'Task #1'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _assigneeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an assignee';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Assignee',
                hintText: 'John Doe',
              ),
            ),
            const SizedBox(height: 16.0),
            InputDatePickerFormField(
              fieldLabelText: 'Due Date',
              errorInvalidText: 'Please enter a due date',
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
              onDateSaved: (date) => _dueDate = date,
              onDateSubmitted: (date) => _dueDate = date,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _panelController.close();
                  TaskController.createTask(
                          Task(0, _titleController.text,
                              _assigneeController.text, _dueDate),
                          statusId)
                      .then((_) => setState(() {}));
                  _titleController.clear();
                  _assigneeController.clear();
                }
              },
              child: const Text('Create Task'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.resolveWith((states) {
                  return const Size(double.infinity, 48.0);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

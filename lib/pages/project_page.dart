import 'package:flutter/material.dart';
import 'package:gdsc_kanban/backend/controllers/project_controller.dart';
import 'package:gdsc_kanban/backend/controllers/status_controller.dart';
import 'package:gdsc_kanban/backend/models/project.dart';
import 'package:gdsc_kanban/backend/models/status.dart';
import 'package:gdsc_kanban/components/add_button.dart';
import 'package:gdsc_kanban/components/status_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
      controller: _panelController,
      minHeight: 0.0,
      panel: Container(),
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
                  return const SliverToBoxAdapter();
                }
              }),
          SliverToBoxAdapter(
            child: Container(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 32.0),
              child: AddButton(
                addType: 'Status',
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

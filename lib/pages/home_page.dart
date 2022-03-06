import 'package:flutter/material.dart';
import 'package:gdsc_kanban/backend/controllers/project_controller.dart';
import 'package:gdsc_kanban/backend/models/project.dart';
import 'package:gdsc_kanban/pages/project_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController _panelController = PanelController();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        backdropEnabled: true,
        minHeight: 0.0,
        maxHeight: MediaQuery.of(context).size.height * 0.25,
        panel: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Project Title',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _panelController.close();
                  ProjectController.createProject(_textController.text)
                      .then((_) => setState(() {}));
                  _textController.clear();
                },
                child: const Text('Create Project'),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith((states) {
                    return const Size(double.infinity, 48.0);
                  }),
                ),
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Kanban'),
              pinned: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _panelController.open(),
                ),
              ],
            ),
            FutureBuilder<List<Project>>(
                future: ProjectController.getProjects(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(
                          title: Text(snapshot.data![index].title),
                          trailing: const Icon(Icons.chevron_right),
                          leading: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                ProjectController.deleteProject(
                                        snapshot.data![index].id)
                                    .then((_) => setState(
                                        () => snapshot.data!.removeAt(index)));
                              }),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ProjectPage(
                                    project: snapshot.data![index]))),
                          ),
                        ),
                        childCount: snapshot.data!.length,
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const ListTile(
                          title: Text('Loading Projects...'),
                        ),
                        childCount: 1,
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

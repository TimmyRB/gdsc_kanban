import 'package:flutter/material.dart';
import 'package:gdsc_kanban/backend/models/project.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController _panelController = PanelController();
  List<Project> projects = [];

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
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Project Title',
                ),
              ),
              ElevatedButton(
                onPressed: () => _panelController.close(),
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _panelController.open(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

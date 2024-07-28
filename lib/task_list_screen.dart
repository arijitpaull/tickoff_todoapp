import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_model.dart';
import 'task_form.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final Box<Task> taskBox = Hive.box<Task>('tasks');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _filteredTasks = taskBox.values.toList().reversed.toList();
    _searchController.addListener(_updateSearchQuery);
  }

  void _updateSearchQuery() {
    setState(() {
      _searchQuery = _searchController.text;
      _filteredTasks = taskBox.values
          .where((task) =>
              task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              task.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList()
          .reversed
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tickoff'),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No tasks yet. Add some!'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredTasks.length,
                  itemBuilder: (context, index) {
                    Task task = _filteredTasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Text(task.priority),
                      onLongPress: () {
                        _deleteTask(index);
                      },
                      onTap: () {
                        _showTaskForm(context, task: task, index: index);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskForm(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteTask(int index) {
    taskBox.deleteAt(index);
    _updateSearchQuery(); 
  }

  void _showTaskForm(BuildContext context, {Task? task, int? index}) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TaskForm(
          task: task,
          index: index,
        );
      },
    ).then((_) {
      _updateSearchQuery(); 
    });
  }
}
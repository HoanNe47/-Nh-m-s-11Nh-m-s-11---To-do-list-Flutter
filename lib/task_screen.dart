import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return ListTile(
                      title: GestureDetector(
                        onDoubleTap: () {
                          _showEditTaskDialog(context, task);
                        },
                        child: Text(task.title),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: task.completed,
                            onChanged: (bool? value) {
                              Task updatedTask = Task(
                                id: task.id,
                                title: task.title,
                                completed: value ?? false,
                              );
                              taskProvider.updateTask(updatedTask);
                            },
                          ),
                          // Nút xóa task
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, taskProvider, task);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: 'Add a new task',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      taskProvider.addTask(value);
                      _taskController.clear();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Hiển thị dialog chỉnh sửa task
  void _showEditTaskDialog(BuildContext context, Task task) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final TextEditingController _editController = TextEditingController();
    _editController.text = task.title;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_editController.text.isNotEmpty) {
                  Task updatedTask = Task(
                    id: task.id,
                    title: _editController.text,
                    completed: task.completed,
                  );
                  taskProvider.updateTask(updatedTask);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị dialog xác nhận xóa task
  void _showDeleteConfirmationDialog(BuildContext context, TaskProvider taskProvider, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                taskProvider.deleteTask(task.id);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'task.dart';
import 'task_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final TaskService _taskService = TaskService();

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _taskService.fetchTasks();
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    Task newTask = await _taskService.addTask(title);
    _tasks.add(newTask);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _taskService.updateTask(task);
    int index = _tasks.indexWhere((t) => t.id == task.id);
    _tasks[index] = task;
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}

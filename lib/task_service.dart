import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task.dart';

class TaskService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  // Fetch tasks
  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Add task
  Future<Task> addTask(String title) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'completed': false}),
    );
    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add task');
    }
  }

  // Update task
  Future<void> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': task.title,
        'completed': task.completed,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  // Delete task by id
  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}

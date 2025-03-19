import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

class SharedPrefsService {
  static const String _tasksKey = 'tasks';

  // Save tasks list to SharedPreferences
  static Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList(_tasksKey, tasksJson);
  }

  // Load tasks from SharedPreferences
  static Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasksJson = prefs.getStringList(_tasksKey);
    if (tasksJson == null) return [];
    return tasksJson.map((task) => Task.fromJson(jsonDecode(task))).toList();
  }
}

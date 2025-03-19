import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../services/shared_prefs.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();
  DateTime? selectedDate;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await SharedPrefsService.loadTasks();
    setState(() {});
  }

  void addTask() {
    if (taskController.text.isEmpty) return;
    setState(() {
      tasks.add(Task(title: taskController.text, targetDate: selectedDate));
      taskController.clear();
      selectedDate = null;
      SharedPrefsService.saveTasks(tasks);
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      SharedPrefsService.saveTasks(tasks);
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      for (var subtask in tasks[index].subtasks) {
        subtask.isCompleted = tasks[index].isCompleted;
      }
      SharedPrefsService.saveTasks(tasks);
    });
  }

  void selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void addSubtask(int index, String subtaskTitle) {
    if (subtaskTitle.isEmpty) return;
    setState(() {
      tasks[index].subtasks.add(Task(title: subtaskTitle));
      SharedPrefsService.saveTasks(tasks);
    });
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'To-Do List',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          elevation: 4,
          leading: IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: toggleTheme,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('taskField'),
                      controller: taskController,
                      decoration: const InputDecoration(labelText: 'New Task'),
                    ),
                  ),
                  IconButton(
                    key: const Key('datePickerButton'),
                    icon: const Icon(Icons.date_range),
                    onPressed: () => selectDate(context),
                  ),
                  IconButton(
                    key: const Key('addTaskButton'),
                    icon: const Icon(Icons.add),
                    onPressed: addTask,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                    key: Key('taskTile_$index'),
                    task: tasks[index],
                    onToggle: () => toggleTask(index),
                    onDelete: () => deleteTask(index),
                    onAddSubtask: (sub) => addSubtask(index, sub),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
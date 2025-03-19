import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(String) onAddSubtask;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onAddSubtask,
  });

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  TextEditingController subtaskController = TextEditingController();
  bool showSubtasks = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: widget.task.isCompleted,
              onChanged: (value) => widget.onToggle(),
            ),
            title: Text(
              widget.task.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: widget.task.targetDate != null
                ? Text(
                    'Due: ${DateFormat('dd-MM-yyyy').format(widget.task.targetDate!)}',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(showSubtasks ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      showSubtasks = !showSubtasks;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ),
          if (showSubtasks)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.task.subtasks.map((sub) => Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Row(
                        children: [
                          Checkbox(
                            value: sub.isCompleted,
                            onChanged: (value) {
                              setState(() {
                                sub.isCompleted = !sub.isCompleted;
                              });
                            },
                          ),
                          Text(
                            sub.title,
                            style: TextStyle(
                              decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: subtaskController,
                          decoration: const InputDecoration(labelText: 'New Subtask'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          widget.onAddSubtask(subtaskController.text);
                          subtaskController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
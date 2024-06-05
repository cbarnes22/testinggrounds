// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class DailyListWidget extends StatefulWidget {
  final DateTime selectedDate;

  const DailyListWidget({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  DailyListWidgetState createState() => DailyListWidgetState();
}

class DailyListWidgetState extends State<DailyListWidget> {
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void didUpdateWidget(DailyListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _loadTasks();
    }
  }

  void _loadTasks() async {
    // Load tasks for the selected date from database or file storage
    // Update the _tasks list with the loaded tasks
    // Example: _tasks = await loadTasksFromStorage(widget.selectedDate);
    setState(() {});
  }

  void _saveTasks() async {
    // Save tasks for the selected date to database or file storage
    // Example: await saveTasksToStorage(widget.selectedDate, _tasks);
  }

  void _addTask(String taskName, TimeOfDay dueTime) {
    setState(() {
      _tasks.add(Task(name: taskName, dueTime: dueTime, isCompleted: false));
    });
    _saveTasks();
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tasks for ${widget.selectedDate.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(
                    task.name,
                    style: TextStyle(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: task.dueTime != null
                      ? Text('Due at ${task.dueTime!.format(context)}')
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) => _toggleTaskCompletion(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddTaskDialog(onAddTask: _addTask);
                },
              );
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}

class Task {
  String name;
  TimeOfDay? dueTime;
  bool isCompleted;

  Task({required this.name, this.dueTime, required this.isCompleted});
}

class AddTaskDialog extends StatefulWidget {
  final Function(String, TimeOfDay) onAddTask;

  const AddTaskDialog({Key? key, required this.onAddTask}) : super(key: key);

  @override
  AddTaskDialogState createState() => AddTaskDialogState();
}

class AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              setState(() {
                _selectedTime = pickedTime;
              });
            },
            child: Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text(_selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Select Due Time'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Add'),
          onPressed: () {
            final taskName = _nameController.text;
            widget.onAddTask(taskName, _selectedTime ?? TimeOfDay.now());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

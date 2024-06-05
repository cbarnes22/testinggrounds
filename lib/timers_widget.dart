import 'dart:async';
import 'package:flutter/material.dart';

class TimersWidget extends StatefulWidget {
  const TimersWidget({super.key});

  @override
  TimersWidgetState createState() => TimersWidgetState();
}

class TimersWidgetState extends State<TimersWidget> {
  List<TimerData> timers = [];

  void _addTimer(String name, int duration, bool loop, String sound) {
    setState(() {
      timers.add(TimerData(
        name: name,
        duration: duration,
        initialDuration: duration,
        loop: loop,
        sound: sound,
        isRunning: false,
      ));
    });
  }

  void _startTimer(TimerData timer) {
    setState(() {
      timer.isRunning = true;
      timer.timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          if (timer.duration > 0) {
            timer.duration--;
          } else {
            if (timer.loop) {
              timer.duration = timer.initialDuration;
            } else {
              t.cancel();
              timer.isRunning = false;
              _playSound(timer.sound);
            }
          }
        });
      });
    });
  }

  void _stopTimer(TimerData timer) {
    setState(() {
      timer.timer?.cancel();
      timer.isRunning = false;
    });
  }

  void _deleteTimer(TimerData timer) {
    setState(() {
      timers.remove(timer);
    });
  }

  void _playSound(String sound) async {
    // Implement sound playback logic using AudioPlayer
    // For example: await _audioPlayer.play('assets/sounds/$sound.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: timers.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final timer = timers[index];
                return TimerCard(
                  timer: timer,
                  onStart: () => _startTimer(timer),
                  onStop: () => _stopTimer(timer),
                  onDelete: () => _deleteTimer(timer),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddTimerDialog(onAddTimer: _addTimer);
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class AudioPlayer {}

class TimerData {
  String name;
  int duration;
  int initialDuration;
  bool loop;
  String sound;
  bool isRunning;
  Timer? timer;

  TimerData({
    required this.name,
    required this.duration,
    required this.initialDuration,
    required this.loop,
    required this.sound,
    required this.isRunning,
    this.timer,
  });
}

class TimerCard extends StatelessWidget {
  final TimerData timer;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onDelete;

  const TimerCard({
    super.key,
    required this.timer,
    required this.onStart,
    required this.onStop,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(timer.name),
      subtitle: Text(
        '${timer.duration ~/ 60}:${(timer.duration % 60).toString().padLeft(2, '0')}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
            onPressed: timer.isRunning ? onStop : onStart,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class AddTimerDialog extends StatefulWidget {
  final Function(String, int, bool, String) onAddTimer;

  const AddTimerDialog({super.key, required this.onAddTimer});

  @override
  AddTimerDialogState createState() => AddTimerDialogState();
}

class AddTimerDialogState extends State<AddTimerDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  bool _loop = false;
  String _selectedSound = 'A';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Timer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Timer Name'),
          ),
          TextField(
            controller: durationController,
            decoration:
                const InputDecoration(labelText: 'Duration (in seconds)'),
            keyboardType: TextInputType.number,
          ),
          Row(
            children: [
              Checkbox(
                value: _loop,
                onChanged: (value) {
                  setState(() {
                    _loop = value ?? false;
                  });
                },
              ),
              const Text('Loop'),
            ],
          ),
          DropdownButton<String>(
            value: _selectedSound,
            onChanged: (value) {
              setState(() {
                _selectedSound = value ?? 'A';
              });
            },
            items: ['A', 'B', 'C']
                .map((sound) => DropdownMenuItem(
                      value: sound,
                      child: Text('Sound $sound'),
                    ))
                .toList(),
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
            final name = nameController.text;
            final duration = int.tryParse(durationController.text) ?? 0;
            widget.onAddTimer(name, duration, _loop, _selectedSound);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

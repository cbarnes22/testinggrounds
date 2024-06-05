import 'package:flutter/material.dart';
import 'clock_widget.dart';
import 'calendar_widget.dart';
import 'daily_list_widget.dart';
import 'timers_widget.dart';
import 'checklist_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isCalendarOpen = false;
  bool _isDailyListOpen = false;
  bool _isTimersOpen = false;
  bool _isChecklistOpen = false;
  DateTime _selectedDate = DateTime.now();

  void _toggleCalendar() {
    setState(() {
      _isCalendarOpen = !_isCalendarOpen;
    });
  }

  void _toggleDailyList() {
    setState(() {
      _isDailyListOpen = !_isDailyListOpen;
    });
  }

  void _toggleTimers() {
    setState(() {
      _isTimersOpen = !_isTimersOpen;
    });
  }

  void _toggleChecklist() {
    setState(() {
      _isChecklistOpen = !_isChecklistOpen;
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(child: ClockWidget()),
          Positioned(
            left: 16,
            top: 16,
            child: ElevatedButton(
              onPressed: _toggleCalendar,
              child: const Text('Calendar'),
            ),
          ),
          if (_isCalendarOpen)
            Positioned(
              left: 0,
              top: 60,
              child: Container(
                width: 375,
                height: 375,
                color: Colors.blue,
                child: CalendarWidget(onDateSelected: _onDateSelected),
              ),
            ),
          Positioned(
            right: 16,
            top: 16,
            child: ElevatedButton(
              onPressed: _toggleDailyList,
              child: const Text('Daily List'),
            ),
          ),
          if (_isDailyListOpen)
            Positioned(
              right: 0,
              top: 60,
              child: Container(
                width: 400,
                height: 375,
                color: Colors.green,
                child: DailyListWidget(selectedDate: _selectedDate),
              ),
            ),
          Positioned(
            left: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: _toggleTimers,
              child: const Text('Timers'),
            ),
          ),
          if (_isTimersOpen)
            Positioned(
              left: 0,
              bottom: 60,
              child: Container(
                width: 375,
                height: 375,
                color: Colors.orange,
                child: const TimersWidget(),
              ),
            ),
          Positioned(
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: _toggleChecklist,
              child: const Text('Checklist'),
            ),
          ),
          if (_isChecklistOpen)
            Positioned(
              right: 0,
              bottom: 60,
              child: Container(
                width: 400,
                height: 350,
                color: Colors.purple,
                child: const ChecklistWidget(),
              ),
            ),
        ],
      ),
    );
  }
}

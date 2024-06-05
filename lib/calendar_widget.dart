import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CalendarWidget({super.key, required this.onDateSelected});

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();

  void onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        DateTime date =
            DateTime(_selectedDate.year, _selectedDate.month, index + 1);
        bool isSelected = date.day == _selectedDate.day &&
            date.month == _selectedDate.month &&
            date.year == _selectedDate.year;

        return DateButton(
          date: date,
          isSelected: isSelected,
          onTap: () => onDateSelected(date),
        );
      },
    );
  }
}

class DateButton extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateButton({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border:
              isSelected ? Border.all(color: Colors.blue, width: 2.0) : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

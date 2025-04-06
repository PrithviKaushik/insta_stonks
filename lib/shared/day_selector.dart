import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';

class DaySelector extends StatefulWidget {
  final Function(List<String>) onDaysChanged;

  const DaySelector({super.key, required this.onDaysChanged});

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  final GlobalKey<SelectWeekDaysState> _dayPickerKey = GlobalKey();

  final List<DayInWeek> _days = [
    DayInWeek("Mon", dayKey: "monday"),
    DayInWeek("Tue", dayKey: "tuesday"),
    DayInWeek("Wed", dayKey: "wednesday"),
    DayInWeek("Thu", dayKey: "thursday"),
    DayInWeek("Fri", dayKey: "friday"),
    DayInWeek("Sat", dayKey: "saturday"),
    DayInWeek("Sun", dayKey: "sunday"),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SelectWeekDays(
        key: _dayPickerKey,
        days: _days,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        border: false,
        width: MediaQuery.of(context).size.width * 0.85,
        selectedDaysFillColor: const Color(0xFF833AB4),
        unselectedDaysFillColor: Colors.grey.shade300,
        selectedDayTextColor: Colors.white,
        unSelectedDayTextColor: Colors.black87,
        boxDecoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
        ),
        onSelect: widget.onDaysChanged,
      ),
    );
  }
}

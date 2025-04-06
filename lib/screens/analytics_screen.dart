import 'package:flutter/material.dart';
import 'package:insta_stonks/shared/day_selector.dart';
import 'package:insta_stonks/shared/left_drawer.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          DaySelector(
            onDaysChanged: (selectedDays) {
              print("Selected days: $selectedDays");
              // Handle logic with selected days here
            },
          ),
        ],
      ),
    );
  }
}

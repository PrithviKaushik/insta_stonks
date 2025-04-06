import 'package:flutter/material.dart';
import 'package:insta_stonks/shared/day_selector.dart';
import 'package:insta_stonks/shared/left_drawer.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<double> _likesByHour = [];
  String? _selectedDay;
  int? _peakHour;
  bool _isLoading = false;

  // Fetches the likes data for a given day asynchronously
  Future<void> _fetchLikesForDay(String day, List<double> likes) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Simulate data fetching (can be replaced with actual async code)
    await Future.delayed(const Duration(seconds: 2)); // Simulating async call

    setState(() {
      _likesByHour = likes;
      _selectedDay = day;
      _peakHour = _calculatePeakHour(likes);
      _isLoading = false; // Hide loading indicator
    });
  }

  // Calculates the peak hour based on the likes data
  int? _calculatePeakHour(List<double> likes) {
    if (likes.isEmpty) return null;
    final double maxLikes = likes.reduce((a, b) => a > b ? a : b);
    return likes.indexOf(maxLikes) + 1; // Hours start from 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Day Selector
            DaySelector(onDaySelected: _fetchLikesForDay),

            // Display selected day and peak hour
            if (_selectedDay != null) ...[
              SizedBox(height: 16),
              Text(
                'Estimated Likes for $_selectedDay',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],

            if (_peakHour != null) ...[
              SizedBox(height: 8),
              Text(
                'Best time to post: $_peakHour:00',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],

            // Graph section
            if (_likesByHour.isNotEmpty && !_isLoading) ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
                    _buildChartData(), // Pass the chart data to LineChart
                  ),
                ),
              ),
            ],

            // Loading indicator while data is being fetched
            if (_isLoading) ...[
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  // Builds the chart data for the LineChart widget
  LineChartData _buildChartData() {
    // Safeguard against empty data
    if (_likesByHour.isEmpty) {
      return LineChartData(
        borderData: FlBorderData(show: false),
        lineBarsData: [],
      );
    }

    return LineChartData(
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget:
                (value, _) => Text(
                  '${value.toInt()}',
                  style: const TextStyle(fontSize: 12),
                ),
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          top: BorderSide.none,
          right: BorderSide.none,
          left: BorderSide(width: 1),
          bottom: BorderSide(width: 1),
        ),
      ),
      gridData: FlGridData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            _likesByHour.length,
            (i) => FlSpot(i.toDouble(), _likesByHour[i]),
          ),
          isCurved: true,
          color: Theme.of(context).colorScheme.primary,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }
}

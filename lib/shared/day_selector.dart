import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package
import 'package:intl/intl.dart'; // Import the intl package for number formatting

class DaySelector extends StatefulWidget {
  final Function(String, List<double>) onDaySelected;

  const DaySelector({super.key, required this.onDaySelected});

  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  String? _selectedDay;
  List<double> _estimatedLikesList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                _days.map((day) {
                  final isSelected = _selectedDay == day;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () => _selectDay(day),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        if (_estimatedLikesList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (value, meta) => Text(_getLeftTitles(value)),
                      reservedSize: 40, // Space reserved for the left titles
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (value, meta) => Text(_getBottomTitles(value)),
                      reservedSize: 30, // Space reserved for the bottom titles
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ), // Hide the top titles
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ), // Hide the right titles
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black26, width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots:
                        _estimatedLikesList
                            .asMap()
                            .map(
                              (index, value) => MapEntry(
                                index.toDouble(),
                                FlSpot(index.toDouble(), value),
                              ),
                            )
                            .values
                            .toList(),
                    isCurved: true,
                    color: Theme.of(context).primaryColor, // Line color
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue, // Area below the line
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _selectDay(String day) async {
    setState(() {
      _selectedDay = day;
      _estimatedLikesList.clear();
    });

    final fullDayName = _fullDayName(day);

    // Fetch likes for each hour in parallel for efficiency
    final futures = List.generate(
      24,
      (i) => _fetchLikesForHour(fullDayName, i),
    );
    final results = await Future.wait(futures);

    setState(() {
      _estimatedLikesList = results;
    });

    widget.onDaySelected(day, _estimatedLikesList);
  }

  Future<double> _fetchLikesForHour(String fullDayName, int hour) async {
    try {
      final response = await http.post(
        Uri.parse('https://viralyze.onrender.com/api/predict/likes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'day': fullDayName, 'hour': hour.toString()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final raw = data['predictedLikes'];

        return _parseLikes(raw);
      } else {
        print(
          'HTTP Error ${response.statusCode} at hour $hour: ${response.body}',
        );
        return 0.0;
      }
    } catch (e) {
      print('Error fetching data for hour $hour: $e');
      return 0.0;
    }
  }

  double _parseLikes(dynamic raw) {
    if (raw == null) {
      print('Error: estimated_likes is null');
      return 0.0;
    }

    if (raw is int) {
      return raw.toDouble();
    } else if (raw is double) {
      return raw;
    } else if (raw is String) {
      final parsed = double.tryParse(raw);
      if (parsed == null) {
        print('Error: Failed to parse string to double for value $raw');
        return 0.0;
      }
      return parsed;
    } else {
      print('Error: Unexpected data type for estimated_likes: $raw');
      return 0.0;
    }
  }

  String _fullDayName(String code) {
    const dayMap = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };
    return dayMap[code] ?? code;
  }

  // Formatter for the Y-axis (likes in 'k' format)
  String _getLeftTitles(double value) {
    final numberFormat = NumberFormat.compact(); // '20k' format
    return numberFormat.format(value);
  }

  // Formatter for the X-axis (hours from 0 to 23)
  String _getBottomTitles(double value) {
    return value.toInt().toString(); // Display hours as 0 to 23
  }
}

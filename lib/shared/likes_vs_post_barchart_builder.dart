import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:insta_stonks/models/models.dart';

double _calculateInterval(List<Post> posts) {
  final max = posts
      .map((p) => p.likesCount.toDouble())
      .reduce((a, b) => a > b ? a : b);
  if (max <= 1000) return 200;
  if (max <= 10000) return 1000;
  if (max <= 50000) return 5000;
  if (max <= 100000) return 10000;
  return 20000;
}

Widget buildBarChart(List<Post> posts) {
  if (posts.isEmpty) return const Center(child: Text('No posts to display'));

  final maxLikes = posts
      .map((p) => p.likesCount.toDouble())
      .reduce((a, b) => a > b ? a : b);
  final interval = _calculateInterval(posts);
  final maxY = (maxLikes / interval).ceil() * interval;

  return Padding(
    padding: const EdgeInsets.all(4),
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              reservedSize: 50,
              getTitlesWidget: (value, _) {
                if (value == 0)
                  return const Text('0', style: TextStyle(fontSize: 10));
                if (value >= 1000000) {
                  return Text(
                    '${(value / 1000000).toStringAsFixed(1)}M',
                    style: const TextStyle(fontSize: 10),
                  );
                } else if (value >= 1000) {
                  return Text(
                    '${(value / 1000).toStringAsFixed(0)}K',
                    style: const TextStyle(fontSize: 10),
                  );
                } else {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                }
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 32,
              getTitlesWidget: (value, _) {
                int index = value.toInt();
                if (index < posts.length) {
                  final date = posts[index].timestamp;
                  return Text(
                    DateFormat('E').format(date), // Mon, Tue...
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: interval,
          drawVerticalLine: false,
          getDrawingHorizontalLine:
              (value) =>
                  FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            posts.asMap().entries.map((entry) {
              int index = entry.key;
              Post post = entry.value;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: post.likesCount.toDouble(),
                    width: 12,
                    color: const Color(0xFF833AB4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
      ),
    ),
  );
}

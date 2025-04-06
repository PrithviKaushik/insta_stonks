import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:insta_stonks/models/models.dart';

double _calculateInterval(List<Post> posts) {
  final max = posts
      .map((p) => p.likesCount.toDouble())
      .reduce((a, b) => a > b ? a : b);
  if (max <= 50) return 10;
  if (max <= 100) return 20;
  if (max <= 500) return 100;
  if (max <= 1000) return 200;
  if (max <= 10000) return 1000;
  if (max <= 50000) return 5000;
  if (max <= 100000) return 10000;
  return 20000;
}

Widget buildBarChart(List<Post> posts) {
  if (posts.isEmpty) return const Center(child: Text('No posts to display'));

  // Sort posts by timestamp to show them chronologically
  final sortedPosts = List<Post>.from(posts)
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  // Take the most recent X posts for better visibility
  final displayPosts =
      sortedPosts.length > 10
          ? sortedPosts.sublist(sortedPosts.length - 10)
          : sortedPosts;

  final maxLikes = displayPosts
      .map((p) => p.likesCount.toDouble())
      .reduce((a, b) => a > b ? a : b);
  final interval = _calculateInterval(displayPosts);
  final maxY = (maxLikes / interval).ceil() * interval;

  return Padding(
    padding: const EdgeInsets.all(4),
    child: Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Recent Post Performance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Showing likes count for ${displayPosts.length} recent posts',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  //tooltipBackground: const Color(0xCC607D8B),  // Fixed: Colors.blueGrey with 80% opacity
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final post = displayPosts[group.x.toInt()];
                    return BarTooltipItem(
                      '${DateFormat('MMM d').format(post.timestamp)}\n${post.likesCount} likes',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval,
                    reservedSize: 50,
                    getTitlesWidget: (value, _) {
                      if (value == 0) {
                        return const Text('0', style: TextStyle(fontSize: 10));
                      }
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
                      if (index < displayPosts.length) {
                        final date = displayPosts[index].timestamp;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/dd').format(date),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: interval,
                drawVerticalLine: false,
                getDrawingHorizontalLine:
                    (value) => FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    ),
              ),
              borderData: FlBorderData(show: false),
              barGroups:
                  displayPosts.asMap().entries.map((entry) {
                    int index = entry.key;
                    Post post = entry.value;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: post.likesCount.toDouble(),
                          width: 12,
                          color: Color(0xFF833AB4), // Instagram purple
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    ),
  );
}

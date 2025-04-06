import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insta_stonks/models/models.dart';

final baseUrl = 'https://viralyze.onrender.com/api/stats';

Future<List<Post>> fetchPosts(String username) async {
  final response = await http.get(
    Uri.parse('https://viralyze.onrender.com/api/stats'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> trendData = data['engagementTrend'];
    return trendData.map((json) => Post.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

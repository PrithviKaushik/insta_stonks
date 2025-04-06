import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insta_stonks/models/models.dart';

class ApiService {
  static const String baseUrl = 'https://viralyze.onrender.com/api';

  // Fetch posts for a specific username
  static Future<List<Post>> fetchPosts(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$username'));

    if (response.statusCode == 200) {
      final List<dynamic> postsJson = jsonDecode(response.body);
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } else {
      // Handle error responses
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load posts');
      } catch (_) {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    }
  }

  // Fetch analytics data if needed
  static Future<Map<String, dynamic>> fetchAnalytics(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/stats/$username'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load analytics');
    }
  }
}

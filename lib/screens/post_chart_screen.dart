import 'package:flutter/material.dart';
import 'package:insta_stonks/models/models.dart'; // Replace with actual path to Post model
import 'package:insta_stonks/services/services.dart'; // Replace with actual path to fetchPosts function
import 'package:insta_stonks/shared/shared.dart'; // Replace with actual path to buildBarChart widget

// A screen that shows a bar chart of likes for each post of a given user
class PostChartScreen extends StatefulWidget {
  final String username;

  // Constructor expects the username to fetch data for
  const PostChartScreen({super.key, required this.username});

  @override
  State<PostChartScreen> createState() => _PostChartScreenState();
}

class _PostChartScreenState extends State<PostChartScreen> {
  late Future<List<Post>> _postsFuture; // Holds the future that fetches posts

  @override
  void initState() {
    super.initState();
    // Fetch the posts using the given username when the widget is first built
    _postsFuture = fetchPosts(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Likes Recently",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: false,
      ),

      // FutureBuilder will wait for the API data and rebuild the UI accordingly
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // While the data is loading, show a loading spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // If an error occurs while fetching the data, show error message
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If data is successfully fetched, render the bar chart
          final posts = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildBarChart(posts), // Chart widget that shows likes/post
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:insta_stonks/models/models.dart';
import 'package:insta_stonks/services/services.dart';
import 'package:insta_stonks/services/fetch_posts_service.dart';
import 'package:insta_stonks/shared/shared.dart';

class PostChartScreen extends StatefulWidget {
  final String username;

  const PostChartScreen({super.key, required this.username});

  @override
  State<PostChartScreen> createState() => _PostChartScreenState();
}

class _PostChartScreenState extends State<PostChartScreen> {
  late Future<List<Post>> _postsFuture;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _postsFuture = ApiService.fetchPosts(widget.username);
      await _postsFuture; // Wait for the future to complete to catch any errors
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _fetchData)],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $_errorMessage'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchData,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              )
              : FutureBuilder<List<Post>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchData,
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  final posts = snapshot.data!;

                  if (posts.isEmpty) {
                    return const Center(
                      child: Text('No posts found for this username'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: buildBarChart(posts),
                  );
                },
              ),
    );
  }
}

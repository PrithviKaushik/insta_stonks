import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_stonks/services/services.dart'; // Updated import
import 'package:insta_stonks/models/models.dart';
import 'package:insta_stonks/shared/shared.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  String? _searchedUsername;
  Future<List<Post>>? _postsFuture;

  @override
  void initState() {
    super.initState();
    _checkFirstLoad();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkFirstLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final hasVisitedSearch = prefs.getBool('has_visited_search') ?? false;

    if (!hasVisitedSearch) {
      // Wait for the build method to complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUsernameDialog();
        // Mark that we've shown the dialog
        prefs.setBool('has_visited_search', true);
      });
    }
  }

  Future<void> _showUsernameDialog() async {
    final controller = TextEditingController();

    final entered = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UsernameDialog(controller: controller),
    );

    if (entered != null && entered.isNotEmpty) {
      setState(() {
        _searchController.text = entered;
        _searchedUsername = entered;
        _performSearch(entered);
      });
    }
  }

  Future<void> _performSearch(String username) async {
    if (username.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchedUsername = username;
    });

    try {
      // Updated to use the new ApiService class
      setState(() {
        _postsFuture = ApiService.fetchPosts(username);
      });

      // Wait for the fetch to complete to update loading state
      await _postsFuture;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _postsFuture = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching for $username: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter Instagram username',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchedUsername = null;
                      _postsFuture = null;
                    });
                  },
                ),
              ),
              onSubmitted: (value) => _performSearch(value),
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_searchedUsername != null && _postsFuture != null)
            Expanded(child: _buildPostChart())
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Search for an Instagram profile',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPostChart() {
    return FutureBuilder<List<Post>>(
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
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_searchedUsername != null) {
                      _performSearch(_searchedUsername!);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bar_chart_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No posts found for @${_searchedUsername}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }

        final posts = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '@$_searchedUsername',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recent Post Likes',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildBarChart(posts),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Post {
  final DateTime timestamp;
  final int likesCount;

  Post({required this.timestamp, required this.likesCount});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      // Parses ISO timestamp string to DateTime
      timestamp: DateTime.parse(json['timestamp']),
      // Handles both int and double likes_count safely
      likesCount: (json['likes_count'] as num).toInt(),
    );
  }
}

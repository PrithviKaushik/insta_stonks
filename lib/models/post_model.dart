class Post {
  final String id;
  final String caption;
  final int likesCount;
  final DateTime timestamp;
  final String imageUrl;
  final String shortcode;
  final int commentsCount;
  final List<String> hashtags;
  final String? videoUrl;

  Post({
    required this.id,
    required this.caption,
    required this.likesCount,
    required this.timestamp,
    required this.imageUrl,
    required this.shortcode,
    required this.commentsCount,
    required this.hashtags,
    this.videoUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String? ?? 'unknown_id',
      caption: json['caption'] as String? ?? 'No caption',
      likesCount: json['likes_count'] as int? ?? 0,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      imageUrl: json['image_url'] as String? ?? '',
      shortcode: json['shortcode'] as String? ?? '',
      commentsCount: json['comments_count'] as int? ?? 0,
      hashtags:
          (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      videoUrl: json['video_url'] as String?,
    );
  }

  String get formattedDate {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

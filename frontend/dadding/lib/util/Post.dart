class Post {
  final String id;
  final String authorId;
  final String content;
  final String title;
  final List<String> tags;
  final int commentCount;
  final DateTime createdAt;
  final List<String> images;

  const Post({
    required this.id,
    required this.authorId,
    required this.commentCount,
    required this.createdAt,
    required this.title,
    required this.content,
    required this.tags,
    required this.images,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      title: json['title'] as String,
      tags: List<String>.from(json['tags'] as List<dynamic>),
      commentCount: json['commentCount'] as int,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(json['createdAt']['_seconds'] * 1000),
      images: List<String>.from(json['images'] as List<dynamic>),
    );
  }

  static List<Post> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
  }
}
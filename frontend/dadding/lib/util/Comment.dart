class Comment {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Comment({
    required this.id, 
    required this.userId, 
    required this.content, 
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userUid'],
      content: json['content'],
      updatedAt: json['updatedAt'] == null
          ? null
          : json['updatedAt'] is String
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(json['updatedAt']['_seconds'] * 1000),
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(json['createdAt']['_seconds'] * 1000),
    );
  }
}
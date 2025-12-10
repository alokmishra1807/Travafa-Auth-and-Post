class PostModel {
  final String id;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  PostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? content,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'username': username,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };
}

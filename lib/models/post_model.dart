import 'message_model.dart';

class Post {
  final String username;
  final String id;
  final String title;
  final String content;
  final String userId;
  final String imageUrl;
  final bool isPublic;
  final bool isMe;
  List<Message> comments;
  final DateTime createdAt;
  final int viewCount;
  List viewers;

  Post({
    this.isMe = false,
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.imageUrl,
    required this.isPublic,
    required this.createdAt,
    required this.comments,
    required this.viewCount,
    required this.viewers,
    required this.username,
  });

  factory Post.fromJson(Map<String, Object?> json, {bool isMe = false}) {
    return Post(
      id: json["id"] as String,
      title: json["title"] as String,
      content: json["content"] as String,
      userId: json["userId"] as String,
      imageUrl: json["imageUrl"] as String,
      isPublic: json["isPublic"] as bool,
      createdAt: DateTime.parse(json["createdAt"] as String),
      isMe: isMe,
      username: json["username"] as String,
      viewCount: json["viewCount"] as int,
      viewers: json["viewers"]  != null ? json["viewers"] as List : [],
      comments: json["comments"] != null
          ? (json["comments"] as List)
              .map((item) => Message.fromJson(item as Map<String, Object?>))
              .toList()
          : [],
    );
  }

  Map<String, Object?> toJson() => {
    "username": username,
        "id": id,
        "title": title,
        "content": content,
        "userId": userId,
        "imageUrl": imageUrl,
        "isPublic": isPublic,
        "comments": comments.map((e) => e.toJson()).toList(),
        "createdAt": createdAt.toIso8601String(),
    "viewCount": viewCount,
    "viewers": viewers,
      };
}

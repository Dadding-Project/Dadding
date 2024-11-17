class User {
  final String id;
  final String displayName;
  final String profilePicture;
  final String email;
  final DateTime birthDate;
  final DateTime createdAt;
  final String gender;
  final String posts;
  final String tags;

  User({
    required this.id,
    required this.displayName,
    required this.profilePicture,
    required this.email,
    required this.birthDate,
    required this.createdAt,
    required this.gender,
    required this.posts,
    required this.tags,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      profilePicture: json['profilePicture'] as String,
      email: json['email'] as String,
      birthDate: json['birthDate'] is String
          ? DateTime.parse(json['birthDate'] as String)
          : DateTime.fromMillisecondsSinceEpoch(json['birthDate']['_seconds'] * 1000),
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(json['createdAt']['_seconds'] * 1000),
      gender: json['gender'] as String,
      posts: json['posts'] as String,
      tags: json['tags'] as String,
    );
  }

  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
  }

  static int calculateAge(String birth) {
    DateTime birthDate = DateTime.parse(birth.replaceAll('.', '-'));
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
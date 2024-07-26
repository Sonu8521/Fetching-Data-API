// lib/models/user.dart
class User {
  final int id;
  final String title;
  final String description;
  final double price;
  final String? thumbnail;

  User({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.thumbnail,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
    };
  }
}

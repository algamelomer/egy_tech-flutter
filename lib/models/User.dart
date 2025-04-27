class User {
  final int id;
  final String name;
  final String email;
  final String gender;
  final String? bio;
  final String profilePicture;
  final String? phone;
  final String? address;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    this.bio,
    required this.profilePicture,
    this.phone,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      bio: json['bio'],
      profilePicture: json['profile_picture'] ?? '',
      phone: json['phone'],
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
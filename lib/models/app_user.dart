class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.university,
  });

  final String id;
  final String fullName;
  final String email;
  final String role;
  final String university;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      fullName: (json['full_name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      role: (json['role'] ?? 'participant') as String,
      university: (json['university'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'university': university,
    };
  }
}

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.role,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely get data whether it's nested or flat, assuming standard patterns
    // Adjust logic based on actual API response
    final user = json['user'] ?? json;
    return UserModel(
      id: user['_id'] ?? user['id'] ?? '',
      email: user['email'] ?? '',
      role: user['role'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'role': role, 'token': token};
  }
}

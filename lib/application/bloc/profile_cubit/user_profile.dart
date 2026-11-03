import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.name,
    required this.userId,
    required this.phone,
    required this.email,
    this.avatarUrl,
  });

  final String name;
  final String userId;
  final String phone;
  final String email;
  final String? avatarUrl;

  UserProfile copyWith({
    String? name,
    String? userId,
    String? phone,
    String? email,
    String? avatarUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      userId: userId ?? this.userId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [name, userId, phone, email, avatarUrl];
}


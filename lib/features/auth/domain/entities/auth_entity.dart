import 'user_entity.dart';

class AuthEntity {
  final UserEntity user;
  final String token;

  const AuthEntity({
    required this.user,
    required this.token,
  });
}

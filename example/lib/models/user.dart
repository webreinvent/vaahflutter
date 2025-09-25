import 'package:vaahflutter/vaahflutter.dart';

class User implements VaahUser {
  const User({required this.id, this.email, this.username, this.name});

  @override
  final String id;

  @override
  final String? email;

  @override
  final String? username;

  @override
  final String? name;
}

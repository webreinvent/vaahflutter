import 'package:flutter/material.dart';

class User {
  final String firstName;
  final String? lastName;
  final List<String> permissions;

  const User({
    required this.firstName,
    this.lastName,
    required this.permissions,
  });
}

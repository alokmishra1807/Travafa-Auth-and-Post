import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String username;
  final double radius;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    required this.username,
    this.radius = 20,
    this.onTap,
  });

  String get _initial {
    if (username.isEmpty) return '?';
    return username.trim()[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      child: Text(
        _initial,
        style: TextStyle(
          fontSize: radius * 0.9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (onTap == null) return avatar;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: avatar,
    );
  }
}

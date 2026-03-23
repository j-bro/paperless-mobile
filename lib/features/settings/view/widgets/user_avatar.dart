import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String appUserId;
  final String displayName;

  const UserAvatar({
    super.key,
    required this.appUserId,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        Colors.primaries[appUserId.hashCode % Colors.primaries.length];
    final foregroundColor = backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    final initials = displayName
        .split(" ")
        .take(2)
        .map((e) => e.substring(0, 1))
        .map((e) => e.toUpperCase())
        .join("");
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: backgroundColor.shade900.withAlpha(102),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        child: Text(initials),
      ),
    );
  }
}

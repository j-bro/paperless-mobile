import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_avatar.dart';

class UserAccountListTile extends StatelessWidget {
  final String username;
  final String serverUrl;
  final String displayName;
  final Widget? trailing;
  final VoidCallback? onTap;
  const UserAccountListTile({
    super.key,
    required this.username,
    required this.serverUrl,
    required this.displayName,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appUserId = '$username@$serverUrl';
    return SizedBox(
      width: double.maxFinite,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
        title: Text(username),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (displayName.isNotEmpty) Text(displayName),
            Text(
              serverUrl.replaceFirst(RegExp(r'https?://'), ''),
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ],
        ),
        isThreeLine: displayName.isNotEmpty,
        leading: UserAvatar(appUserId: appUserId, displayName: displayName),
        trailing: trailing,
      ),
    );
  }
}

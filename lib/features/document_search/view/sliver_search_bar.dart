import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/document_search/view/document_search_bar.dart';
import 'package:paperless_mobile/features/settings/view/manage_accounts_dialog_content.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_avatar.dart';
import 'package:provider/provider.dart';

class SliverSearchBar extends StatelessWidget {
  final bool pinned;
  final String titleText;
  const SliverSearchBar({
    super.key,
    this.pinned = false,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    if (context.loggedInUser$.paperlessUser.canViewDocuments) {
      return const SliverAppBar(
        titleSpacing: 8,
        automaticallyImplyLeading: false,
        title: DocumentSearchBar(),
      );
    } else {
      return SliverAppBar(
        title: Text(titleText),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              padding: const EdgeInsets.all(6),
              icon: UserAvatar(account: context.loggedInUser$),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => Provider.value(
                    value: context.loggedInUser,
                    child: const ManageAccountsDialogContent(),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}

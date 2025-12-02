import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/core/store/slices/local_user_data.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/users/view/widgets/user_account_list_tile.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/add_account_route.dart';
import 'package:provider/provider.dart';

class ManageAccountsPage extends StatelessWidget {
  const ManageAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = context.select<LocalStore, Map<String, LocalUserData>>(
      (store) => store.state.localUserData,
    );
    final loggedInUserId = context.loggedInAppUserId$;
    // This is one of the few places where the currentLoggedInUser can be null
    // (exactly after loggin out as the current user to be precise).

    if (loggedInUserId == null) {
      return const SizedBox.shrink();
    }
    final userIds = accounts.keys;
    final otherAccountIds = userIds
        .whereNot((element) => element == loggedInUserId)
        .toList();
    final currentUser = context.loggedInUser$;
    return SimpleDialog(
      insetPadding: const EdgeInsets.all(24),
      contentPadding: const EdgeInsets.all(8),
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Align(alignment: Alignment.centerLeft, child: CloseButton()),
          Center(child: Text(S.of(context)!.accounts)),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      children: [
        Card(
          child: UserAccountListTile(
            account: currentUser,
            trailing: PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: ListTile(
                    title: Text(S.of(context)!.logout),
                    leading: const Icon(Icons.person_remove, color: Colors.red),
                  ),
                ),
              ],
              onSelected: (value) async {
                if (value == 0) {
                  Navigator.of(context).pop();
                  await context.read<AuthenticationCubit>().logout(true);
                }
              },
            ),
          ),
        ),
        Column(
          children: [
            for (int index = 0; index < otherAccountIds.length; index++)
              Builder(
                builder: (context) {
                  final user = accounts[otherAccountIds[index]]?.localUser;
                  if (user == null) {
                    return const SizedBox.shrink();
                  }
                  return UserAccountListTile(
                    account: user,
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 0,
                            child: ListTile(
                              title: Text(S.of(context)!.switchAccount),
                              leading: const Icon(Icons.switch_account_rounded),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              title: Text(S.of(context)!.remove),
                              leading: const Icon(
                                Icons.person_remove,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) async {
                        if (value == 0) {
                          // Switch
                          _onSwitchAccount(
                            context,
                            loggedInUserId,
                            otherAccountIds[index],
                          );
                        } else if (value == 1) {
                          await context
                              .read<AuthenticationCubit>()
                              .removeAccount(otherAccountIds[index]);
                        }
                      },
                    ),
                  );
                },
              ),
          ],
        ),
        const Divider(),
        ListTile(
          title: Text(S.of(context)!.addAccount),
          leading: const Icon(Icons.person_add),
          onTap: () {
            _onAddAccount(context, loggedInUserId);
          },
        ),
        //TODO: Implement permission/user settings at some point...
        // if (context.loggedInUser$.hasMultiUserSupport)
        //   ListTile(
        //     leading: const Icon(Icons.admin_panel_settings),
        //     title: Text(S.of(context)!.managePermissions),
        //   ),
      ],
    );
  }

  Future<void> _onAddAccount(BuildContext context, String currentUser) async {
    Navigator.of(context).pop();
    const AddAccountRoute().push<String>(context);
  }

  void _onSwitchAccount(
    BuildContext context,
    String currentUser,
    String newUser,
  ) async {
    if (currentUser == newUser) return;

    Navigator.of(context).pop();
    await context.read<AuthenticationCubit>().switchAccount(newUser);
  }
}

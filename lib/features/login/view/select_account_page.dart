import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/users/view/widgets/user_account_list_tile.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/auth_route.dart';

class SelectAccountPage extends StatelessWidget {
  const SelectAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(S.of(context)!.logInToExistingAccount),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(S.of(context)!.addAnotherAccount),
              onPressed: () {
                const AuthRoute().push(context);
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<LocalStore, LocalStoreState>(
        builder: (context, value) {
          final localAccounts = context.localUserData$;
          return ListView.builder(
            itemBuilder: (context, index) {
              final userId = localAccounts.keys.elementAt(index);
              final account = localAccounts.values.elementAt(index);
              return Card(
                child: UserAccountListTile(
                  serverUrl: account.serverUrl,
                  username: account.username,
                  displayName: account.displayName,
                  onTap: () {
                    context.read<AuthenticationCubit>().switchAccount(userId);
                  },
                  trailing: IconButton(
                    tooltip: S.of(context)!.remove,
                    icon: Icon(Icons.person_remove_outlined),
                    onPressed: () {
                      if (localAccounts.length > 1) {
                        context.read<AuthenticationCubit>().removeAccount(
                          userId,
                        );
                      }
                    },
                  ),
                ),
              );
            },
            itemCount: localAccounts.length,
          );
        },
      ),
    );
  }
}

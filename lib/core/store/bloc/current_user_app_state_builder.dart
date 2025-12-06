import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/core/store/slices/local_user_app_state.dart';

class CurrentUserAppStateBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, LocalUserAppState state) builder;
  const CurrentUserAppStateBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalStore, LocalStoreState>(
      builder: (context, state) {
        if (state.loggedInAppUserId == null) {
          throw AssertionError(
            'No user is currently logged in. This should never happen.',
          );
        }
        final userAppState =
            state.localUserData[state.loggedInAppUserId!]!.appState!;
        return builder(context, userAppState);
      },
    );
  }
}

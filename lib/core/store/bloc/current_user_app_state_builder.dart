import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/core/store/slices/local_user_data.dart';

class CurrentUserAppDataBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, LocalUserData state) builder;
  const CurrentUserAppDataBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalStore, LocalStoreState>(
      buildWhen: (previous, current) =>
          previous.localUserData[previous.loggedInAppUserId] !=
          current.localUserData[current.loggedInAppUserId],
      builder: (context, state) {
        if (state.loggedInAppUserId == null) {
          throw AssertionError(
            'No user is currently logged in. This should never happen.',
          );
        }
        final userAppState = state.localUserData[state.loggedInAppUserId!]!;
        return builder(context, userAppState);
      },
    );
  }
}

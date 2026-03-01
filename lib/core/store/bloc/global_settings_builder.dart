import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/core/store/slices/global_settings.dart';

class GlobalSettingsBuilder extends StatelessWidget {
  final Widget Function(BuildContext, GlobalSettings) builder;
  const GlobalSettingsBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalStore, LocalStoreState>(
      buildWhen: (previous, current) =>
          previous.globalSettings != current.globalSettings,
      builder: (context, state) {
        return builder(context, state.globalSettings);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/core/store/slices/global_settings.dart';

class GlobalSettingsBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, GlobalSettings settings) builder;
  const GlobalSettingsBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalStore, LocalStoreState>(
      builder: (context, value) {
        final settings = value.globalSettings;
        return builder(context, settings);
      },
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/local_store.dart';

class HintStateBuilder extends StatelessWidget {
  final String listenKey;
  final Widget Function(
    BuildContext context,
    bool acknowledged,
    void Function() acknowledge,
  )
  builder;
  const HintStateBuilder({
    super.key,
    required this.builder,
    required this.listenKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalStore, LocalStoreState>(
      buildWhen: (previous, current) {
        return !previous.readHints.equals(current.readHints);
      },
      builder: (context, state) {
        final acknowledged = state.readHints.contains(listenKey);
        void acknowledge() {
          if (!acknowledged) {
            debugPrint("Acknowledging hint: $listenKey");
            context.localStore.acknowledgeHint(listenKey);
          }
        }

        return builder(context, acknowledged, acknowledge);
      },
    );
  }
}

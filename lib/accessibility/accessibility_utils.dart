import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';

extension AccessibleHero on Hero {
  Widget accessible() {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        return HeroMode(
          enabled:
              WidgetsBinding.instance.disableAnimations ||
              !settings.disableAnimations,
          child: this,
        );
      },
    );
    // bool shouldDisableAnimations = WidgetsBinding.instance.disableAnimations ||
    //     Hive.globalSettingsBox.getValue()!.disableAnimations;
    // return _AccessibilityAwareObserverWidget(
    //   accessibilityAwareBuilder: (context, accessibilityFeatures) {
    //     return HeroMode(
    //       enabled: !accessibilityFeatures.disableAnimations,
    //       child: this,
    //     );
    //   },
    // );
  }
}

class _AccessibilityAwareObserverWidget extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    AccessibilityFeatures accessibilityFeatures,
  )
  accessibilityAwareBuilder;
  const _AccessibilityAwareObserverWidget({
    required this.accessibilityAwareBuilder,
  });

  @override
  State<_AccessibilityAwareObserverWidget> createState() =>
      _AccessibilityAwareObserverWidgetState();
}

class _AccessibilityAwareObserverWidgetState
    extends State<_AccessibilityAwareObserverWidget>
    with WidgetsBindingObserver {
  late final AccessibilityFeatures _accessibilityFeatures;

  @override
  void initState() {
    super.initState();
    _accessibilityFeatures = WidgetsBinding.instance.accessibilityFeatures;
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    setState(() {
      _accessibilityFeatures = WidgetsBinding.instance.accessibilityFeatures;
    });
    print("Accessibility features changed");
  }

  @override
  Widget build(BuildContext context) {
    return widget.accessibilityAwareBuilder(context, _accessibilityFeatures);
  }
}

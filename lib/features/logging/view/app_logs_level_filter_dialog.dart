import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/features/logging/view/app_logs_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AppLogsLevelFilterDialog extends StatefulWidget {
  final Set<Level> initialValue;
  const AppLogsLevelFilterDialog({super.key, required this.initialValue});

  @override
  State<AppLogsLevelFilterDialog> createState() =>
      _AppLogsLevelFilterDialogState();
}

class _AppLogsLevelFilterDialogState extends State<AppLogsLevelFilterDialog> {
  late Set<Level> _selectedLevels;

  @override
  void initState() {
    super.initState();
    _selectedLevels = Set.from(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context)!.selectLogLevels),
      actions: [
        DialogCancelButton(onTap: () => context.pop()),
        DialogConfirmButton<Set<Level>>(
          onPressed: () {
            context.pop(_selectedLevels);
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Level.error, Level.warning, Level.info, Level.debug, Level.trace]
            .map(
              (level) => CheckboxListTile(
                value: _selectedLevels.contains(level),
                title: Row(
                  spacing: 8,
                  children: [
                    Icon(
                      mapLevelToIcon(level),
                      color: mapLevelToColor(context, level),
                    ),
                    Text(
                      '${level.name.substring(0, 1).toUpperCase()}${level.name.substring(1)}',
                      style: TextStyle(color: mapLevelToColor(context, level)),
                    ),
                  ],
                ),

                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedLevels.add(level);
                    } else {
                      _selectedLevels.remove(level);
                    }
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

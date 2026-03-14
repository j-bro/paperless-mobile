import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/widgets/offline_widget.dart';
import 'package:paperless_mobile/features/labels/custom_fields/view/widgets/custom_field_list_item.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class CustomFieldTabView extends StatelessWidget {
  final Query<List<CustomField>> query;
  final void Function(CustomField) onEdit;
  final bool canEdit;
  final void Function() onAddNew;
  final bool canAddNew;

  /// Shown on empty State
  final String emptyStateDescription;
  final String emptyStateActionButtonLabel;

  const CustomFieldTabView({
    super.key,
    required this.onEdit,
    required this.emptyStateDescription,
    required this.onAddNew,
    required this.emptyStateActionButtonLabel,
    required this.query,
    required this.canEdit,
    required this.canAddNew,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, connectivityState) {
        if (!connectivityState.isConnected) {
          return const SliverFillRemaining(child: OfflineWidget());
        }
        return QueryBuilder(
          query: query,
          builder: (context, state) {
            if (state is QueryLoading && state.data == null) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.isError) {
              return SliverFillRemaining(
                child: Center(
                  child: Text(
                    S.of(context)!.couldNotLoadCustomField,
                    textAlign: TextAlign.center,
                  ).padded(),
                ),
              );
            }
            final fields = state.data ?? [];
            final sortedFields = fields.toList()
              ..sort((a, b) => a.name.compareTo(b.name));
            if (fields.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(emptyStateDescription, textAlign: TextAlign.center),
                      TextButton(
                        onPressed: canAddNew ? onAddNew : null,
                        child: Text(emptyStateActionButtonLabel),
                      ),
                    ].padded(),
                  ),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final field = sortedFields.elementAt(index);
                return CustomFieldListItem(
                  field: field,
                  onEdit: canEdit ? () => onEdit(field) : null,
                );
              }, childCount: sortedFields.length),
            );
          },
        );
      },
    );
  }
}

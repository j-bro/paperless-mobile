import 'package:animations/animations.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/label_list_extension.dart';
import 'package:paperless_mobile/features/labels/view/widgets/multi_label_form.dart';
import 'package:paperless_mobile/features/labels/view/widgets/query_label_option_chip.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class MultiLabelFormField<T extends Label> extends StatelessWidget {
  final Widget prefixIcon;
  final Query<List<T>> query;
  final IdQueryParameter? initialValue;
  final String name;
  final String labelText;
  final FormFieldValidator? validator;
  final void Function(IdQueryParameter?)? onChanged;
  final bool allowExclude;

  const MultiLabelFormField({
    super.key,
    required this.name,
    required this.query,
    required this.labelText,
    required this.prefixIcon,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.allowExclude = true,
  });

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: query,
      builder: (context, state) {
        final options = state.data?.toIdMap() ?? {};
        final enabled = options.isNotEmpty;

        return FormBuilderField<IdQueryParameter>(
          name: name,
          initialValue: initialValue,
          onChanged: onChanged,
          enabled: enabled,
          builder: (field) {
            final children = _generateOptions(
              context,
              field.value,
              field,
              options,
            );

            return Column(
              children: [
                OpenContainer<IdQueryParameter>(
                  middleColor: Theme.of(context).colorScheme.surface,
                  closedColor: Theme.of(context).colorScheme.surface,
                  openColor: Theme.of(context).colorScheme.surface,
                  closedShape: InputBorder.none,
                  openElevation: 0,
                  closedElevation: 0,
                  tappable: enabled,
                  closedBuilder: (context, openForm) {
                    if (field.value is! AnyAssignedIdQueryParameter &&
                        field.value is! NotAssignedIdQueryParameter) {
                      return _buildMultiSelectionInput(
                        context,
                        enabled: enabled,
                        currentValue: field.value ?? IdQueryParameter.unset(),
                        children: children.toList(),
                        openForm: openForm,
                      );
                    }
                    return _buildAssignmentOptionInput(
                      context,
                      openForm,
                      enabled,
                      field,
                    );
                  },
                  openBuilder: (context, closeForm) => MultiLabelForm<T>(
                    leadingIcon: prefixIcon,
                    options: options,
                    onSubmit: closeForm,
                    initialValue: field.value ?? const IdQueryParameter.unset(),
                    allowExclude: allowExclude,
                  ),
                  onClosed: (data) {
                    if (data != null) {
                      field.didChange(data);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Iterable<Widget> _generateOptions(
    BuildContext context,
    IdQueryParameter? query,
    FormFieldState<IdQueryParameter?> field,
    Map<int, T> options,
  ) sync* {
    assert(
      query is! SingleIdQueryParameter,
      'SingleIdQueryParameter is not supported in multi-selection mode',
    );
    assert(
      query is! AnyAssignedIdQueryParameter &&
          query is! NotAssignedIdQueryParameter,
      'AnyAssignedIdQueryParameter and NotAssignedIdQueryParameter should be handled separately',
    );

    if (query == null) {
      yield Container();
    } else {
      final widgets = switch (query) {
        IncludeIdsQueryParameter(ids: final ids) => [
          for (var i in ids)
            _buildIncludedLabelWidget(context, i, field, query, options),
        ],
        ExcludeIdsQueryParameter(ids: final ids) => [
          for (var id in ids)
            _buildExcludedLabelWidget(context, id, field, query, options),
        ],
        _ => [],
      };
      for (var child in widgets) {
        yield child;
      }
    }
  }

  Widget _buildIncludedLabelWidget(
    BuildContext context,
    int id,
    FormFieldState<IdQueryParameter?> field,
    IdQueryParameter query,
    Map<int, T> options,
  ) {
    final label = options[id];

    return LabelQueryOptionChip(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      onDeleted: () {
        final newValue = switch (query) {
          IncludeIdsQueryParameter(ids: final ids) => IdQueryParameter.include(
            ids: ids.where((element) => element != id).toList(),
          ),
          _ => query,
        };
        field.didChange(newValue);
      },
      exclude: false,
      labelText: label?.name ?? '?',
    );
  }

  Widget _buildExcludedLabelWidget(
    BuildContext context,
    int id,
    FormFieldState<IdQueryParameter?> field,
    IdQueryParameter query,
    Map<int, T> options,
  ) {
    final label = options[id];

    return LabelQueryOptionChip(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      onDeleted: () {
        final newValue = switch (query) {
          ExcludeIdsQueryParameter(ids: final ids) => IdQueryParameter.exclude(
            ids: ids.where((element) => element != id).toList(),
          ),
          _ => query,
        };
        field.didChange(newValue);
      },
      exclude: true,
      labelText: label?.name ?? '?',
    );
  }

  Widget _buildAssignmentOptionInput(
    BuildContext context,
    VoidCallback openForm,
    bool enabled,
    FormFieldState<IdQueryParameter> field,
  ) {
    final text = switch (field.value) {
      NotAssignedIdQueryParameter() => S.of(context)!.notAssigned,
      AnyAssignedIdQueryParameter() => S.of(context)!.anyAssigned,
      _ => '',
    };
    final controller = TextEditingController(text: text);

    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: TextField(
        controller: controller,
        onTap: openForm,
        readOnly: true,
        enabled: enabled,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          labelText: labelText,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () =>
                      field.didChange(const IdQueryParameter.unset()),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildMultiSelectionInput(
    BuildContext context, {
    required List<Widget> children,
    required bool enabled,
    required VoidCallback openForm,
    required IdQueryParameter currentValue,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: GestureDetector(
        onTap: openForm,
        child: InputDecorator(
          isEmpty: children.isEmpty,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            prefixIcon: prefixIcon,
            enabled: enabled,
            labelText: labelText,
          ),
          child: SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 4),
              itemBuilder: (context, index) => children[index],
              itemCount: children.length,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/label_list_extension.dart';
import 'package:paperless_mobile/core/repository/tag_repository.dart';
import 'package:provider/provider.dart';

class DocumentTypeWidget extends StatelessWidget {
  final int? id;
  final bool isClickable;
  final TextStyle? textStyle;
  final void Function(int? id)? onSelected;
  const DocumentTypeWidget({
    super.key,
    required this.id,
    this.isClickable = true,
    this.textStyle,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: context.read<TagRepository>().getAllQuery(),
      builder: (context, state) => AbsorbPointer(
        absorbing: !isClickable,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => onSelected?.call(id),
            child: Text(
              state.data?.toIdMap()[id]?.name ?? "-",
              style: (textStyle ?? Theme.of(context).textTheme.bodyMedium)
                  ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';

class DocumentDetailsQueryBuilder extends StatelessWidget {
  final int id;
  final QueryBuilderCallback<QueryState<Document>> builder;
  const DocumentDetailsQueryBuilder({
    super.key,
    required this.id,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: context.documentRepository.getDocumentQuery(id),
      builder: (context, state) {
        return builder(context, state);
      },
    );
  }
}

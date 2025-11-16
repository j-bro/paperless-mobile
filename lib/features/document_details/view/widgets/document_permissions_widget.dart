import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_mobile/core/repository/user_repository.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/details_item.dart';

class DocumentPermissionsWidget extends StatefulWidget {
  final Document document;
  const DocumentPermissionsWidget({super.key, required this.document});

  @override
  State<DocumentPermissionsWidget> createState() =>
      _DocumentPermissionsWidgetState();
}

class _DocumentPermissionsWidgetState extends State<DocumentPermissionsWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: [
        if (widget.document.owner != null)
          QueryBuilder(
            query: context.read<UserRepository>().getByIdQuery(
              widget.document.owner!,
            ),
            builder: (context, state) {
              return DetailsItem.text(
                state.data!.username,
                label: 'Owner', //TODO: INTL
                context: context,
              );
            },
          ),
      ],
    );
  }
}

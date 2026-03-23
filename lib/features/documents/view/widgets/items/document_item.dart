import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/models/document.dart';

abstract class DocumentItem extends StatelessWidget {
  final Document document;
  final void Function(Document)? onTap;
  final void Function(Document)? onSelected;
  final bool isSelected;
  final bool isSelectionActive;
  final bool isLabelClickable;
  final bool isEnabled;
  final String? heroTagPrefix;
  final void Function(int tagId)? onTagSelected;
  final void Function(int? correspondentId)? onCorrespondentSelected;
  final void Function(int? documentTypeId)? onDocumentTypeSelected;
  final void Function(int? id)? onStoragePathSelected;

  const DocumentItem({
    super.key,
    required this.document,
    this.onTap,
    this.onSelected,
    required this.isSelected,
    required this.isSelectionActive,
    required this.isLabelClickable,
    this.onTagSelected,
    this.onCorrespondentSelected,
    this.onDocumentTypeSelected,
    this.onStoragePathSelected,
    this.heroTagPrefix,
    this.isEnabled = true,
  });
}

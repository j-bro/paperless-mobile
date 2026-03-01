import 'package:flutter/material.dart';

/// A fallback viewer displayed when the document's MIME type is not supported
/// for in-app viewing.
class UnsupportedDocumentViewer extends StatelessWidget {
  final String mimeType;
  final String? title;
  final bool showAppBar;

  const UnsupportedDocumentViewer({
    super.key,
    required this.mimeType,
    this.title,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(title: title != null ? Text(title!) : null)
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.insert_drive_file_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Preview not available',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Documents of type "$mimeType" cannot be previewed in the app.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

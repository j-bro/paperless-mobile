import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A viewer for plain text documents.
///
/// Decodes the raw bytes as UTF-8 and renders the text in a scrollable view
/// with a monospaced font for readability.
class TextDocumentViewer extends StatelessWidget {
  final Uint8List bytes;
  final String? title;
  final bool showAppBar;

  const TextDocumentViewer({
    super.key,
    required this.bytes,
    this.title,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final text = utf8.decode(bytes, allowMalformed: true);

    return Scaffold(
      appBar: showAppBar
          ? AppBar(title: title != null ? Text(title!) : null)
          : null,
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SelectableText(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A viewer for image documents (PNG, JPEG, GIF, TIFF, BMP, WebP).
///
/// Supports pinch-to-zoom and panning via [InteractiveViewer].
class ImageDocumentViewer extends StatelessWidget {
  final Uint8List bytes;
  final String? title;
  final bool showAppBar;

  const ImageDocumentViewer({
    super.key,
    required this.bytes,
    this.title,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(title: title != null ? Text(title!) : null)
          : null,
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        child: Center(
          child: Image.memory(
            bytes,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Could not display image.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(error.toString()),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

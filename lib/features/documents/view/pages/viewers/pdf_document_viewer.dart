import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:pdfx/pdfx.dart';

/// A viewer for PDF documents.
///
/// Displays PDF pages with navigation controls (previous/next page)
/// and a page number indicator.
class PdfDocumentViewer extends StatefulWidget {
  final Uint8List bytes;
  final String? title;
  final bool showAppBar;
  final bool showControls;

  const PdfDocumentViewer({
    super.key,
    required this.bytes,
    this.title,
    this.showAppBar = true,
    this.showControls = true,
  });

  @override
  State<PdfDocumentViewer> createState() => _PdfDocumentViewerState();
}

class _PdfDocumentViewerState extends State<PdfDocumentViewer> {
  late final PdfController _controller;
  int _currentPage = 1;
  int? _totalPages;

  @override
  void initState() {
    super.initState();
    _controller = PdfController(document: PdfDocument.openData(widget.bytes));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageTransitionDuration = MediaQuery.disableAnimationsOf(context)
        ? 0.milliseconds
        : 100.milliseconds;
    final canGoToNextPage = _totalPages != null && _currentPage < _totalPages!;
    final canGoToPreviousPage =
        _controller.pagesCount != null && _currentPage > 1;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(title: widget.title != null ? Text(widget.title!) : null)
          : null,
      bottomNavigationBar: _buildControls(
        canGoToPreviousPage,
        pageTransitionDuration,
        canGoToNextPage,
      ),
      body: PdfDocumentPageView(
        bytes: widget.bytes,
        onInitialized: (pagesCount) {
          setState(() {
            _totalPages = pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
    );
  }

  Widget? _buildControls(
    bool canGoToPreviousPage,
    Duration pageTransitionDuration,
    bool canGoToNextPage,
  ) {
    if (!widget.showControls) {
      return null;
    }
    return BottomAppBar(
      child: Row(
        children: [
          Flexible(
            child: Row(
              children: [
                IconButton.filled(
                  onPressed: canGoToPreviousPage
                      ? () async {
                          await _controller.previousPage(
                            duration: pageTransitionDuration,
                            curve: Curves.easeOut,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_left),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: canGoToNextPage
                      ? () async {
                          await _controller.nextPage(
                            duration: pageTransitionDuration,
                            curve: Curves.easeOut,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            ),
          ),
          PdfPageNumber(
            controller: _controller,
            builder: (context, loadingState, page, pagesCount) {
              return Text(
                pagesCount == null ? "-/-" : "$page/$pagesCount",
                style: Theme.of(context).textTheme.titleMedium,
              ).padded();
            },
          ),
        ],
      ),
    );
  }
}

/// A standalone PDF page view widget that renders PDF pages and reports
/// page changes and initialization events.
class PdfDocumentPageView extends StatefulWidget {
  final Uint8List bytes;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onInitialized;

  const PdfDocumentPageView({
    super.key,
    required this.bytes,
    required this.onPageChanged,
    required this.onInitialized,
  });

  @override
  State<PdfDocumentPageView> createState() => _PdfDocumentPageViewState();
}

class _PdfDocumentPageViewState extends State<PdfDocumentPageView> {
  late final PdfController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfController(document: PdfDocument.openData(widget.bytes));
  }

  @override
  Widget build(BuildContext context) {
    return PdfView(
      controller: _controller,
      onDocumentLoaded: (document) {
        if (mounted) {
          widget.onInitialized(document.pagesCount);
        }
      },
      onPageChanged: (page) {
        if (mounted) {
          widget.onPageChanged(page);
        }
      },
    );
  }
}

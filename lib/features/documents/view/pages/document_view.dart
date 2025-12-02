import 'dart:async';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:pdfx/pdfx.dart';

class DocumentView extends StatelessWidget {
  final int? documentId;
  final Future<Uint8List>? bytes;
  final String? title;
  final bool showAppBar;
  final bool showControls;

  const DocumentView({
    super.key,
    this.documentId,
    this.bytes,
    this.showAppBar = true,
    this.showControls = true,
    this.title,
  }) : assert(documentId != null || bytes != null);

  @override
  Widget build(BuildContext context) {
    if (documentId != null) {
      return QueryBuilder(
        query: context.documentRepository.downloadDocumentQuery(
          documentId!,
          original: false,
        ),
        builder: (context, state) {
          if (state.isLoading) {
            return _buildLoadingState();
          }
          if (state.isError || state.data == null) {
            return Center(
              child: Text(S.of(context)!.couldNotLoadDocumentPreview),
            );
          }

          return _DocumentView(
            bytes: state.data!,
            title: title,
            showAppBar: showAppBar,
            showControls: showControls,
          );
        },
      );
    }

    return FutureBuilder(
      future: bytes,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingState();
        }
        return _DocumentView(
          bytes: snapshot.data!,
          title: title,
          showAppBar: showAppBar,
          showControls: showControls,
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(child: CircularProgressIndicator());
  }
}

class _DocumentView extends StatefulWidget {
  final Uint8List bytes;
  final String? title;
  final bool showAppBar;
  final bool showControls;

  const _DocumentView({
    required this.bytes,
    this.showAppBar = true,
    this.showControls = true,
    this.title,
  });

  @override
  State<_DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<_DocumentView> {
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
      body: LoadedPdfView(
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
              if (loadingState != PdfLoadingState.success) {
                return const Text("-/-");
              }
              return Text(
                "$page/$pagesCount",
                style: Theme.of(context).textTheme.titleMedium,
              ).padded();
            },
          ),
        ],
      ),
    );
  }
}

class LoadedPdfView extends StatefulWidget {
  final Uint8List bytes;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onInitialized;
  const LoadedPdfView({
    super.key,
    required this.bytes,
    required this.onPageChanged,
    required this.onInitialized,
  });

  @override
  State<LoadedPdfView> createState() => _LoadedPdfViewState();
}

class _LoadedPdfViewState extends State<LoadedPdfView> {
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

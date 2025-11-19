import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

mixin DocumentPagingViewMixin<
  T extends StatefulWidget,
>
    on State<T> {
  ScrollController get pagingScrollController;

  @override
  void initState() {
    super.initState();
    pagingScrollController.addListener(shouldLoadMoreDocumentsListener);
  }

  @override
  void dispose() {
    pagingScrollController.removeListener(shouldLoadMoreDocumentsListener);
    super.dispose();
  }

  void shouldLoadMoreDocumentsListener({
    required Future<void> Function() loadMore,
    required bool isLoading,
    required bool isLastPageLoaded,
  }) async {
    if (shouldLoadMoreDocuments(isLoading, isLastPageLoaded)) {
      try {
        await loadMore();
      } on PaperlessApiException catch (error, stackTrace) {
        if (mounted) showErrorMessage(context, error, stackTrace);
      }
    }
  }

  bool shouldLoadMoreDocuments(bool isLoading, bool isLastPageLoaded) {
    return pagingScrollController.position.maxScrollExtent != 0 &&
        !isLoading &&
        !isLastPageLoaded &&
        pagingScrollController.offset >=
            pagingScrollController.position.maxScrollExtent * 0.75;
  }
}

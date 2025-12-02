import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/translation/error_code_localization_mapper.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SimpleQueryBuilder<T> extends StatelessWidget {
  final Cacheable<QueryStatus<T>> query;
  final Widget Function(BuildContext context, T data) builder;
  final WidgetBuilder loadingBuilder;
  final void Function(BuildContext context, dynamic error)? onError;
  final void Function(BuildContext context, T data)? onSuccess;
  final WidgetBuilder errorBuilder;
  final ErrorCode? _errorCode;
  final String? _errorMessage;

  const SimpleQueryBuilder({
    super.key,
    required this.query,
    required this.builder,
    this.loadingBuilder = _defaultLoadingBuilder,
    this.errorBuilder = _defaultErrorBuilder,
    ErrorCode? errorCode,
    String? errorMessage,
    this.onError,
    this.onSuccess,
  }) : _errorCode = errorCode,
       _errorMessage = errorMessage,
       assert(
         (errorCode != null) != (errorMessage != null),
         'errorCode and errorMessage are mutually exclusive',
       );

  static Widget _defaultLoadingBuilder(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  static Widget _defaultErrorBuilder(BuildContext context) {
    return Center(child: Text(S.of(context)!.anUnknownErrorOccurred));
  }

  @override
  Widget build(BuildContext context) {
    return QueryConsumer(
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (state) {
        if (state.isError) {
          onError?.call(context, state.error);
        }
        if (state.isSuccess) {
          onSuccess?.call(context, state.data as T);
        }
      },
      query: query,
      builder: (context, state) {
        if (state.isLoading) {
          return loadingBuilder(context);
        }
        if (state.isError) {
          if (_errorCode != null || _errorMessage != null) {
            return Center(
              child: Text(
                _errorMessage ?? translateError(context, _errorCode!),
                textAlign: TextAlign.center,
              ),
            );
          }

          return errorBuilder(context);
        }
        return builder(context, state.data as T);
      },
    );
  }
}

import 'dart:async';

import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:rxdart/subjects.dart';

typedef DocumentChangedCallback = void Function(Document document);

class DocumentChangedNotifier {
  final Subject<Document> _updated = PublishSubject();
  final Subject<Document> _deleted = PublishSubject();

  final Map<dynamic, List<StreamSubscription>> _subscribers = {};

  Stream<Document> get $updated => _updated.asBroadcastStream();

  Stream<Document> get $deleted => _deleted.asBroadcastStream();

  void notifyUpdated(Document updated) {
    _updated.add(updated);
  }

  void notifyDeleted(Document deleted) {
    _deleted.add(deleted);
  }

  void addListener(
    Object subscriber, {
    DocumentChangedCallback? onUpdated,
    DocumentChangedCallback? onDeleted,
    Iterable<int>? ids,
  }) {
    _subscribers.putIfAbsent(
      subscriber,
      () => [
        _updated.where((doc) => ids?.contains(doc.id) ?? true).listen((value) {
          onUpdated?.call(value);
        }),
        _deleted.where((doc) => ids?.contains(doc.id) ?? true).listen((value) {
          onDeleted?.call(value);
        }),
      ],
    );
  }

  void removeListener(Object subscriber) {
    _subscribers[subscriber]?.forEach((element) {
      element.cancel();
    });
  }

  void close() {
    _updated.close();
    _deleted.close();
  }
}

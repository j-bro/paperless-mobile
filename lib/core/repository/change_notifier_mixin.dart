/// A mixin that provides a simple listener-based change notification mechanism.
///
/// Classes that mix this in can notify registered listeners whenever their data
/// changes (e.g. after a successful create, update, or delete). Dependents can
/// register via [addOnChangeListener] to react to those changes — for example
/// by invalidating their own cached queries.

enum ChangeType { create, update, delete }

mixin ChangeNotifierMixin {
  final Set<void Function(ChangeType change)> _onChangeListeners = {};

  void addOnChangeListener(void Function(ChangeType change) listener) {
    _onChangeListeners.add(listener);
  }

  void removeOnChangeListener(void Function(ChangeType change) listener) {
    _onChangeListeners.remove(listener);
  }

  void notifyChangeListeners(ChangeType change) {
    for (final listener in _onChangeListeners) {
      listener(change);
    }
  }
}

/// A mixin that provides a simple listener-based change notification mechanism.
///
/// Classes that mix this in can notify registered listeners whenever their data
/// changes (e.g. after a successful create, update, or delete). Dependents can
/// register via [addOnChangeListener] to react to those changes — for example
/// by invalidating their own cached queries.
mixin ChangeNotifierMixin {
  final Set<void Function()> _onChangeListeners = {};

  void addOnChangeListener(void Function() listener) {
    _onChangeListeners.add(listener);
  }

  void removeOnChangeListener(void Function() listener) {
    _onChangeListeners.remove(listener);
  }

  void notifyChangeListeners() {
    for (final listener in _onChangeListeners) {
      listener();
    }
  }
}

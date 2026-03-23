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

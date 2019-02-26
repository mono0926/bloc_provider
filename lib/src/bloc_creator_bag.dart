import 'package:flutter/widgets.dart';

/// A bag for advanced requirements.
class BlocCreatorBag {
  VoidCallback _onDisposed;

  // ignore: use_setters_to_change_properties
  /// Register callbacks if needed.
  ///
  /// [onDisposed] is called when the inner State is disposed.
  void register({VoidCallback onDisposed}) {
    _onDisposed = onDisposed;
  }

  VoidCallback get onDisposed => _onDisposed;
}

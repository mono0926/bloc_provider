import 'package:flutter/widgets.dart';

/// A bag for advanced requirements.
class BlocCreatorBag {
  VoidCallback? _onDisposed;

  /// Register callbacks if needed.
  ///
  /// [onDisposed] is called when the inner State is disposed.
  // ignore: use_setters_to_change_properties
  void register({VoidCallback? onDisposed}) {
    _onDisposed = onDisposed;
  }

  VoidCallback? get onDisposed => _onDisposed;
}

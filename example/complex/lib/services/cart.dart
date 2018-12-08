import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:meta/meta.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

// TODO: 他にもつける
@immutable
class CartService {
  final List<CartItem> _items = <CartItem>[];

  final Set<VoidCallback> _listeners = Set();

  CartService();

  int get itemCount => _items.fold(0, (sum, el) => sum + el.count);

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  void add(Product product, [int count = 1]) {
    _updateCount(product, count);
  }

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void remove(Product product, [int count = 1]) {
    _updateCount(product, -count);
  }

  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  @override
  String toString() => '$items';

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void _updateCount(Product product, int difference) {
    if (difference == 0) {
      return;
    }
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (product == item.product) {
        final newCount = item.count + difference;
        if (newCount <= 0) {
          _items.removeAt(i);
          _notifyListeners();
          return;
        }
        _items[i] = CartItem(newCount, item.product);
        _notifyListeners();
        return;
      }
    }
    if (difference < 0) {
      return;
    }
    _items.add(CartItem(max(difference, 0), product));
    _notifyListeners();
  }
}

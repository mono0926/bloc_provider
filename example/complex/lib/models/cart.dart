import 'dart:collection';
import 'dart:math';

import 'cart_item.dart';
import 'product.dart';

class Cart {
  final List<CartItem> _items = <CartItem>[];

  Cart();

  Cart.clone(Cart cart) {
    _items.addAll(cart._items);
  }

  Cart.sample(Iterable<Product> products) {
    _items.addAll(products.take(3).map((product) => CartItem(1, product)));
  }

  int get itemCount => _items.fold(0, (sum, el) => sum + el.count);
  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  void add(Product product, [int count = 1]) {
    _updateCount(product, count);
  }

  void remove(Product product, [int count = 1]) {
    _updateCount(product, -count);
  }

  @override
  String toString() => '$items';

  void _updateCount(Product product, int difference) {
    if (difference == 0) return;
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (product == item.product) {
        final newCount = item.count + difference;
        if (newCount <= 0) {
          _items.removeAt(i);
          return;
        }
        _items[i] = CartItem(newCount, item.product);
        return;
      }
    }
    if (difference < 0) return;
    _items.add(CartItem(max(difference, 0), product));
  }
}

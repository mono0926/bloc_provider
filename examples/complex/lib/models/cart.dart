import 'dart:collection';

import 'package:meta/meta.dart';

import 'cart_item.dart';

@immutable
class Cart {
  static const List<CartItem> _items = <CartItem>[];

  const Cart();

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  @override
  String toString() => '$items';
}

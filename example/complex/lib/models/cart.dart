import 'dart:collection';

import 'package:meta/meta.dart';

import 'cart_item.dart';

@immutable
class Cart {
  final List<CartItem> _items = <CartItem>[];

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  @override
  String toString() => '$items';
}

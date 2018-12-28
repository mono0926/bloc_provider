import 'dart:async';

import 'package:bloc_complex/models/cart_item.dart';
import 'package:bloc_complex/models/product.dart';
import 'package:bloc_complex/services/cart.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class CartAddition {
  final Product product;
  final int count;

  const CartAddition(this.product, {this.count = 1});
}

@immutable
class CartBloc implements Bloc {
  static const _cart = CartService();

  final _items = BehaviorSubject<List<CartItem>>(seedValue: []);
  final _itemCount = BehaviorSubject<int>(seedValue: 0);
  final _cartAdditionController = StreamController<CartAddition>();

  CartBloc() {
    _cartAdditionController.stream.listen(_handleAddition);
  }

  Sink<CartAddition> get cartAddition => _cartAdditionController.sink;

  ValueObservable<int> get itemCount =>
      _itemCount.distinct().shareValue(seedValue: 0);

  ValueObservable<List<CartItem>> get items => _items.stream;

  void _handleAddition(CartAddition addition) {
    _cart.add(addition.product, addition.count);
    _items.add(_cart.items);
    _itemCount.add(_cart.itemCount);
  }

  @override
  void dispose() {
    _items.close();
    _itemCount.close();
    _cartAdditionController.close();
  }
}

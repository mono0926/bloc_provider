import 'dart:async';

import 'package:bloc_complex/models/cart_item.dart';
import 'package:bloc_complex/models/product.dart';
import 'package:bloc_complex/services/cart.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class CartAddition {
  final Product product;
  final int count;

  CartAddition(this.product, {this.count = 1});
}

class CartBloc implements Bloc {
  final _cart = CartService();

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

  @override
  void dispose() {
    _items.close();
    _itemCount.close();
    _cartAdditionController.close();
  }

  void _handleAddition(CartAddition addition) {
    _cart.add(addition.product, addition.count);
    _items.add(_cart.items);
    _itemCount.add(_cart.itemCount);
  }
}

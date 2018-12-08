import 'dart:async';

import 'package:bloc_complex/models/cart_item.dart';
import 'package:bloc_complex/models/product.dart';
import 'package:rxdart/rxdart.dart';

class ProductSquareBloc {
  final _isInCartSubject = BehaviorSubject<bool>(seedValue: false);

  final _cartItemsController = StreamController<List<CartItem>>();

  ProductSquareBloc(Product product) {
    _cartItemsController.stream
        .map((list) => list.any((item) => item.product == product))
        .listen(_isInCartSubject.add);
  }

  Sink<List<CartItem>> get cartItems => _cartItemsController.sink;

  ValueObservable<bool> get isInCart => _isInCartSubject.stream;

  void dispose() {
    _cartItemsController.close();
    _isInCartSubject.close();
  }
}

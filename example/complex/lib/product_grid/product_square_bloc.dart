import 'dart:async';

import 'package:bloc_complex/models/cart_item.dart';
import 'package:bloc_complex/models/product.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class ProductSquareBloc implements Bloc {
  final _isInCartSubject = BehaviorSubject<bool>.seeded(false);
  final _cartItemsController = StreamController<List<CartItem>>();

  ProductSquareBloc(Product product) {
    _cartItemsController.stream
        .map((list) => list.any((item) => item.product == product))
        .listen(_isInCartSubject.add);
  }

  Sink<List<CartItem>> get cartItems => _cartItemsController.sink;

  ValueObservable<bool> get isInCart => _isInCartSubject.stream;

  @override
  void dispose() {
    _cartItemsController.close();
    _isInCartSubject.close();
  }
}

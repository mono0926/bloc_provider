import 'dart:async';

import 'package:bloc_complex/models/cart_item.dart';
import 'package:bloc_complex/models/product.dart';
import 'package:bloc_complex/product_grid/product_square_bloc.dart';
import 'package:bloc_complex/utils/is_dark.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ProductSquare extends StatefulWidget {
  final Product product;
  final Stream<List<CartItem>> itemsStream;

  final GestureTapCallback onTap;

  ProductSquare({
    Key key,
    @required this.product,
    @required this.itemsStream,
    this.onTap,
  }) : super(key: key);

  @override
  _ProductSquareState createState() => _ProductSquareState();
}

class _ProductSquareState extends State<ProductSquare> {
  ProductSquareBloc _bloc;

  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.product.color,
      child: InkWell(
        onTap: widget.onTap,
        child: Center(
          child: StreamBuilder<bool>(
              stream: _bloc.isInCart,
              initialData: _bloc.isInCart.value,
              builder: (context, snapshot) => _createText(snapshot.data)),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(ProductSquare oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _createBloc();
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _createBloc();
  }

  void _createBloc() {
    _bloc = ProductSquareBloc(widget.product);
    _subscription = widget.itemsStream.listen(_bloc.cartItems.add);
  }

  Widget _createText(bool isInCart) {
    return Text(
      widget.product.name,
      style: TextStyle(
        color: isDark(widget.product.color) ? Colors.white : Colors.black,
        decoration: isInCart ? TextDecoration.underline : null,
      ),
    );
  }

  void _disposeBloc() {
    _subscription.cancel();
    _bloc.dispose();
  }
}

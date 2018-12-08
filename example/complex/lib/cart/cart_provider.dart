import 'package:bloc_complex/cart/cart_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';

class CartProvider extends BlocProvider<CartBloc> {
  CartProvider({
    @required Widget child,
  }) : super(
          creator: (context, _bag) => CartBloc(),
          child: child,
        );

  static CartBloc of(BuildContext context) => BlocProvider.of(context);
}

import 'package:bloc_complex/cart/cart_bloc.dart';
import 'package:flutter/widgets.dart';

class CartProvider extends InheritedWidget {
  final CartBloc cartBloc;

  CartProvider({
    Key key,
    CartBloc cartBloc,
    Widget child,
  })  : cartBloc = cartBloc ?? CartBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CartBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CartProvider) as CartProvider)
          .cartBloc;
}

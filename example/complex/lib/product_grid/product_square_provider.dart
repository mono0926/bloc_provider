import 'package:bloc_complex/cart/cart_provider.dart';
import 'package:bloc_complex/models/product.dart';
import 'package:bloc_complex/product_grid/product_square_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';

class ProductSquareProvider extends BlocProvider<ProductSquareBloc> {
  final Product product;
  ProductSquareProvider({
    @required this.product,
    @required BlocBuilder<ProductSquareBloc> builder,
  }) : super.builder(
          creator: (context) {
            final cartBloc = CartProvider.of(context);
            final bloc = ProductSquareBloc(product);
            final subscription = cartBloc.items.listen(bloc.cartItems.add);
            return BlocCreationRequest(
              bloc,
              onDisposed: subscription.cancel,
            );
          },
          builder: builder,
        );
  static ProductSquareBloc of(BuildContext context) => BlocProvider.of(context);
}

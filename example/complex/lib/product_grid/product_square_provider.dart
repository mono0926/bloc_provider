import 'package:bloc_complex/models/product.dart';
import 'package:bloc_complex/product_grid/product_square_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';

class ProductSquareProvider extends BlocProvider<ProductSquareBloc> {
  final Product product;
  ProductSquareProvider({
    @required this.product,
    @required Widget child,
  }) : super(
          creator: (context) => ProductSquareBloc(product),
          child: child,
        );
  static ProductSquareBloc of(BuildContext context) => BlocProvider.of(context);
}

import 'package:bloc_complex/models/product.dart';
import 'package:bloc_complex/product_grid/product_square_provider.dart';
import 'package:bloc_complex/utils/is_dark.dart';
import 'package:flutter/material.dart';

class ProductSquare extends StatelessWidget {
  final Product product;
  final GestureTapCallback? onTap;

  const ProductSquare({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductSquareProvider(
      product: product,
      builder: (context, bloc) {
        return Material(
          color: product.color,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: StreamBuilder<bool>(
                stream: bloc.isInCart,
                initialData: bloc.isInCart.valueWrapper?.value,
                builder: (context, snapshot) => _createText(snapshot.data!),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createText(bool isInCart) {
    return Text(
      product.name,
      style: TextStyle(
        color: isDark(product.color) ? Colors.white : Colors.black,
        decoration: isInCart ? TextDecoration.underline : null,
      ),
    );
  }
}

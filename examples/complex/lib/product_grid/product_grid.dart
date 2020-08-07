import 'package:bloc_complex/cart/cart_bloc.dart';
import 'package:bloc_complex/cart/cart_provider.dart';
import 'package:bloc_complex/catalog/catalog_bloc.dart';
import 'package:bloc_complex/catalog/catalog_provider.dart';
import 'package:bloc_complex/catalog/catalog_slice.dart';
import 'package:bloc_complex/product_grid/product_square.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  static const _loadingSpace = 40;
  static const _gridDelegate =
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);

  const ProductGrid();

  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    final catalogBloc = CatalogProvider.of(context);

    return StreamBuilder<CatalogSlice>(
      stream: catalogBloc.slice,
      initialData: catalogBloc.slice.value,
      builder: (context, snapshot) => GridView.builder(
            gridDelegate: _gridDelegate,
            itemCount: snapshot.data.endIndex + _loadingSpace,
            itemBuilder: (context, index) =>
                _createSquare(index, snapshot.data, catalogBloc, cartBloc),
          ),
    );
  }

  Widget _createSquare(
    int index,
    CatalogSlice slice,
    CatalogBloc catalogBloc,
    CartBloc cartBloc,
  ) {
    catalogBloc.index.add(index);

    final product = slice.elementAt(index);

    if (product == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ProductSquare(
      key: Key(product.id.toString()),
      product: product,
      onTap: () {
        cartBloc.cartAddition.add(CartAddition(product));
      },
    );
  }
}

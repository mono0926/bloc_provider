import 'package:meta/meta.dart';

import 'product.dart';

@immutable
class CartItem {
  final int count;
  final Product product;

  const CartItem(this.count, this.product);

  @override
  String toString() => '${product.name} ✕ $count';
}

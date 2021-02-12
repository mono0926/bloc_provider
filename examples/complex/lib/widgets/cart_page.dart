import 'package:bloc_complex/models/cart.dart';
import 'package:bloc_complex/models/cart_item.dart';
import 'package:bloc_complex/utils/is_dark.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  final Cart cart;
  const CartPage(this.cart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text(
                'Empty',
                style: Theme.of(context).textTheme.headline4,
              ),
            )
          : ListView(
              children: cart.items.map((item) => ItemTile(item: item)).toList(),
            ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final CartItem item;
  const ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: isDark(item.product.color) ? Colors.white : Colors.black,
    );

    return Container(
      color: item.product.color,
      child: ListTile(
        title: Text(
          item.product.name,
          style: textStyle,
        ),
        trailing: CircleAvatar(
          backgroundColor: const Color(0x33FFFFFF),
          child: Text(
            item.count.toString(),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

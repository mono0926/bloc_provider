import 'package:bloc_complex/cart/cart_provider.dart';
import 'package:bloc_complex/models/cart_item.dart';
import 'package:bloc_complex/widgets/cart_page.dart';
import 'package:flutter/material.dart';

class BlocCartPage extends StatelessWidget {
  const BlocCartPage();

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: cart.items,
        builder: (context, snapshot) {
          if (snapshot.data?.isEmpty ?? true) {
            return Center(
              child: Text(
                'Empty',
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          }

          return ListView(
            children:
                snapshot.data!.map((item) => ItemTile(item: item)).toList(),
          );
        },
      ),
    );
  }
}

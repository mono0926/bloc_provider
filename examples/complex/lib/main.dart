import 'package:bloc_complex/cart/bloc_cart_page.dart';
import 'package:bloc_complex/cart/cart_provider.dart';
import 'package:bloc_complex/catalog/catalog_provider.dart';
import 'package:bloc_complex/product_grid/product_grid.dart';
import 'package:bloc_complex/services/service_provider.dart';
import 'package:bloc_complex/widgets/cart_button.dart';
import 'package:bloc_complex/widgets/theme.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

import 'services/catalog.dart';

void main() {
  runApp(
    const ServiceProvider(
      catalogService: CatalogService(),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App();
  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        CatalogProvider(),
        CartProvider(),
      ],
      child: MaterialApp(
        title: 'Bloc Complex',
        theme: appTheme,
        home: const MyHomePage(),
        routes: {
          BlocCartPage.routeName: (context) => const BlocCartPage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage();
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Complex'),
        actions: <Widget>[
          StreamBuilder<int>(
            stream: cartBloc.itemCount,
            initialData: cartBloc.itemCount.value,
            builder: (context, snapshot) => CartButton(
                  itemCount: snapshot.data,
                  onPressed: () {
                    Navigator.of(context).pushNamed(BlocCartPage.routeName);
                  },
                ),
          )
        ],
      ),
      body: const ProductGrid(),
    );
  }
}

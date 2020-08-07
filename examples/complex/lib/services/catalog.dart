import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:meta/meta.dart';

import '../models/product.dart';
import 'catalog_page.dart';

@immutable
class CatalogService {
  static int productsPerPage = 10;
  static int networkDelay = 500;

  const CatalogService();

  Future<CatalogPage> requestPage(int offset) async {
    // Simulate network delay.
    await Future.delayed(Duration(milliseconds: networkDelay));

    // Create a list of random products. We seed the random generator with
    // index so that scrolling back to a position gives the same exact products.
    final random = Random(offset);
    final products = List.generate(productsPerPage, (index) {
      final id = random.nextInt(0xffff);
      final color = Color(0xFF000000 | random.nextInt(0xFFFFFF));
      return Product(id, 'Product $id (#${offset + index})', color);
    });
    return CatalogPage(products, offset);
  }
}

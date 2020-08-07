import 'dart:math';

import 'package:bloc_complex/models/product.dart';
import 'package:bloc_complex/services/catalog_page.dart';
import 'package:meta/meta.dart';

@immutable
class CatalogSlice {
  final List<CatalogPage> _pages;

  final int startIndex;

  final bool hasNext;

  CatalogSlice(this._pages, {this.hasNext})
      : startIndex = _pages.map((p) => p.startIndex).fold(0x7FFFFFFF, min);

  const CatalogSlice.empty()
      : _pages = const [],
        startIndex = 0,
        hasNext = true;

  int get endIndex =>
      startIndex + _pages.map((page) => page.endIndex).fold<int>(-1, max);

  Product elementAt(int index) {
    for (final page in _pages) {
      if (index >= page.startIndex && index <= page.endIndex) {
        return page.products[index - page.startIndex];
      }
    }
    return null;
  }
}

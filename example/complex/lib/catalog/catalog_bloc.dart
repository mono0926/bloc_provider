import 'dart:math';

import 'package:bloc_complex/catalog/catalog_slice.dart';
import 'package:bloc_complex/services/catalog.dart';
import 'package:bloc_complex/services/catalog_page.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class CatalogBloc implements Bloc {
  final _indexController = PublishSubject<int>();

  final _pages = <int, CatalogPage>{};

  final _pagesBeingRequested = <int>{};

  final _sliceSubject =
      BehaviorSubject<CatalogSlice>.seeded(const CatalogSlice.empty());

  final CatalogService catalogService;

  CatalogBloc({
    @required this.catalogService,
  }) {
    _indexController.stream
        .bufferTime(Duration(milliseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .listen(_handleIndexes);
  }

  Sink<int> get index => _indexController.sink;

  ValueObservable<CatalogSlice> get slice => _sliceSubject.stream;

  int _getPageStartFromIndex(int index) =>
      (index ~/ CatalogService.productsPerPage) *
      CatalogService.productsPerPage;

  void _handleIndexes(List<int> indexes) {
    const maxInt = 0x7fffffff;
    final int minIndex = indexes.fold(maxInt, min);
    final int maxIndex = indexes.fold(-1, max);

    final minPageIndex = _getPageStartFromIndex(minIndex);
    final maxPageIndex = _getPageStartFromIndex(maxIndex);

    for (int i = minPageIndex;
        i <= maxPageIndex;
        i += CatalogService.productsPerPage) {
      if (_pages.containsKey(i)) {
        continue;
      }
      if (_pagesBeingRequested.contains(i)) {
        continue;
      }

      _pagesBeingRequested.add(i);
      catalogService.requestPage(i).then((page) => _handleNewPage(page, i));
    }

    _pages.removeWhere((pageIndex, _) =>
        pageIndex < minPageIndex - CatalogService.productsPerPage ||
        pageIndex > maxPageIndex + CatalogService.productsPerPage);
  }

  void _handleNewPage(CatalogPage page, int index) {
    _pages[index] = page;
    _pagesBeingRequested.remove(index);
    _sendNewSlice();
  }

  void _sendNewSlice() {
    final pages = _pages.values.toList(growable: false);

    final slice = CatalogSlice(pages, hasNext: true);

    _sliceSubject.add(slice);
  }

  @override
  void dispose() {
    _indexController.close();
  }
}

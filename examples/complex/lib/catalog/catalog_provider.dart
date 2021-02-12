import 'package:bloc_complex/catalog/catalog_bloc.dart';
import 'package:bloc_complex/services/service_provider.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';

@immutable
class CatalogProvider extends BlocProvider<CatalogBloc> {
  CatalogProvider({
    Widget? child,
  }) : super(
          creator: (context, _bag) {
            final provider = ServiceProvider.of(context);
            return CatalogBloc(catalogService: provider.catalogService);
          },
          child: child,
        );
  static CatalogBloc of(BuildContext context) => BlocProvider.of(context);
}

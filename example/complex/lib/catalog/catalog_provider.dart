import 'package:bloc_complex/catalog/catalog_bloc.dart';
import 'package:bloc_complex/services/service_provider.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';

class CatalogProvider extends BlocProvider<CatalogBloc> {
  CatalogProvider({
    @required Widget child,
  }) : super(
          creator: (context) {
            final provider = ServiceProvider.of(context);
            return BlocCreationRequest(
                CatalogBloc(catalogService: provider.catalogService));
          },
          child: child,
        );
  static CatalogBloc of(BuildContext context) => BlocProvider.of(context);
}

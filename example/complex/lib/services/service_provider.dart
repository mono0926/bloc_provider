import 'package:bloc_complex/services/catalog.dart';
import 'package:flutter/widgets.dart';

class ServiceProvider extends InheritedWidget {
  final CatalogService catalogService;

  ServiceProvider({
    @required this.catalogService,
    @required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static ServiceProvider of(BuildContext context) => context
      .ancestorInheritedElementForWidgetOfExactType(ServiceProvider)
      .widget as ServiceProvider;
}

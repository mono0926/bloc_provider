import 'package:bloc_complex/services/catalog.dart';
import 'package:flutter/widgets.dart';

@immutable
class ServiceProvider extends InheritedWidget {
  final CatalogService catalogService;

  const ServiceProvider({
    @required this.catalogService,
    @required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static ServiceProvider of(BuildContext context) =>
      context.getElementForInheritedWidgetOfExactType<ServiceProvider>().widget
          as ServiceProvider;
}

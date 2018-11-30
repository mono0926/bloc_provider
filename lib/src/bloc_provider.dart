import 'package:bloc_provider/src/bloc.dart';
import 'package:flutter/widgets.dart';

typedef _BlocCreator<BlocType extends Bloc> = BlocType Function(
    BuildContext context);
typedef BlocBuilder<BlocType extends Bloc> = Widget Function(
    BuildContext context, BlocType bloc);

class BlocProvider<BlocType extends Bloc> extends StatefulWidget {
  final BlocBuilder<BlocType> builder;
  final _BlocCreator<BlocType> creator;

  BlocProvider({
    @required Widget child,
    @required _BlocCreator<BlocType> creator,
  }) : this.builder(
          builder: (_context, _bloc) => child,
          creator: creator,
        );

  BlocProvider.builder({
    @required this.builder,
    @required this.creator,
  });

  @override
  _BlocProviderState createState() => _BlocProviderState<BlocType>();

  static BlocType of<BlocType extends Bloc>(BuildContext context) =>
      _Inherited.of<BlocType>(context);
}

class _BlocProviderState<BlocType extends Bloc>
    extends State<BlocProvider<BlocType>> {
  BlocType _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.creator(context);
  }

  @override
  Widget build(BuildContext context) {
    return _Inherited<BlocType>(
      bloc: _bloc,
      child: widget.builder(context, _bloc),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class _Inherited<BlocType extends Bloc> extends InheritedWidget {
  final BlocType bloc;

  _Inherited({
    @required this.bloc,
    @required Widget child,
  }) : super(child: child);

  static BlocType of<BlocType extends Bloc>(BuildContext context) {
    Type typeOf<T>() => T;
    return (context
            .ancestorInheritedElementForWidgetOfExactType(
                typeOf<_Inherited<BlocType>>())
            .widget as _Inherited<BlocType>)
        .bloc;
    // TODO: Which is better?
    // return (context.inheritFromWidgetOfExactType(
    //         typeOf<_ProviderInherited<T>>()) as _ProviderInherited<T>)
    //     .bloc;
  }

  @override
  bool updateShouldNotify(_Inherited oldWidget) => false;
}

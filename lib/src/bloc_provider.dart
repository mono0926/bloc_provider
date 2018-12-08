import 'package:bloc_provider/src/bloc.dart';
import 'package:flutter/widgets.dart';

typedef OnDisposed = void Function();

class BlocCreatorBag {
  OnDisposed onDisposed;
}

typedef BlocCreator<BlocType extends Bloc> = BlocType Function(
    BuildContext context, BlocCreatorBag bag);
typedef BlocBuilder<BlocType extends Bloc> = Widget Function(
    BuildContext context, BlocType bloc);

class BlocProvider<BlocType extends Bloc> extends StatefulWidget {
  final BlocCreator<BlocType> creator;
  final BlocBuilder<BlocType> builder;

  BlocProvider({
    Key key,
    @required Widget child,
    @required BlocCreator<BlocType> creator,
  }) : this.builder(
          key: key,
          builder: (_context, _bloc) => child,
          creator: creator,
        );

  BlocProvider.builder({
    Key key,
    @required this.builder,
    @required this.creator,
  }) : super(key: key);

  @override
  _BlocProviderState createState() => _BlocProviderState<BlocType>();

  static BlocType of<BlocType extends Bloc>(BuildContext context) =>
      _Inherited.of<BlocType>(context);
}

class _BlocProviderState<BlocType extends Bloc>
    extends State<BlocProvider<BlocType>> {
  BlocType _bloc;
  final _bag = BlocCreatorBag();

  @override
  void initState() {
    super.initState();
    _bloc = widget.creator(context, _bag);
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
    if (_bag.onDisposed != null) {
      _bag.onDisposed();
    }
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

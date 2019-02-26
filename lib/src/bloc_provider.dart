import 'package:flutter/widgets.dart';

import 'bloc.dart';
import 'bloc_creator_bag.dart';

typedef BlocCreator<BlocType extends Bloc> = BlocType Function(
    BuildContext context, BlocCreatorBag bag);
typedef BlocBuilder<BlocType extends Bloc> = Widget Function(
    BuildContext context, BlocType bloc);

/// Provides BLoC via this Provider.
///
/// BLoC's lifecycle is associated with
/// the state that the provider has internally.
///
/// This can be called directory(see constructor documentation),
/// or you can define a class as below.
///
/// ### Example
///
/// ```dart
/// class CounterBlocProvider extends BlocProvider<CounterBloc> {
///   CounterBlocProvider({
///     @required Widget child,
///   }) : super(
///     child: child,
///     creator: (context, _bag) {
///       assert(context != null);
///       return CounterBloc();
///     },
///   );
///
///   static CounterBloc of(BuildContext context) => BlocProvider.of(context);
/// }
/// ```
class BlocProvider<BlocType extends Bloc> extends StatefulWidget {
  final BlocCreator<BlocType> creator;
  final BlocBuilder<BlocType> builder;
  final bool autoDispose;

  /// Constructor for simple usage.
  ///
  /// ### Example
  ///
  /// ```dart
  /// BlocProvider<CounterBloc>(
  ///   creator: (_context, _bag) => CounterBloc(),
  ///   child: App(),
  /// )
  /// ```
  BlocProvider({
    Key key,
    @required BlocCreator<BlocType> creator,
    @required Widget child,
  }) : this.builder(
          key: key,
          creator: creator,
          builder: (_context, _bloc) => child,
        );

  /// Constructor for advanced usage.
  ///
  /// ### Example
  ///
  /// ```dart
  /// BlocProvider.builder<CounterBloc>(
  ///   creator: (context, bag) {
  ///     // Do some work with `context` and `bag`.
  ///     // ...
  ///     return CounterBloc();
  ///   },
  ///   builder: (context, bloc) {
  ///     // Do some work with `context` and `bloc`.
  ///     // ...
  ///     return App();
  ///   },
  /// )
  /// ```
  const BlocProvider.builder({
    Key key,
    @required this.creator,
    @required this.builder,
    this.autoDispose = true,
  }) : super(key: key);

  /// Pass the bloc which is managed by other widget.
  ///
  /// Passed bloc isn't disposed, so it should be managed appropriately.
  ///
  /// Typical use case is this:
  ///
  /// 1. The bloc is managed by [BlocProvider] or [BlocProvider.builder]
  /// 2. Pass the bloc to other widgets tree without dispose management
  ///
  /// ### Example
  ///
  /// ```
  /// BlocProvider<CounterBloc>(
  ///   bloc: BlocProvider<CounterBloc>.of(context),
  ///   child: AnotherPage(),
  /// )
  /// ```
  BlocProvider.unmanaged({
    Key key,
    @required BlocType bloc,
    @required Widget child,
  }) : this.builder(
          key: key,
          creator: (_context, _bag) => bloc,
          builder: (_context, _bloc) => child,
          autoDispose: false,
        );

  @override
  _BlocProviderState createState() => _BlocProviderState<BlocType>();

  /// Return the [BlocType] of the closest ancestor [_Inherited].
  ///
  /// ###  Simple usage
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final bloc = BlocProvider.of<CounterBloc>(context);
  ///   // ...
  /// }
  /// ```
  ///
  /// ### You can also define your own [of] method for convenience:
  ///
  /// ```
  /// // Define of method at subclass.
  /// class CounterBlocProvider extends BlocProvider<CounterBloc> {
  ///   // ...
  ///   static CounterBloc of(BuildContext context) => BlocProvider.of(context);
  /// }
  ///
  /// // Call defined [of].
  /// final bloc = CounterBloc.of(context);
  /// ```
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
    if (widget.autoDispose) {
      _bloc.dispose();
    }
    if (_bag.onDisposed != null) {
      _bag.onDisposed();
    }
    super.dispose();
  }
}

@immutable
class _Inherited<BlocType extends Bloc> extends InheritedWidget {
  final BlocType bloc;

  const _Inherited({
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
  }

  @override
  bool updateShouldNotify(_Inherited oldWidget) => false;
}

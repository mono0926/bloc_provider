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
class BlocProvider<T extends Bloc> extends StatefulWidget {
  /// Constructor for simple usage.
  ///
  /// The [child] parameter should be omitted if and only if
  /// the provider is passed to `BlocProviderTree`.
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
    Key? key,
    required BlocCreator<T> creator,
    Widget? child,
    bool autoDispose = true,
  }) : this.builder(
          key: key,
          creator: creator,
          builder: (_context, _bloc) => child!,
          autoDispose: autoDispose,
        );

  /// Constructor for advanced usage.
  ///
  /// ### Example
  ///
  /// ```dart
  /// BlocProvider<CounterBloc>.builder(
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
    Key? key,
    required this.creator,
    required this.builder,
    this.autoDispose = true,
  }) : super(key: key);

  /// Pass the bloc which is managed by other widget.
  ///
  /// Passed bloc won't be disposed automatically,
  /// so it should be managed appropriately.
  ///
  /// Typical use case is this:
  ///
  /// 1. The bloc is managed by [BlocProvider] or [BlocProvider.builder]
  /// 2. Pass the bloc to other widgets tree without dispose management
  ///
  /// See also [BlocProvider.fromBlocContext]
  ///
  /// ### Example
  ///
  /// ```
  /// BlocProvider<CounterBloc>.fromBloc(
  ///   bloc: BlocProvider<CounterBloc>.of(context),
  ///   child: AnotherPage(),
  /// )
  /// ```
  BlocProvider.fromBloc({
    Key? key,
    required T bloc,
    required Widget child,
  }) : this(
          key: key,
          creator: (_context, _bag) => bloc,
          child: child,
          autoDispose: false,
        );

  /// Pass the context that contains bloc which is managed by other widget.
  ///
  /// Passed blocContext's bloc won't disposed automatically,
  /// so it should be managed appropriately.
  ///
  /// See also [BlocProvider.fromBloc]
  ///
  /// ### Example
  ///
  /// ```
  /// BlocProvider<CounterBloc>.fromBlocContext(
  ///   context: context, // context's widget tree should contains the bloc
  ///   child: AnotherPage(),
  /// )
  /// ```
  BlocProvider.fromBlocContext({
    Key? key,
    required BuildContext context,
    required Widget child,
  }) : this.fromBloc(
          key: key,
          bloc: BlocProvider.of(context),
          child: child,
        );

  final BlocCreator<T> creator;
  final BlocBuilder<T> builder;
  final bool autoDispose;

  /// Clone the current [BlocProvider] with a new child [Widget].
  ///
  /// All other values, including [Key] and [Bloc] are preserved.
  BlocProvider<T> copyWith(Widget child) {
    return BlocProvider<T>.builder(
      key: key,
      creator: creator,
      builder: (_context, _bag) => child,
    );
  }

  @override
  _BlocProviderState createState() => _BlocProviderState<T>();

  /// Return the [BlocType] of the closest ancestor [_Inherited].
  ///
  /// If closest ancestor [_Inherited] is not found, [ArgumentError] will be
  /// thrown. To suppress the error, you should use [maybeOf].
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

  static BlocType? maybeOf<BlocType extends Bloc>(BuildContext context) =>
      _Inherited.maybeOf<BlocType>(context);
}

class _BlocProviderState<BlocType extends Bloc>
    extends State<BlocProvider<BlocType>> {
  late final BlocType _bloc;
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
      child: Builder(
        builder: (context) => widget.builder(context, _bloc),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      _bloc.dispose();
    }
    final onDisposed = _bag.onDisposed;
    if (onDisposed != null) {
      onDisposed();
    }
    super.dispose();
  }
}

@immutable
class _Inherited<BlocType extends Bloc> extends InheritedWidget {
  const _Inherited({
    required this.bloc,
    required Widget child,
  }) : super(child: child);

  static BlocType of<BlocType extends Bloc>(BuildContext context) {
    final widget = _of<BlocType>(context);
    if (widget == null) {
      throw ArgumentError(
        '$BlocType is not provided to ${context.widget.runtimeType}. '
        'Context used for Bloc retrieval must be a descendant of BlocProvider.',
      );
    }
    return widget.bloc;
  }

  static BlocType? maybeOf<BlocType extends Bloc>(BuildContext context) {
    final widget = _of<BlocType>(context);
    return widget?.bloc;
  }

  static _Inherited<BlocType>? _of<BlocType extends Bloc>(
      BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<_Inherited<BlocType>>()
        ?.widget as _Inherited<BlocType>?;
  }

  final BlocType bloc;

  @override
  bool updateShouldNotify(_Inherited oldWidget) => false;
}

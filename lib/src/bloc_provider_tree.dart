/*
 This source file was written in reference to [bloc_provider_tree.dart - felangel/bloc](https://github.com/felangel/bloc/blob/37f54680bf7f9f2ade8d717cf0c52ebeed8931b8/packages/flutter_bloc/lib/src/bloc_provider_tree.dart) by [@felangel](https://github.com/felangel).
 */
import 'package:flutter/widgets.dart';

import 'bloc_provider.dart';

/// A Flutter [Widget] that merges multiple [BlocProvider] widgets
/// into one widget tree.
///
/// [BlocProviderTree] improves the readability and eliminates the need
/// to nest multiple [BlocProvider]s.
///
/// By using [BlocProviderTree] we can go from:
///
/// ```dart
/// BlocProvider<BlocA>(
///   creator: (_context, _bag) => BlocA(),
///   child: BlocProvider<BlocB>(
///     creator: (_context, _bag) => BlocB(),
///     child: BlocProvider<BlocC>(
///       creator: (_context, _bag) => BlocC(),
///       child: ChildA(),
///     )
///   )
/// )
/// ```
///
/// to:
///
/// ```dart
/// BlocProviderTree(
///   blocProviders: [
///     BlocProvider<BlocA>(creator: (_context, _bag) => BlocA()),
///     BlocProvider<BlocB>(creator: (_context, _bag) => BlocB()),
///     BlocProvider<BlocC>(creator: (_context, _bag) => BlocC()),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [BlocProviderTree] converts the [BlocProvider] list
/// into a tree of nested [BlocProvider] widgets.
/// As a result, the only advantage of using [BlocProviderTree] is improved
/// readability due to the reduction in nesting and boilerplate.
class BlocProviderTree extends StatelessWidget {
  /// The [BlocProvider] list which is converted into
  /// a tree of [BlocProvider] widgets.
  ///
  /// The tree of [BlocProvider] widgets is created in order meaning
  /// the first [BlocProvider] will be the top-most [BlocProvider] and
  /// the last [BlocProvider] will be a direct ancestor of the [child] [Widget].
  ///
  /// Each provider's `child` will be discarded, so giving `child` to each
  /// provider makes no sense.
  final List<BlocProvider> blocProviders;

  /// The [Widget] and its descendants which will have access to
  /// every `BloC` provided by [blocProviders].
  ///
  /// This [Widget] will be a direct descendent of
  /// the last [BlocProvider] in [blocProviders].
  final Widget child;

  const BlocProviderTree({
    Key key,
    @required this.blocProviders,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tree = child;
    for (final blocProvider in blocProviders.reversed) {
      tree = blocProvider.copyWith(tree);
    }
    return tree;
  }
}

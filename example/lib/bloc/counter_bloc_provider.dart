import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider_example/bloc/counter_bloc.dart';
import 'package:flutter/widgets.dart';

class CounterBlocProvider extends BlocProvider<CounterBloc> {
  CounterBlocProvider({
    @required Widget child,
//    @required BuildContext context,
  }) : super(
          child: child,
          // TODO: contextから取得したオブジェクトをDI
          creator: () => CounterBloc(),
        );

  static CounterBloc of(BuildContext context) => BlocProvider.of(context);
}

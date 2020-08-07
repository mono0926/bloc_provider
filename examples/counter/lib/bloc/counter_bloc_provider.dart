import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider_example/bloc/counter_bloc.dart';
import 'package:flutter/widgets.dart';

class CounterBlocProvider extends BlocProvider<CounterBloc> {
  CounterBlocProvider({
    @required Widget child,
  }) : super(
          child: child,
          creator: (context, _bag) {
            assert(context != null);
            return CounterBloc();
          },
        );

  static CounterBloc of(BuildContext context) => BlocProvider.of(context);
}

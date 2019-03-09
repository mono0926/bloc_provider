import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc implements Bloc {
  final _countController = BehaviorSubject<int>.seeded(0);
  final _incrementController = PublishSubject<void>();

  CounterBloc() {
    _incrementController
        .scan<int>((s, v, i) => s + 1, 0)
        .pipe(_countController);
  }

  ValueObservable<int> get count => _countController;
  Sink<void> get increment => _incrementController.sink;

  @override
  void dispose() async {
    await _incrementController.close();
    await _countController.close();
  }
}

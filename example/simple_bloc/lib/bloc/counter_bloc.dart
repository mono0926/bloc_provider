import 'package:rxdart/rxdart.dart';

class CounterBloc {
  final _countController = BehaviorSubject<int>(seedValue: 0);
  final _incrementController = PublishSubject<void>();

  CounterBloc() {
    _incrementController
        .scan<int>((sum, _v, _i) => sum + 1, 0)
        .pipe(_countController);
  }

  Stream<int> get count => _countController;
  Sink<void> get increment => _incrementController.sink;

  void dispose() async {
    await _incrementController.close();
    await _countController.close();
  }
}

import 'package:rxdart/rxdart.dart';

class ResporteBloc {
  final _controllerMonto = BehaviorSubject<String>();

  Stream<String> get montoStream => _controllerMonto.stream;

  dispose() {
    _controllerMonto?.close();
  }

  void actualizarMonnto(String monto) => _controllerMonto.sink.add(monto);
}

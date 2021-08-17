import 'package:rxdart/rxdart.dart';

class BottomNaviBloc {
  final _selectPageController = BehaviorSubject<int>();
  final _cantidadSubidaImagen = BehaviorSubject<double>();

  final _paginacionTorneoController = BehaviorSubject<int>();

  Stream<int> get selectPageStream => _selectPageController.stream;
  Stream<double> get subidaImagenStream => _cantidadSubidaImagen.stream;
  Stream<int> get selectPageStreamTorneo => _paginacionTorneoController.stream;

  Function(int) get changePage => _selectPageController.sink.add;
  Function(double) get changeSubidaImagen => _cantidadSubidaImagen.sink.add;
  Function(int) get changePageTorneo => _paginacionTorneoController.sink.add;

  // Obtener el último valor ingresado a los streams
  int get page => _selectPageController.value;
  int get pageTorneo => _paginacionTorneoController.value;
  double get subidaImagen => _cantidadSubidaImagen.value;

  dispose() {
    _selectPageController?.close();
    _paginacionTorneoController?.close();
    _cantidadSubidaImagen?.close();
  }
}

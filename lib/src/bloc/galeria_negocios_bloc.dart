import 'package:capitan_sin_google/src/database/negocios_database.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:rxdart/rxdart.dart';

class GaleriaBloc {
  final negociosDatabase = NegociosDatabase();
  final _galeriaController = BehaviorSubject<List<Galeria>>();

  final _selectPageController = BehaviorSubject<int>();

  Stream<int> get selectPageStream => _selectPageController.stream;

  Function(int) get changePage => _selectPageController.sink.add;

  // Obtener el último valor ingresado a los streams
  int get page => _selectPageController.value;

  Stream<List<Galeria>> get galeriaStream => _galeriaController.stream;

  dispose() {
    _galeriaController?.close();
    _selectPageController?.close();
  }

  void obtenerGalerias(String id) async {
    _galeriaController.sink.add(await negociosDatabase.obtenerGaleriaNegocios(id));
  }
}

import 'package:capitan_sin_google/src/api/config_api.dart';
import 'package:capitan_sin_google/src/database/ciudades_database.dart';
import 'package:capitan_sin_google/src/models/ciudades_model.dart';
import 'package:rxdart/subjects.dart';

class CiudadesBloc {
  final ciudadesDatabse = CiudadesDatabase();
  final configInicial = ConfigApi();

  final _ciudadesController = BehaviorSubject<List<CiudadesModel>>();

  Stream<List<CiudadesModel>> get ciudadesStream => _ciudadesController.stream;

  dispose() {
    _ciudadesController?.close();
  }

  void obtenerCiudades() async {
    _ciudadesController.sink.add(await ciudadesDatabse.obtenerCiudades());
    await configInicial.obtenerConfig();
    _ciudadesController.sink.add(await ciudadesDatabse.obtenerCiudades());
  }
}

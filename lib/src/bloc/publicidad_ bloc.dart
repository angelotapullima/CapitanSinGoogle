import 'package:capitan_sin_google/src/database/publicidad_database.dart';
import 'package:capitan_sin_google/src/models/publicidad_model.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class PublicidadBloc {
  final publicidadDatabase = PublicidadDatabase();

  final _publicidad1Controller = BehaviorSubject<List<PublicidadModel>>();
  final _publicidad2Controller = BehaviorSubject<List<PublicidadModel>>();
  final _publicidad3Controller = BehaviorSubject<List<PublicidadModel>>();
  final _publicidad4Controller = BehaviorSubject<List<PublicidadModel>>();

  Stream<List<PublicidadModel>> get publicidad1Stream => _publicidad1Controller.stream;
  Stream<List<PublicidadModel>> get publicidad2Stream => _publicidad2Controller.stream;
  Stream<List<PublicidadModel>> get publicidad3Stream => _publicidad3Controller.stream;
  Stream<List<PublicidadModel>> get publicidad4Stream => _publicidad4Controller.stream;

  dispose() {
    _publicidad1Controller?.close();
    _publicidad2Controller?.close();
    _publicidad3Controller?.close();
    _publicidad4Controller?.close();
  }

  void obtenerPublicidadPorTipo(String tipoPublicidad) async {
    if (tipoPublicidad == '1') {
      _publicidad1Controller.sink.add(await obtenerPublicidadPorFechaYHora(tipoPublicidad));
    } else if (tipoPublicidad == '2') {
      _publicidad2Controller.sink.add(await obtenerPublicidadPorFechaYHora(tipoPublicidad));
    } else if (tipoPublicidad == '3') {
      _publicidad3Controller.sink.add(await obtenerPublicidadPorFechaYHora(tipoPublicidad));
    } else if (tipoPublicidad == '4') {
      _publicidad4Controller.sink.add(await obtenerPublicidadPorFechaYHora(tipoPublicidad));
    }
  }

  Future<List<PublicidadModel>> obtenerPublicidadPorFechaYHora(String tipoPublicidad) async {
    final List<PublicidadModel> listReturn = [];

    //Obtener publicidades por tipo
    final publicidadesDB = await publicidadDatabase.obtenerPublicidadPorTipoPublicidad(tipoPublicidad);

    for (var i = 0; i < publicidadesDB.length; i++) {
      bool mostrar = false;
      PublicidadModel publicidad = PublicidadModel();

      publicidad.idPublicidad = publicidadesDB[i].idPublicidad;
      publicidad.ubigeoPublicidad = publicidadesDB[i].ubigeoPublicidad;
      publicidad.imagenPublicidad = publicidadesDB[i].imagenPublicidad;
      publicidad.linkPublicidad = publicidadesDB[i].linkPublicidad;
      publicidad.horaPublicidad = publicidadesDB[i].horaPublicidad;
      publicidad.diasPublicidad = publicidadesDB[i].diasPublicidad;
      publicidad.tipoPublicidad = publicidadesDB[i].tipoPublicidad;
      publicidad.estadoPublicidad = publicidadesDB[i].estadoPublicidad;

      var listaDias = publicidadesDB[i].diasPublicidad.split(',');
      var horario = publicidadesDB[i].horaPublicidad.split('-');
      var horaIncio = horario[0];
      var horaFin = horario[1];

      if (horaIncio.length == 1) {
        horaIncio = '0${horario[0]}';
      }

      if (horaFin.length == 1) {
        horaFin = '0${horario[1]}';
      }

      var fecha = DateTime.now();
      final DateFormat fech = new DateFormat('yyyy-MM-dd');
      String fechaFormateada = fech.format(fecha);
      DateTime dateInicio = DateTime.parse('$fechaFormateada $horaIncio:00:00');
      DateTime dateFin = DateTime.parse('$fechaFormateada $horaFin:00:00');
      for (var x = 0; x < listaDias.length; x++) {
        if (fecha.weekday == int.parse(listaDias[x])) {
          if (dateInicio.isBefore(fecha) && dateFin.isAfter(fecha)) {
            mostrar = true;
            break;
          }
        }
      }

      if (mostrar) {
        listReturn.add(publicidad);
      }
    }

    return listReturn;
  }
}

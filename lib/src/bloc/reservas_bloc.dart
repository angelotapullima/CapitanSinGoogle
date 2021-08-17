import 'package:capitan_sin_google/src/api/reservas_api.dart';
import 'package:capitan_sin_google/src/database/canchas_database.dart';
import 'package:capitan_sin_google/src/database/negocios_database.dart';
import 'package:capitan_sin_google/src/database/reservas_database.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:rxdart/rxdart.dart';

class ReservasBloc {
  final reservasApi = ReservasApi();
  final reservasDatabase = ReservasDatabase();
  final canchasDatabase = CanchasDatabase();
  final negociosDatabase = NegociosDatabase();

  //final _cargandoReservaVerdeController = new BehaviorSubject<bool>();
  final _reservaPorIdReservaController = new BehaviorSubject<List<ReservaModel>>();
  final _reservasController = new BehaviorSubject<List<ReservaFechas>>();
  final _cargandoApiReservas = new BehaviorSubject<bool>();

  //Recuperaer los datos del Stream
  Stream<bool> get cargandoReservaApi => _cargandoApiReservas.stream;
  Stream<List<ReservaModel>> get reservasPorIdReservaStream => _reservaPorIdReservaController.stream;
  Stream<List<ReservaFechas>> get reservasStream => _reservasController.stream;
  //inserta valores al Stream
  Function(bool) get changeCargandoReservaApi => _cargandoApiReservas.sink.add;

  dispose() {
    _cargandoApiReservas?.close();
    _reservaPorIdReservaController?.close();
    _reservasController?.close();
  }

  void cargandoFalse() {
    _cargandoApiReservas.sink.add(false);
  }

  Future<bool> reservarVerde(String idCancha, String pagoEquipoId, String nombre, String hora, String pago1, String pagoTipo, String idColaboracion,
      String pagoComision, String tipopago, String estado, String fecha) async {
    _cargandoApiReservas.sink.add(true);
    final resp = await reservasApi.reservarVerdeCliente(
        idCancha, pagoEquipoId, nombre, hora, pago1, pagoTipo, idColaboracion, pagoComision, tipopago, estado, fecha);
    _cargandoApiReservas.sink.add(false);

    return resp;
  }

  void obtenerReservaPorIdReserva(String idReserva) async {
    _reservaPorIdReservaController.sink.add(await reservasDatabase.obtenerReservasPorIdReserva(idReserva));
    await reservasApi.obtenerReservaPorIdReserva(idReserva);
    _reservaPorIdReservaController.sink.add(await reservasDatabase.obtenerReservasPorIdReserva(idReserva));
  }

  void listarReservas(String idUser) async {
    _reservasController.sink.add(await listarReservasFuncion(idUser));

    print('reservas api true');
    _cargandoApiReservas.sink.add(true);
    await reservasApi.listarReservasPorUsuario();
    _cargandoApiReservas.sink.add(false);
    print('reservas api false');
    _reservasController.sink.add(await listarReservasFuncion(idUser));
  }

  Future<List<ReservaFechas>> listarReservasFuncion(String iduser) async {
    final List<ReservaFechas> listRespuesta = [];

    final List<String> fechas = [];

    final reservasList = await reservasDatabase.obtenerReservaPorIdUsuario(iduser);

    for (var x = 0; x < reservasList.length; x++) {
      fechas.add(reservasList[x].reservaFecha);
    }

    for (var y = 0; y < fechas.length; y++) {
      ReservaFechas reservaFechas = ReservaFechas();
      reservaFechas.fecha = fechas[y];

      if (reservasList.length > 0) {
        final List<ReservaModel> listReservaFechas = [];
        for (var i = 0; i < reservasList.length; i++) {
          if (fechas[y] == reservasList[i].reservaFecha) {
            ReservaModel reserva = ReservaModel();

            final canchaList = await canchasDatabase.obtenerCanchasPorId(reservasList[i].canchaId);
            final negociosList = await negociosDatabase.obtenerNegocioPorId(reservasList[i].empresaId);

            String canchaNombre = '';
            String empresaNombre = '';

            if (canchaList.length > 0) {
              canchaNombre = canchaList[0].nombre;
            }

            if (negociosList.length > 0) {
              empresaNombre = negociosList[0].nombre;
            }

            reserva.reservaId = reservasList[i].reservaId;
            reserva.reservaFecha = reservasList[i].reservaFecha;
            reserva.reservaNombre = reservasList[i].reservaNombre;
            reserva.reservaHora = reservasList[i].reservaHora;
            reserva.tipoPago = reservasList[i].tipoPago;
            reserva.pago1 = reservasList[i].pago1;
            reserva.pago2 = reservasList[i].pago2;
            reserva.pago1Date = reservasList[i].pago1Date;
            reserva.fechaFormateada1 = reservasList[i].fechaFormateada1;
            reserva.pago2Date = reservasList[i].pago2Date;
            reserva.fechaFormateada2 = reservasList[i].fechaFormateada2;
            reserva.canchaId = reservasList[i].canchaId;
            reserva.empresaId = reservasList[i].empresaId;
            reserva.pagoId = reservasList[i].pagoId;
            reserva.idUser = reservasList[i].idUser;
            //no hay pagoID
            reserva.cliente = reservasList[i].cliente;
            reserva.nroOperacion = reservasList[i].nroOperacion;
            reserva.reservaEstado = reservasList[i].reservaEstado;
            reserva.comision = reservasList[i].comision;
            reserva.monto = reservasList[i].monto;
            reserva.concepto = reservasList[i].concepto;

            reserva.canchaNombre = canchaNombre;
            reserva.empresaNombre = empresaNombre;
            listReservaFechas.add(reserva);
          }
        }
        reservaFechas.reservas = listReservaFechas;
      }

      listRespuesta.add(reservaFechas);
    }

    return listRespuesta;
  }
}

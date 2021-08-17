import 'package:capitan_sin_google/src/api/canchas_api.dart';
import 'package:capitan_sin_google/src/api/reservas_api.dart';
import 'package:capitan_sin_google/src/api/usuario_api.dart';
import 'package:capitan_sin_google/src/database/canchas_database.dart';
import 'package:capitan_sin_google/src/database/negocios_database.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/models/saldo_model.dart';
import 'package:rxdart/rxdart.dart';

class CanchasBloc {
  final canchasDatabase = CanchasDatabase();
  final negociosDatabase = NegociosDatabase();
  final canchasApi = CanchasApi();
  final reservasApi = ReservasApi();
  final usuarioApi = UsuarioApi();

  final _canchasPorEmpresaController = BehaviorSubject<List<CanchasResult>>();
  final _canchasFiltradoPorEmpresaController = BehaviorSubject<List<CanchasResult>>();
  final _canchaPorIdController = BehaviorSubject<List<CanchasResult>>();
  final _datosCanchaPorIdController = BehaviorSubject<List<CanchasResult>>();
  final _reservasCanchasController = BehaviorSubject<List<ReservaModel>>();
  final _cargandoCanchasController = new BehaviorSubject<bool>();
  final _saldoController = BehaviorSubject<List<SaldoResult>>();

  Stream<List<CanchasResult>> get canchasPorEmpresaCompleto => _canchasPorEmpresaController.stream;
  Stream<List<CanchasResult>> get canchasFiltradoPorEmpresaCompleto => _canchasFiltradoPorEmpresaController.stream;
  Stream<List<CanchasResult>> get canchaPorId => _canchaPorIdController.stream;
  Stream<List<CanchasResult>> get datosCanchaPorId => _datosCanchaPorIdController.stream;
  Stream<List<ReservaModel>> get reservasCanchasStream => _reservasCanchasController.stream;
  Stream<bool> get cargandoCanchasStream => _cargandoCanchasController.stream;
  Stream<List<SaldoResult>> get saldoStream => _saldoController.stream;

  dispose() {
    _canchasPorEmpresaController?.close();
    _canchasFiltradoPorEmpresaController?.close();
    _reservasCanchasController?.close();
    _cargandoCanchasController?.close();
    _canchaPorIdController?.close();
    _datosCanchaPorIdController?.close();
    _saldoController?.close();
  }

  void obtenerCanchasFiltradoPorEmpresa(String id) async {
    _canchasFiltradoPorEmpresaController.sink.add(await canchasDatabase.obtenerCanchasPorIdEmpresa(id));
    await canchasApi.obtenerCanchasPorIdEmpresa(id);
    _canchasFiltradoPorEmpresaController.sink.add(await canchasDatabase.obtenerCanchasPorIdEmpresa(id));
  }

  void obtenerCanchasPorEmpresa(String id) async {
    _canchasPorEmpresaController.sink.add(await canchasDatabase.obtenerCanchasPorIdEmpresa(id));
    await canchasApi.obtenerCanchasPorIdEmpresa(id);
    _canchasPorEmpresaController.sink.add(await canchasDatabase.obtenerCanchasPorIdEmpresa(id));
  }

  void obtenerReservasPorIDCancha(String idCancha, String fecha, String diaDeLaSemana) async {
    // _reservasCanchasController.sink.add(await reservasApi.obtenerReservasPorFechayPorIDCancha(idCancha, idEmpresa, fecha, diaDeLaSemana, fechaServidor));
    _reservasCanchasController.sink.add([]);
    print('llamada asincrona continua');
    //_reservasCanchasController.sink.add(  await reservasApi.obtenerReservasPorFechayPorIDCancha( idCancha, idEmpresa, fecha, diaDeLaSemana, fechaServidor));
    await reservasApi.cargarReservasPorFecha(idCancha, fecha);
    _reservasCanchasController.sink.add(await reservasApi.obtenerReservasPorFechayPorIDCancha(idCancha, fecha, diaDeLaSemana));
  }

  void obtenerFechasReservasCanchaPorId(String idCancha, String fecha, String hora) async {
    _canchaPorIdController.sink.add(
      await canchasApi.obtenerCanchasPorId(idCancha, fecha, hora),
    );
  }

  void obtenerSaldo3() async {
    _saldoController.sink.add(await usuarioApi.obtenerSaldo3());
  }

  void cargandoFalse() async {
    _cargandoCanchasController.sink.add(false);
  }

  List<SaldoResult> obtenerSaldo2() {
    return _saldoController.value;
  }

  void obtenerDatosDeCanchaPorId(String idCancha, String idEmpresa) async {
    _datosCanchaPorIdController.sink.add(await obtenerDatosDeCanchas(idCancha));
    await canchasApi.obtenerCanchasPorIdEmpresa(idEmpresa);
    _datosCanchaPorIdController.sink.add(await obtenerDatosDeCanchas(idCancha));
  }

  Future<List<CanchasResult>> obtenerDatosDeCanchas(String id) async {
    final List<CanchasResult> listGeneral = [];
    final cancha = await canchasDatabase.obtenerCanchasPorId(id);

    if (cancha.length > 0) {
      final empresaDatos = await negociosDatabase.obtenerNegocioPorId(cancha[0].idEmpresa);
      CanchasResult canchasResult = CanchasResult();

      canchasResult.idEmpresa = cancha[0].idEmpresa;
      canchasResult.canchaId = cancha[0].canchaId;
      canchasResult.nombre = cancha[0].nombre;
      canchasResult.dimensiones = cancha[0].dimensiones;
      canchasResult.precioD = cancha[0].precioD;
      canchasResult.precioN = cancha[0].precioN;
      canchasResult.foto = cancha[0].foto;
      canchasResult.promoPrecio = cancha[0].promoPrecio;
      canchasResult.promoInicio = cancha[0].promoInicio;
      canchasResult.promoFin = cancha[0].promoFin;
      canchasResult.promoEstado = cancha[0].promoEstado;
      canchasResult.direccionEmpresa = (empresaDatos.length > 0) ? empresaDatos[0].direccion : '';
      listGeneral.add(canchasResult);
    }

    return listGeneral;
  }
}

import 'package:capitan_sin_google/src/api/canchas_api.dart';
import 'package:capitan_sin_google/src/api/negocios_api.dart';
import 'package:capitan_sin_google/src/database/canchas_database.dart';
import 'package:capitan_sin_google/src/database/negocios_database.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:rxdart/rxdart.dart';

class NegociosBloc {
  final prefs = Preferences();
  final negociosDatabase = NegociosDatabase();
  final negociosApi = NegociosApi();
  final canchasApi = CanchasApi();
  final canchasDatabase = CanchasDatabase();
  final _negociosController = BehaviorSubject<List<NegociosModelResult>>();
  final _negociosPorIdController = BehaviorSubject<List<NegociosModelResult>>();
  final _misNegociosController = BehaviorSubject<List<NegociosModelResult>>();
  final _cargandoNegociosController = BehaviorSubject<bool>();

  Stream<List<NegociosModelResult>> get negociosStream => _negociosController.stream;
  Stream<List<NegociosModelResult>> get negociosPorIdStream => _negociosPorIdController.stream;
  Stream<List<NegociosModelResult>> get misNegociosStream => _misNegociosController.stream;
  Stream<bool> get cargandoNegociosStream => _cargandoNegociosController.stream;

  dispose() {
    _negociosController?.close();
    _cargandoNegociosController?.close();
    _misNegociosController?.close();
    _negociosPorIdController?.close();
  }

  void cargandoFalse() {
    _cargandoNegociosController.sink.add(false);
  }

  void obtenerNegocios() async {
    _cargandoNegociosController.sink.add(true);
    _negociosController.sink.add(await listarNegocios());
    if (prefs.idUser.toString().isNotEmpty && prefs.idUser != null) {
      await negociosApi.cargarNegocios();
    } else {
      await negociosApi.cargarNegociosSinLogeo();
    }

    _negociosController.sink.add(await listarNegocios());
    _cargandoNegociosController.sink.add(false);
  }

  void obtenerMisNegocios() async {
    _cargandoNegociosController.sink.add(true);
    _misNegociosController.sink.add(await negociosDatabase.obtenerMisNegocios());
    /*  await negociosApi.cargarNegocios();
    _misNegociosController.sink.add(await negociosDatabase.obtenerMisNegocios()); */
    _cargandoNegociosController.sink.add(false);
  }

  void obtenernegociosPorId(String idNegocio) async {
    _negociosPorIdController.sink.add(await negocitosPorId(idNegocio));
    await canchasApi.obtenerCanchasPorIdEmpresa(idNegocio);
    _negociosPorIdController.sink.add(await negocitosPorId(idNegocio));
  }

  Future<List<NegociosModelResult>> listarNegocios() async {
    String distancia = '0';

    final List<NegociosModelResult> lista = [];

    final negociosList = await negociosDatabase.obtenerNegocios();
    if (negociosList.length > 0) {
      for (var i = 0; i < negociosList.length; i++) {
        NegociosModelResult negociosModelResult = NegociosModelResult();

        //var metrosDistance = distance *1000;

        negociosModelResult.nombre = negociosList[i].nombre;
        negociosModelResult.idEmpresa = negociosList[i].idEmpresa;
        negociosModelResult.direccion = negociosList[i].direccion;
        negociosModelResult.telefono1 = negociosList[i].telefono1;
        negociosModelResult.telefono2 = negociosList[i].telefono2;
        negociosModelResult.lat = negociosList[i].lat;
        negociosModelResult.lon = negociosList[i].lon;
        negociosModelResult.descripcion = negociosList[i].descripcion;
        negociosModelResult.valoracion = negociosList[i].valoracion;
        negociosModelResult.foto = negociosList[i].foto;
        negociosModelResult.estado = negociosList[i].estado;
        negociosModelResult.usuario = negociosList[i].usuario;
        negociosModelResult.distrito = negociosList[i].distrito;
        negociosModelResult.horarioLs = negociosList[i].horarioLs;
        negociosModelResult.horarioD = negociosList[i].horarioD;
        negociosModelResult.fechaActual = negociosList[i].fechaActual;
        negociosModelResult.horaActual = negociosList[i].horaActual;
        negociosModelResult.dia = negociosList[i].dia;
        negociosModelResult.distancia = distancia.toString();

        negociosModelResult.promedio = negociosList[i].promedio;
        negociosModelResult.conteo = negociosList[i].conteo;

        negociosModelResult.posicion = negociosList[i].posicion;
        negociosModelResult.soyAdmin = negociosList[i].soyAdmin;
        lista.add(negociosModelResult);
      }
    }

    return lista;
  }

  Future<List<NegociosModelResult>> negocitosPorId(String idNegocio) async {
    final List<NegociosModelResult> listResult = [];
    final List<String> listaidDeportes = [];

    final negociosList = await negociosDatabase.obtenerNegocioPorId(idNegocio);

    if (negociosList.length > 0) {
      for (var i = 0; i < negociosList.length; i++) {
        final List<CanchaDeporte> listacanchex = [];
        NegociosModelResult negociosModelResult = NegociosModelResult();
        negociosModelResult.nombre = negociosList[i].nombre;
        negociosModelResult.idEmpresa = negociosList[i].idEmpresa;
        negociosModelResult.direccion = negociosList[i].direccion;
        negociosModelResult.telefono1 = negociosList[i].telefono1;
        negociosModelResult.telefono2 = negociosList[i].telefono2;
        negociosModelResult.lat = negociosList[i].lat;
        negociosModelResult.lon = negociosList[i].lon;
        negociosModelResult.descripcion = negociosList[i].descripcion;
        negociosModelResult.valoracion = negociosList[i].valoracion;
        negociosModelResult.foto = negociosList[i].foto;
        negociosModelResult.estado = negociosList[i].estado;
        negociosModelResult.usuario = negociosList[i].usuario;
        negociosModelResult.distrito = negociosList[i].distrito;
        negociosModelResult.horarioLs = negociosList[i].horarioLs;
        negociosModelResult.horarioD = negociosList[i].horarioD;
        negociosModelResult.fechaActual = negociosList[i].fechaActual;
        negociosModelResult.horaActual = negociosList[i].horaActual;
        negociosModelResult.dia = negociosList[i].dia;
        negociosModelResult.distancia = negociosList[i].distancia;

        negociosModelResult.promedio = negociosList[i].promedio;
        negociosModelResult.conteo = negociosList[i].conteo;

        negociosModelResult.posicion = negociosList[i].posicion;
        negociosModelResult.soyAdmin = negociosList[i].soyAdmin;

        final canchas = await canchasDatabase.obtenerCanchasPorIdEmpresaAgrupadoPorDeporteTipo(negociosModelResult.idEmpresa);

        if (canchas.length > 0) {
          for (var x = 0; x < canchas.length; x++) {
            listaidDeportes.add(canchas[x].deporteTipo);
          }
        }
        for (var j = 0; j < listaidDeportes.length; j++) {
          final canchaListFinal = await canchasDatabase.obtenerCanchasPorDeporteTipo(negociosModelResult.idEmpresa, listaidDeportes[j]);
          final List<CanchasResult> canchex = [];
          if (canchaListFinal.length > 0) {
            CanchaDeporte canchaDeporte = CanchaDeporte();
            canchaDeporte.deporteNombre = canchaListFinal[0].deporte;

            for (var y = 0; y < canchaListFinal.length; y++) {
              CanchasResult canchas = CanchasResult();

              canchas.canchaId = canchaListFinal[y].canchaId;
              canchas.idEmpresa = canchaListFinal[y].idEmpresa;
              canchas.nombre = canchaListFinal[y].nombre;
              canchas.dimensiones = canchaListFinal[y].dimensiones;
              canchas.precioD = canchaListFinal[y].precioD;
              canchas.precioN = canchaListFinal[y].precioN;
              canchas.foto = canchaListFinal[y].foto;
              canchas.fechaActual = canchaListFinal[y].fechaActual;
              canchas.tipo = canchaListFinal[y].tipo;
              canchas.tipoNombre = canchaListFinal[y].tipoNombre;
              canchas.deporteTipo = canchaListFinal[y].deporteTipo;
              canchas.deporte = canchaListFinal[y].deporte;
              canchas.promoPrecio = canchaListFinal[y].promoPrecio;
              canchas.promoInicio = canchaListFinal[y].promoInicio;
              canchas.promoFin = canchaListFinal[y].promoFin;
              canchas.promoEstado = canchaListFinal[y].promoEstado;

              canchex.add(canchas);
            }
            canchaDeporte.canchasList = canchex;
            listacanchex.add(canchaDeporte);
          }
        }
        negociosModelResult.canchasDeporte = listacanchex;
        listResult.add(negociosModelResult);
      }
    }
    print('result');
    return listResult;
  }
}



import 'package:capitan_sin_google/src/database/canchas_database.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:rxdart/rxdart.dart';

class PromocionesEmpresasBloc {
  final canchasDatabase = CanchasDatabase();

  final _canchasConPromocionesController = BehaviorSubject<List<CanchasResult>>();

  Stream<List<CanchasResult>> get canchasConPromocionesStream => _canchasConPromocionesController.stream;

  dispose() {
    _canchasConPromocionesController?.close();
  }

  void obtenerCanchasConPromociones(String idEmpresa) async {
    final List<CanchasResult> canchitas = [];
    final listCanchas = await canchasDatabase.obtenerCanchasConPromociones(idEmpresa);

    if (listCanchas.length > 0) {
      for (var i = 0; i < listCanchas.length; i++) {
        CanchasResult canchas = CanchasResult();

        canchas.canchaId = listCanchas[i].canchaId;
        canchas.idEmpresa = listCanchas[i].idEmpresa;
        canchas.nombre = listCanchas[i].nombre;
        canchas.dimensiones = listCanchas[i].dimensiones;
        canchas.precioD = listCanchas[i].precioD;
        canchas.precioN = listCanchas[i].precioN;
        canchas.foto = listCanchas[i].foto;
        canchas.tipo = listCanchas[i].tipo;
        canchas.tipoNombre = listCanchas[i].tipoNombre;
        canchas.deporteTipo = listCanchas[i].deporteTipo;
        canchas.deporte = listCanchas[i].deporte;
        canchas.promoPrecio = listCanchas[i].promoPrecio;
        canchas.promoInicio = listCanchas[i].promoInicio;
        canchas.promoFin = listCanchas[i].promoFin;
        canchas.promoEstado = listCanchas[i].promoEstado;
        canchas.canchaEstado = listCanchas[i].canchaEstado;
        canchas.comisionCancha = listCanchas[i].comisionCancha;
        //canchitas.add(canchas);
        var fechaInicioPromo = DateTime.parse(listCanchas[i].promoInicio);
        fechaInicioPromo.add(new Duration(days: 1));
        var fechaFinPromo = DateTime.parse(listCanchas[i].promoFin);
        fechaFinPromo = fechaFinPromo.add(new Duration(days: 0));

        DateTime now = DateTime.now();

        if (now.isAfter(fechaInicioPromo)) {
          if (now.isBefore(fechaFinPromo)) {
            canchitas.add(canchas);
          } else {}
        } else {} 
      }
    }

    _canchasConPromocionesController.sink.add(canchitas);
  }
}

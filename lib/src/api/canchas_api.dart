import 'dart:convert';

import 'package:capitan_sin_google/src/database/canchas_database.dart';
import 'package:capitan_sin_google/src/database/negocios_database.dart';
import 'package:capitan_sin_google/src/database/reservas_database.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../models/canchas_model.dart';

class CanchasApi {
  final canchasDatabase = CanchasDatabase();
  final reservasDatabase = ReservasDatabase();
  final neogociosDatabase = NegociosDatabase();
  final prefs = new Preferences();

  Future<bool> obtenerCanchasPorIdEmpresa(String id) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/listar_canchas_por_id_empresa');

      final resp = await http.post(url, body: {
        'id_empresa': id,
        'app': 'true',
        'tn': prefs.token,
      });

      final decodedData = json.decode(resp.body);

      if (decodedData['results'].length > 0) {
        for (int i = 0; i < decodedData['results'].length; i++) {
          CanchasResult canchas = CanchasResult();

          canchas.canchaId = decodedData['results'][i]['cancha_id'];
          canchas.idEmpresa = decodedData['results'][i]['id_empresa'];
          canchas.nombre = decodedData['results'][i]['nombre'];
          canchas.dimensiones = decodedData['results'][i]['dimensiones'];
          canchas.precioD = decodedData['results'][i]['precioD'];
          canchas.precioN = decodedData['results'][i]['precioN'];
          canchas.foto = decodedData['results'][i]['foto'];
          canchas.fechaActual = decodedData['results'][i]['fecha_actual'];
          canchas.tipo = decodedData['results'][i]['id_tipo'];
          canchas.tipoNombre = decodedData['results'][i]['tipo'];
          canchas.deporteTipo = decodedData['results'][i]['id_deporte'];
          canchas.deporte = decodedData['results'][i]['deporte'];
          canchas.promoPrecio = decodedData['results'][i]['promo_precio'];
          canchas.promoInicio = decodedData['results'][i]['promo_inicio'];
          canchas.promoFin = decodedData['results'][i]['promo_fin'];
          canchas.promoEstado = decodedData['results'][i]['promo_estado'];

          await canchasDatabase.insertarMisCanchas(canchas);
        }

        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<List<CanchasResult>> obtenerCanchasPorId(String idCancha, String fecha, String hora) async {
    final negocioDatabase = NegociosDatabase();
    final List<CanchasResult> list = [];
    var horarioOficial = formatHora(hora);
    String horex;

    final listCancha = await canchasDatabase.obtenerCanchasPorId(idCancha);
    final listEmpresa = await negocioDatabase.obtenerNegocioPorId(listCancha[0].idEmpresa);

    if (listCancha.length > 0) {
      var promoEstado = listCancha[0].promoEstado;
      var promoInicio = listCancha[0].promoInicio;
      var promoFin = listCancha[0].promoFin;
      var promoPrecio = listCancha[0].promoPrecio;

      var precioD = listCancha[0].precioD;
      var precioN = listCancha[0].precioN;

      String precio;
      if (horarioOficial > 18) {
        precio = precioN.toString();
      } else {
        precio = precioD.toString();
      }

      String precioOficial;

      CanchasResult cr = CanchasResult();

      if (promoEstado == '0') {
        precioOficial = precio;

        cr.nombre = listCancha[0].nombre;
        cr.precioCancha = precioOficial;
        cr.nombreEmpresa = listEmpresa[0].nombre;
        cr.fotoEmpresa = listEmpresa[0].foto;
        list.add(cr);

        return list;
      } else {
        if (horarioOficial > 9) {
          horex = horarioOficial.toString();
        } else {
          horex = '0$horarioOficial';
        }
        DateTime fechaInicioPromo = DateTime.parse(promoInicio);
        fechaInicioPromo.add(new Duration(days: 1));
        DateTime fechaFinPromo = DateTime.parse(promoFin);
        fechaFinPromo.add(new Duration(days: 1));

        DateTime fechaActualEnDate = DateTime.parse('$fecha $horex:01:00');

        fechaActualEnDate.toIso8601String();

        if (fechaActualEnDate.isAfter(fechaInicioPromo)) {
          /* print(
                    'la fecha actual es mayor a la fecha de inicio de la promocion');

                */
          if (fechaActualEnDate.isBefore(fechaFinPromo)) {
            /*  print(
                      'la fecha actual es menor a la fecha de inicio de la promocion');
 */
            precioOficial = promoPrecio;
          } else {
            precioOficial = precio;
          }
        } else {
          precioOficial = precio;
        }

        cr.nombre = listCancha[0].nombre;
        cr.precioCancha = precioOficial;
        cr.fotoEmpresa = listEmpresa[0].foto;
        cr.nombreEmpresa = listEmpresa[0].nombre;
        list.add(cr);

        return list;
      }
    } else {
      return list;
    }
  }
}

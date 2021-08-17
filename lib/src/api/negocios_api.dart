import 'package:capitan_sin_google/src/database/negocios_database.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NegociosApi {
  final prefs = new Preferences();

  final negociosDatabase = NegociosDatabase();
  Future<bool> cargarNegocios() async {
    final url = Uri.parse('$apiBaseURL/api/Empresa/listar_empresas_por_id_ciudad');

    final resp = await http.post(url, body: {
      // 'id_usuario': prefs.idUser,
      'id_ciudad': prefs.ubigeoId,
      'app': 'true',
      'tn': prefs.token
    });

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData == null) return false;

    if (decodedData['results'].length > 0) {
      for (int i = 0; i < decodedData['results'].length; i++) {
        NegociosModelResult negocios = NegociosModelResult();
        negocios.idEmpresa = decodedData['results'][i]['id_empresa'];
        negocios.nombre = decodedData['results'][i]['nombre'];
        negocios.direccion = decodedData['results'][i]['direccion'];
        negocios.telefono1 = decodedData['results'][i]['telefono_1'];
        negocios.telefono2 = decodedData['results'][i]['telefono_2'];
        negocios.lat = decodedData['results'][i]['lat'];
        negocios.lon = decodedData['results'][i]['lon'];
        negocios.descripcion = decodedData['results'][i]['descripcion'];
        negocios.valoracion = decodedData['results'][i]['valoracion'];
        negocios.foto = decodedData['results'][i]['foto'];
        negocios.estado = decodedData['results'][i]['estado'];
        negocios.usuario = decodedData['results'][i]['usuario'];
        negocios.distrito = decodedData['results'][i]['distrito'];
        negocios.horarioLs = decodedData['results'][i]['horario_ls'];
        negocios.horarioD = decodedData['results'][i]['horario_d'];
        negocios.promedio = double.parse(decodedData['results'][i]['promedio'].toString());
        negocios.conteo = decodedData['results'][i]['conteo'];
        negocios.soyAdmin = decodedData['results'][i]['soy_admin'];
        negocios.posicion = (i + 1).toString();

        await negociosDatabase.insertarNegocio(negocios);
        var listGaleria = decodedData['results'][i]['galeria'];

        if (listGaleria.length > 0) {
          for (int x = 0; x < listGaleria.length; x++) {
            Galeria galeria = Galeria();
            galeria.idGaleria = listGaleria[x]['id_galeria'];
            galeria.idEmpresa = listGaleria[x]['id_empresa'];
            galeria.galeriaFoto = listGaleria[x]['galeria_foto'];

            await negociosDatabase.insertarGaleria(galeria);
          }
        }
      }

      return true;
    } else {
      return false;
    }
  }

  Future<bool> cargarNegociosSinLogeo() async {
    final url = Uri.parse('$apiBaseURL/api/Inicio/empresas_por_ciudad');
    final resp = await http.post(url, body: {
      'id_ciudad': '1',
    });

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData == null) return false;

    if (decodedData['results'].length > 0) {
      for (int i = 0; i < decodedData['results'].length; i++) {
        NegociosModelResult negocios = NegociosModelResult();
        negocios.idEmpresa = decodedData['results'][i]['id_empresa'];
        negocios.nombre = decodedData['results'][i]['nombre'];
        negocios.direccion = decodedData['results'][i]['direccion'];
        negocios.telefono1 = decodedData['results'][i]['telefono_1'];
        negocios.telefono2 = decodedData['results'][i]['telefono_2'];
        negocios.lat = decodedData['results'][i]['lat'];
        negocios.lon = decodedData['results'][i]['lon'];
        negocios.descripcion = decodedData['results'][i]['descripcion'];
        negocios.valoracion = decodedData['results'][i]['valoracion'];
        negocios.foto = decodedData['results'][i]['foto'];
        negocios.estado = decodedData['results'][i]['estado'];
        negocios.usuario = decodedData['results'][i]['usuario'];
        negocios.distrito = decodedData['results'][i]['distrito'];
        negocios.horarioLs = decodedData['results'][i]['horario_ls'];
        negocios.horarioD = decodedData['results'][i]['horario_d'];
        negocios.promedio = double.parse(decodedData['results'][i]['promedio'].toString());
        negocios.conteo = decodedData['results'][i]['conteo'];
        negocios.soyAdmin = decodedData['results'][i]['soy_admin'];
        negocios.posicion = (i + 1).toString();

        await negociosDatabase.insertarNegocio(negocios);
        var listGaleria = decodedData['results'][i]['galeria'];

        if (listGaleria.length > 0) {
          for (int x = 0; x < listGaleria.length; x++) {
            Galeria galeria = Galeria();
            galeria.idGaleria = listGaleria[x]['id_galeria'];
            galeria.idEmpresa = listGaleria[x]['id_empresa'];
            galeria.galeriaFoto = listGaleria[x]['galeria_foto'];

            await negociosDatabase.insertarGaleria(galeria);
          }
        }
      }

      return true;
    } else {
      return false;
    }
  }

  Future<int> agregarPromociones(String inicio, String fin, String precio, String idCancha) async {
    final url = Uri.parse('$apiBaseURL/api/Empresa/registrar_promo');

    final resp = await http.post(url, body: {
      'cancha_id': idCancha,
      'cancha_promo_precio': precio,
      'cancha_promo_inicio': inicio,
      'cancha_promo_fin': fin,
      'app': 'true',
      'tn': prefs.token
    });

    final decodedData = json.decode(resp.body);

    if (decodedData == 1) {
      return 1;
    } else {
      return 0;
    }
  }
}

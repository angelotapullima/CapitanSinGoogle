import 'dart:convert';
import 'package:capitan_sin_google/src/database/ciudades_database.dart';
import 'package:capitan_sin_google/src/database/publicidad_database.dart';
import 'package:capitan_sin_google/src/models/ciudades_model.dart';
import 'package:capitan_sin_google/src/models/publicidad_model.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class ConfigApi {
  final prefs = new Preferences();

  Future<bool> obtenerConfig() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Login/config_inicial');
      final ciudadesDatabase = CiudadesDatabase();
      final publicidadDatabase = PublicidadDatabase();
      bool ret = false;

      final resp = await http.post(
        url,
        body: {
          'app': 'true',
        },
      );

      final decodedData = json.decode(resp.body);
      if (decodedData['ciudades'].length > 0) {
        for (int i = 0; i < decodedData['ciudades'].length; i++) {
          CiudadesModel ciudadesModel = CiudadesModel();
          ciudadesModel.idCiudad = decodedData['ciudades'][i]['id_ubigeo'];
          ciudadesModel.ciudadNombre = decodedData['ciudades'][i]['ubigeo_ciudad'];

          await ciudadesDatabase.insertarCiudades(ciudadesModel);
        }

        ret = true;
      } else {
        ret = false;
      }

      //GUARDAR PUBLICIDAD TIPO 1
      if (decodedData['publicidad']['1'].length > 0) {
        for (int i = 0; i < decodedData['publicidad']['1'].length; i++) {
          PublicidadModel publicidadModel = PublicidadModel();
          publicidadModel.idPublicidad = decodedData['publicidad']['1'][i]['id_publicidad'];
          publicidadModel.ubigeoPublicidad = decodedData['publicidad']['1'][i]['id_ubigeo'];
          publicidadModel.imagenPublicidad = decodedData['publicidad']['1'][i]['publicidad_imagen'];
          publicidadModel.linkPublicidad = decodedData['publicidad']['1'][i]['publicidad_url'];
          publicidadModel.horaPublicidad = decodedData['publicidad']['1'][i]['publicidad_hora'];
          publicidadModel.diasPublicidad = decodedData['publicidad']['1'][i]['publicidad_dias'];
          publicidadModel.tipoPublicidad = decodedData['publicidad']['1'][i]['publicidad_tipo'];
          publicidadModel.estadoPublicidad = decodedData['publicidad']['1'][i]['publicidad_estado'];

          await publicidadDatabase.insertarPublicidad(publicidadModel);
        }
      }

      //GUARDAR PUBLICIDAD TIPO 2
      if (decodedData['publicidad']['2'].length > 0) {
        for (int i = 0; i < decodedData['publicidad']['2'].length; i++) {
          PublicidadModel publicidadModel = PublicidadModel();
          publicidadModel.idPublicidad = decodedData['publicidad']['2'][i]['id_publicidad'];
          publicidadModel.ubigeoPublicidad = decodedData['publicidad']['2'][i]['id_ubigeo'];
          publicidadModel.imagenPublicidad = decodedData['publicidad']['2'][i]['publicidad_imagen'];
          publicidadModel.linkPublicidad = decodedData['publicidad']['2'][i]['publicidad_url'];
          publicidadModel.horaPublicidad = decodedData['publicidad']['2'][i]['publicidad_hora'];
          publicidadModel.diasPublicidad = decodedData['publicidad']['2'][i]['publicidad_dias'];
          publicidadModel.tipoPublicidad = decodedData['publicidad']['2'][i]['publicidad_tipo'];
          publicidadModel.estadoPublicidad = decodedData['publicidad']['2'][i]['publicidad_estado'];

          await publicidadDatabase.insertarPublicidad(publicidadModel);
        }
      }

      //GUARDAR PUBLICIDAD TIPO 3
      if (decodedData['publicidad']['3'].length > 0) {
        for (int i = 0; i < decodedData['publicidad']['3'].length; i++) {
          PublicidadModel publicidadModel = PublicidadModel();
          publicidadModel.idPublicidad = decodedData['publicidad']['3'][i]['id_publicidad'];
          publicidadModel.ubigeoPublicidad = decodedData['publicidad']['3'][i]['id_ubigeo'];
          publicidadModel.imagenPublicidad = decodedData['publicidad']['3'][i]['publicidad_imagen'];
          publicidadModel.linkPublicidad = decodedData['publicidad']['3'][i]['publicidad_url'];
          publicidadModel.horaPublicidad = decodedData['publicidad']['3'][i]['publicidad_hora'];
          publicidadModel.diasPublicidad = decodedData['publicidad']['3'][i]['publicidad_dias'];
          publicidadModel.tipoPublicidad = decodedData['publicidad']['3'][i]['publicidad_tipo'];
          publicidadModel.estadoPublicidad = decodedData['publicidad']['3'][i]['publicidad_estado'];

          await publicidadDatabase.insertarPublicidad(publicidadModel);
        }
      }

      //GUARDAR PUBLICIDAD TIPO 4
      if (decodedData['publicidad']['4'].length > 0) {
        for (int i = 0; i < decodedData['publicidad']['4'].length; i++) {
          PublicidadModel publicidadModel = PublicidadModel();
          publicidadModel.idPublicidad = decodedData['publicidad']['4'][i]['id_publicidad'];
          publicidadModel.ubigeoPublicidad = decodedData['publicidad']['4'][i]['id_ubigeo'];
          publicidadModel.imagenPublicidad = decodedData['publicidad']['4'][i]['publicidad_imagen'];
          publicidadModel.linkPublicidad = decodedData['publicidad']['4'][i]['publicidad_url'];
          publicidadModel.horaPublicidad = decodedData['publicidad']['4'][i]['publicidad_hora'];
          publicidadModel.diasPublicidad = decodedData['publicidad']['4'][i]['publicidad_dias'];
          publicidadModel.tipoPublicidad = decodedData['publicidad']['4'][i]['publicidad_tipo'];
          publicidadModel.estadoPublicidad = decodedData['publicidad']['4'][i]['publicidad_estado'];

          await publicidadDatabase.insertarPublicidad(publicidadModel);
        }
      }

      prefs.versionApp = decodedData['version'].toStringAsFixed(2);
      print('Version p ${prefs.versionApp}');
      return ret;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }
}

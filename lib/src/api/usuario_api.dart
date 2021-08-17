import 'dart:convert';

import 'package:capitan_sin_google/src/api/login_api.dart';
import 'package:capitan_sin_google/src/database/usuario_database.dart';
import 'package:capitan_sin_google/src/models/saldo_model.dart';
import 'package:capitan_sin_google/src/models/user_register_model.dart';
import 'package:capitan_sin_google/src/models/usuario_model.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class UsuarioApi {
  final usuarioDatabase = UsuarioDatabase();
  final prefs = new Preferences();

  Future<bool> obtenerUsuarioPorId(idUser) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Usuario/perfil_app');

      final resp = await http.post(url, body: {'id_user': idUser, 'app': 'true', 'tn': prefs.token});

      final decodedData = json.decode(resp.body);

      UsuarioModel usuarioModel = UsuarioModel();

      usuarioModel.usuarioId = decodedData['result']['id_user'];
      usuarioModel.usuarioNombre = decodedData['result']['nombre'];
      usuarioModel.usuarioNickname = decodedData['result']['nickname'];
      usuarioModel.usuarioDni = decodedData['result']['dni'];
      usuarioModel.usuarioNacimiento = decodedData['result']['birthday'];
      usuarioModel.usuarioSexo = decodedData['result']['sexo'];
      usuarioModel.usuarioEmail = decodedData['result']['email'];
      usuarioModel.usuarioTelefono = decodedData['result']['celular'];
      usuarioModel.usuarioPosicion = decodedData['result']['posicion'];
      usuarioModel.usuarioHabilidad = decodedData['result']['habilidad'];
      usuarioModel.usuarioNumero = decodedData['result']['num'];
      usuarioModel.usuarioFoto = decodedData['result']['img'];
      usuarioModel.usuarioEstado = decodedData['result']['estado'];

      await usuarioDatabase.insertarUsuarioGeneral(usuarioModel);
      return true;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<List<SaldoResult>> obtenerSaldo3() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/obtener_saldo_actual');

      final resp = await http.post(url, body: {'id': prefs.idUser, 'app': 'true', 'tn': prefs.token});

      final decodedData = json.decode(resp.body);
      final List<SaldoResult> list = [];

      SaldoResult saldo = SaldoResult();
      saldo.cuentaSaldo = decodedData['results']['cuenta_saldo'];
      saldo.comision = decodedData['results']['comision'];
      list.add(saldo);

      return list;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return [];
    }
  }

  Future<int> changePass(String contra) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Datos/guardar_contrasenha');

      final resp = await http.post(url, body: {
        //'id_user': prefs.idUser,
        'contrasenha': contra,
        'app': 'true',
        'tn': prefs.token
      });

      final decodedData = json.decode(resp.body);

      return decodedData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 2;
    }
  }

  Future<int> changeNickname(String nickname) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Datos/guardar_contrasenha');

      final resp = await http.post(url, body: {
        //'id_user': prefs.idUser,
        'user_nickname': nickname,
        'app': 'true',
        'tn': prefs.token
      });

      final decodedData = json.decode(resp.body);

      return decodedData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 2;
    }
  }

  Future<int> editarPerfil(String posicion, String habilidad, String numero) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Datos/guardar_contrasenha');

      final resp = await http.post(url, body: {
        'id_user': prefs.idUser,
        'person_dni': '',
        'person_address': '',
        'user_posicion': posicion,
        'user_habilidad': habilidad,
        'user_num': numero,
        'app': 'true',
        'tn': prefs.token
      });

      final decodedData = json.decode(resp.body);

      return decodedData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 2;
    }
  }

  Future<int> editarDatosPerfil(UserRegisterModel datos) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Usuario/editar_usuario');

      final resp = await http.post(url, body: {
        'nombre': '${datos.nombre}',
        'apellido_paterno': '${datos.apellidoPaterno}',
        'apellido_materno': '${datos.apellidoMaterno}',
        'nacimiento': '${datos.nacimiento}',
        'posicion': '${datos.posicion}',
        'habilidad': '${datos.habilidad}',
        'nro_camiseta': '${datos.nfav}',
        'app': 'true',
        'tn': prefs.token
      });

      final decodedData = json.decode(resp.body);
      print(decodedData);
      if (decodedData['result']['code'] == 1) {
        prefs.personName = decodedData['result']['persona']['persona_nombre'];
        prefs.personSurname = '${decodedData['result']['persona']['apellido_paterno']} ${decodedData['result']['persona']['apellido_materno']}';
        prefs.apellidoPaterno = decodedData['result']['persona']['apellido_paterno'];
        prefs.apellidoMaterno = decodedData['result']['persona']['apellido_materno'];
        prefs.personBirth =
            (decodedData['result']['persona']['persona_nacimiento'] == null) ? '' : decodedData['result']['persona']['persona_nacimiento'];
        prefs.userPosicion = decodedData['result']['persona']['posicion'];
        prefs.userHabilidad = decodedData['result']['persona']['habilidad'];
        prefs.userNum = decodedData['result']['persona']['nro_camiseta'];
      }

      return decodedData['result']['code'];
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 2;
    }
  }

  Future<int> send(String pass) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/datos/guardar_contrasenha_app');
      final resp = await http.post(url, body: {'tn': prefs.token, 'contrasenha': '$pass', 'app': 'true'});
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        // final prodTemp = Data.fromJson(decodedData['data']);

        // //agrego los datos de usuario al sharePreferences
        // prefs.idUser = decodedData['data']['c_u'];
        // prefs.idCity = prodTemp.idCity;
        // prefs.idPerson = prodTemp.idPerson;
        // prefs.userNickname = prodTemp.userNickname;
        // prefs.userEmail = prodTemp.userEmail;
        // prefs.userImage = prodTemp.userImage;
        // prefs.personName = prodTemp.personName;
        // prefs.personSurname = prodTemp.personSurname;
        // prefs.idRoleUser = prodTemp.idRoleUser;
        // prefs.roleName = prodTemp.roleName;
        prefs.token = decodedData['data']['tn'];
        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  // ------------ Restablecer Contraseña ----------------

  //Envio de email para verificar si existe usuario
  Future<int> restablecerPass(String email) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Login/restaurar_clave');
      final resp = await http.post(url, body: {'email': '$email'});
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        prefs.idUser = decodedData['result']['data']['id_usuario'];
        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  //Envío del codigo de verificación
  Future<int> restablecerPass1(String param) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Login/restaurar_clave');
      final resp = await http.post(url, body: {'id': '${prefs.idUser}', 'param': '$param'});
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        prefs.idUser = decodedData['result']['data']['id_usuario'];
        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  //Envío de la nueva contraseña
  Future<int> restablecerPassOk(String pass) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Login/restaurar_clave');
      final resp = await http.post(url, body: {'id': '${prefs.idUser}', 'pass': '$pass'});
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        //prefs.idUser = decodedData['result']['data']['id_usuario'];
        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  //Cambiar contraseña
  Future<int> cambiarPassOk(String pass) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Usuario/restablecer_contrasenha');
      final resp = await http.post(url, body: {'id_usuario': '${prefs.idUser}', 'contrasenha': '$pass', 'app': 'true', 'tn': '${prefs.token}'});
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        final loginApi = LoginApi();
        await loginApi.login(prefs.userNickname, pass);
        //prefs.idUser = decodedData['result']['data']['id_usuario'];
        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }
}

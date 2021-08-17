import 'dart:convert';
import 'package:capitan_sin_google/src/preferencias/Preferencias%20Bufi%20Payments/preferencias_cuenta_bufiPay.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class VerificarEmailCuentaApi {
  final prefs = new Preferences();

  Future<int> verificarEmailUser(String codigo) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Usuario/validar_email');

      final resp = await http.post(
        url,
        body: {'codigo': codigo, 'app': 'true', 'tn': prefs.token},
      );

      final decodedData = json.decode(resp.body);

      if (decodedData['result']['code'] == 1) {
        prefs.userEmailValidateCode = '';
      }

      return decodedData['result']['code'];
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 2;
    }
  }

  Future<bool> enviarCodeEmail() async {
    try {
      final prefsBufiPay = PreferencesBufiPayments();
      final url = Uri.parse('$apiBaseURL/api/Inicio/enviar_email');

      final resp = await http.post(
        url,
        body: {'id_bufipay': prefsBufiPay.idUserBufiPay, 'app': 'true', 'tn': prefs.token},
      );

      final decodedData = json.decode(resp.body);
      print(decodedData);

      if (decodedData['result']['code']) {
        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }
}

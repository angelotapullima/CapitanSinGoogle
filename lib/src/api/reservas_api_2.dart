import 'dart:convert';
import 'package:capitan_sin_google/src/models/reserva_cancha_2.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class Reservas2Api {
  final prefs = new Preferences();

  Future<bool> pagarReservaCancha(ReservaCancha2Model reservaData) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/registrar_reserva2');

      print(reservaData.idCancha);
      print(reservaData.nombreReserva);
      print(reservaData.fecha);
      print(reservaData.hora);
      print(reservaData.telefono);
      print('tipoPago');
      print(reservaData.tipoUsuario);
      print('pago_tipo');
      print(reservaData.tipoPago);
      print('id_colaboracion');
      print(reservaData.idColaboracion);
      print(reservaData.pago1);
      print(reservaData.pagoComision);
      print(reservaData.estado);

      final resp = await http.post(url, body: {
        'id_cancha': reservaData.idCancha,
        'nombre': reservaData.nombreReserva,
        'fecha': reservaData.fecha,
        'hora': reservaData.horaReserva,
        'telefono': reservaData.telefono,
        'tipopago': reservaData.tipoUsuario,
        'pago_tipo': reservaData.tipoPago,
        'id_colaboracion': reservaData.idColaboracion,
        'pago1': reservaData.pago1,
        'pago_comision': reservaData.pagoComision,
        'estado': reservaData.estado,
        'app': 'true',
        'tn': prefs.token
      });

      final decodedData = json.decode(resp.body);
      if (decodedData == 1) {
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

import 'dart:convert';

import 'package:capitan_sin_google/src/database/canchas_database.dart';
import 'package:capitan_sin_google/src/database/negocios_database.dart';
import 'package:capitan_sin_google/src/database/reservas_database.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class ReservasApi {
  final prefs = new Preferences();

  final reservasDatabase = ReservasDatabase();
  final negociosDatabase = NegociosDatabase();
  final canchasDatabase = CanchasDatabase();

  Future<bool> reservarVerdeCliente(String idCancha, String pagoEquipoId, String nombre, String hora, String pago1, String pagoTipo,
      String idColaboracion, String pagoComision, String tipoPago, String estado, String fecha) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/registrar_reserva');

      final resp = await http.post(url, body: {
        'id_cancha': idCancha,
        'pago_id_user': prefs.idUser,
        'pago_equipo_id': pagoEquipoId,
        'nombre': nombre,
        'hora': hora,
        'pago1': pago1,
        'pago_tipo': pagoTipo,
        'id_colaboracion': idColaboracion,
        'pago_comision': pagoComision,
        'tipopago': tipoPago,
        'estado': estado,
        'fecha': fecha,
        'id_user': prefs.idUser,
        'app': 'true',
        'tn': prefs.token
      });

      print(resp.body);
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

  Future<int> reservaVerdeAdmin(
      String idCancha, String nombreReserva, String hora, String fecha, String monto, String estado, String telefono, String observaciones) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/registrar_reserva');

      print(
          "id_cancha': $idCancha,'id_user': ${prefs.idUser},'nombre': $nombreReserva,'hora': $hora, 'pago1': $monto,'tipopago': '3','estado': $estado,'fecha': $fecha,'app': 'true','token': ${prefs.token}'");
      final resp = await http.post(url, body: {
        'id_cancha': idCancha,
        'id_user': prefs.idUser,
        'nombre': nombreReserva,
        'telefono': telefono,
        'hora': hora,
        'pago1': monto,
        'tipopago': '0',
        'estado': estado,
        'fecha': fecha,
        'observaciones': observaciones,
        'app': 'true',
        'tn': prefs.token
      });

      print(resp.body);

      final decodedData = json.decode(resp.body);
      if (decodedData == 1) {
        return 1;
      } else {
        return 0;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }



  Future<int> reservaNaranPagoParcialjaAdmin(String idReserva, String pago1) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/actualizar_pago_1');

      final resp = await http.post(url, body: {
        'id': idReserva,
        //'id_user': prefs.idUser,
        'pago1': pago1,
        'app': 'true',
        'tn': prefs.token,
      });

      final decodedData = json.decode(resp.body);
      print(decodedData);
      if (decodedData == 1) {
        return 1;
      } else {
        return 0;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  Future<int> reservaNaranjaAdmin(String idReserva, String pago2) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/pagar_restante');

      final resp = await http.post(url, body: {
        'id': idReserva,
        'id_user': prefs.idUser,
        'pago2': pago2,
        'app': 'true',
        'tn': prefs.token,
      });

      final decodedData = json.decode(resp.body);
      if (decodedData == 1) {
        return 1;
      } else {
        return 0;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  Future<bool> cargarReservasPorFecha(String id, String fecha) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/listar_reservados_cancha_fecha');

      final resp = await http.post(url, body: {'id_cancha': id, 'fecha': fecha, 'app': 'true', 'tn': prefs.token});

      final decodedData = json.decode(resp.body);
      print('Resultados');
      print(decodedData);
      print('fin pe');

      if (decodedData['results'].length > 0) {
        for (int i = 0; i < decodedData['results'].length; i++) {
          ReservaModel reservasCanchasModel = ReservaModel();

          final reservasList = await reservasDatabase.obtenerReservasPorIdReserva(decodedData['results'][i]['reserva_id']);
          var canchaNombre = decodedData['results'][i]['cancha_nombre'];
          var empresaNombre = decodedData['results'][i]['empresa_nombre'];
          reservasCanchasModel.reservaId = decodedData['results'][i]['reserva_id'];
          reservasCanchasModel.reservaNombre = decodedData['results'][i]['nombre'];
          reservasCanchasModel.reservaFecha = decodedData['results'][i]['fecha'];
          reservasCanchasModel.reservaHora = decodedData['results'][i]['hora'];
          reservasCanchasModel.tipoPago = decodedData['results'][i]['tipopago'];
          reservasCanchasModel.pago1 = decodedData['results'][i]['pago1'];
          reservasCanchasModel.pago1Date = decodedData['results'][i]['pago1_date'];
          reservasCanchasModel.fechaFormateada1 = decodedData['results'][i]['fecha_formateada_1'];
          reservasCanchasModel.pago2 = decodedData['results'][i]['pago2'];
          reservasCanchasModel.pago2Date = decodedData['results'][i]['pago2_date'];
          reservasCanchasModel.fechaFormateada2 = decodedData['results'][i]['fecha_formateada_2'];
          reservasCanchasModel.canchaId = decodedData['results'][i]['cancha_id'];
          reservasCanchasModel.pagoId = decodedData['results'][i]['pago_id'];
          reservasCanchasModel.observacion = decodedData['results'][i]['observaciones'];
          //falta cliente
          reservasCanchasModel.nroOperacion = decodedData['results'][i]['nro_operacion'];
          if (double.parse(reservasCanchasModel.pago2) > 0) {
            reservasCanchasModel.concepto =
                'Reserva de cancha $canchaNombre de la empresa $empresaNombre de ${reservasCanchasModel.reservaHora} el dia ${reservasCanchasModel.reservaFecha} por pago parcial | Reserva de cancha $canchaNombre de la empresa $empresaNombre de ${reservasCanchasModel.reservaHora} el dia ${reservasCanchasModel.reservaFecha} por pago final';
          } else {
            reservasCanchasModel.concepto =
                'Reserva de cancha $canchaNombre de la empresa $empresaNombre de ${reservasCanchasModel.reservaHora} el dia ${reservasCanchasModel.reservaFecha}';
          }
          //reserva.concepto = concepto;
          reservasCanchasModel.monto = decodedData['results'][i]['monto'].toString();
          reservasCanchasModel.comision = decodedData['results'][i]['comision'].toString();
          //reservasCanchasModel.dia = decodedData['results'][i]['dia'];
          reservasCanchasModel.reservaEstado = decodedData['results'][i]['estado'];

          if (reservasList.length > 0) {
            reservasCanchasModel.cliente = reservasList[0].cliente;
          } else {
            reservasCanchasModel.cliente = '';
          }

          await reservasDatabase.insertarReservas(reservasCanchasModel);
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

  Future<List<ReservaModel>> obtenerReservasPorFechayPorIDCancha(String idCancha, String fechex, String diaDeLaSemana) async {
    final List<ReservaModel> listGeneral = [];

    final listReservas = await reservasDatabase.obtenerReservasCanchas(idCancha, fechex);
    final listaCancha = await canchasDatabase.obtenerCanchasPorId(idCancha);
    final negocio = await negociosDatabase.obtenerNegocioPorId(listaCancha[0].idEmpresa);

    if (listaCancha.length > 0) {
      String horariodeAperturaYcierre;
      if (diaDeLaSemana == '7') {
        horariodeAperturaYcierre = negocio[0].horarioD;
      } else {
        horariodeAperturaYcierre = negocio[0].horarioLs;
      }
      final horarioNegocio = horariodeAperturaYcierre.split('-');
      final hAperturaNegocio = formatHora(horarioNegocio[0].trim());
      final hCierreNegocio = formatHora(horarioNegocio[1].trim());

      //sirve para validar la hora de apertura de acuerdo a la hora que llega del servidor
      final dateActual = listaCancha[0].fechaActual.split(' ');
      final fechaActual = dateActual[0].trim();
      final horaActual = formatHora(dateActual[1].trim());

      int horaAperturaOficial;
      if (negocio[0].soyAdmin.toString() == "1") {
        horaAperturaOficial = hAperturaNegocio;
      } else {
        if (fechaActual == fechex) {
          if (horaActual >= hAperturaNegocio) {
            horaAperturaOficial = horaActual+1;
          } else {
            horaAperturaOficial = hAperturaNegocio;
          }
        } else {
          horaAperturaOficial = hAperturaNegocio;
        }
      }

      String precioPromocionEstado = '0';
      String horaFinal;
      String horaCancha;

      String promoEstado = listaCancha[0].promoEstado;
      String promoInicio = listaCancha[0].promoInicio;
      String promoFin = listaCancha[0].promoFin;
      String promoPrecio = listaCancha[0].promoPrecio;

      //horaAperturaOficial = horaAperturaOficial + 1;

      for (int i = horaAperturaOficial; i < hCierreNegocio; i++) {
        int horaFin = i + 1;
        int hini = i;
        horaCancha = '$hini:00 - $horaFin:00';
        if (horaFin > 12) {
          horaFin = horaFin - 12;
          if (hini > 12) {
            hini = hini - 12;
          }
          horaFinal = '$hini:00 - $horaFin:00 pm';
        } else {
          horaFinal = '$i:00 - $horaFin:00 am';
        }

        String precioCancha;
        String precioCanchaOficial;
        if (i >= 18) {
          precioCancha = listaCancha[0].precioN;
        } else {
          precioCancha = listaCancha[0].precioD;
        }

        if (promoEstado == '0') {
          precioCanchaOficial = precioCancha;
        } else {
          String horaParse;
          if (i > 9) {
            horaParse = i.toString();
          } else {
            horaParse = '0$i';
          }

          var fechaInicioPromo = DateTime.parse(promoInicio);
          fechaInicioPromo.add(new Duration(days: 1));
          var fechaFinPromo = DateTime.parse(promoFin);
          fechaFinPromo = fechaFinPromo.add(new Duration(days: 0));

          DateTime fechaActualEnDate = DateTime.parse('$fechex $horaParse:01:00');

          fechaActualEnDate.toIso8601String();

          if (fechaActualEnDate.isAfter(fechaInicioPromo)) {
            if (fechaActualEnDate.isBefore(fechaFinPromo)) {
              precioCanchaOficial = promoPrecio;
              precioPromocionEstado = '1';
            } else {
              precioCanchaOficial = precioCancha;
              precioPromocionEstado = '0';
            }
          } else {
            precioCanchaOficial = precioCancha;
              precioPromocionEstado = '0';
          }
        }

        ReservaModel reserva = ReservaModel();
        bool hayReserva = false;
        for (int x = 0; x < listReservas.length; x++) {
          final hora = obtenerHoraInicio(listReservas[x].reservaHora, '-');

          if (i == hora) {
            hayReserva = true;
            reserva.reservaId = listReservas[x].reservaId;
            reserva.reservaFecha = fechex;
            reserva.diaDeLaSemana = diaDeLaSemana;
            reserva.precioPromocionEstado = precioPromocionEstado;
            reserva.reservaPrecioCancha = precioCanchaOficial;
            reserva.reservaEstado = listReservas[x].reservaEstado;
            reserva.reservaNombre = listReservas[x].reservaNombre;
            reserva.pago1 = listReservas[x].pago1;
            reserva.reservaHora = horaFinal;
            reserva.empresaNombre = negocio[0].nombre;
            reserva.reservaHoraCancha = horaCancha;
          }
        }

        if (!hayReserva) {
          reserva.reservaFecha = fechex;
          reserva.reservaPrecioCancha = precioCanchaOficial;
          reserva.reservaEstado = '0';
          reserva.diaDeLaSemana = diaDeLaSemana;
          reserva.precioPromocionEstado = precioPromocionEstado;
          reserva.reservaNombre = 'cagados';
          reserva.reservaHora = horaFinal;
          reserva.empresaNombre = negocio[0].nombre;
          reserva.reservaHoraCancha = horaCancha;
        }
        reserva.comision = listaCancha[0].comisionCancha;

        listGeneral.add(reserva);
      }
    }
    //horario de apertura y cierre de acuerdo al dia de la semana
    //print('hola');
    return listGeneral;
  }

  
  Future<List<ReservaModel>> obtenerReservaPorIdReserva(String idReserva) async {
    final List<ReservaModel> list = [];
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/listar_reserva_por_id');

      final resp = await http.post(url, body: {'id_reserva': idReserva, 'app': 'true', 'tn': prefs.token});

      print('mare ${resp.body}');

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);

        final reservasList = await reservasDatabase.obtenerReservasPorIdReserva(decodedData['results'][0]['id_reserva']);

        ReservaModel reserva = ReservaModel();

        String concepto;
        var canchaNombre = decodedData['results'][0]['cancha_nombre'];
        var empresaNombre = decodedData['results'][0]['empresa_nombre'];

        reserva.reservaId = decodedData['results'][0]['id_reserva'];
        reserva.reservaNombre = decodedData['results'][0]['reserva_nombre'];
        reserva.reservaFecha = decodedData['results'][0]['reserva_fecha'];
        reserva.reservaHora = decodedData['results'][0]['reserva_hora'];
        reserva.tipoPago = decodedData['results'][0]['tipo_pago'];
        reserva.pago1 = decodedData['results'][0]['reserva_pago1'];
        reserva.pago2 = decodedData['results'][0]['reserva_pago2'];
        reserva.pago1Date = decodedData['results'][0]['reserva_pago1_date'];
        reserva.fechaFormateada1 = decodedData['results'][0]['fecha_formateada_1'];
        reserva.pago2Date = decodedData['results'][0]['reserva_pago2_date'];
        reserva.fechaFormateada2 = decodedData['results'][0]['fecha_formateada_2'];
        reserva.canchaId = decodedData['results'][0]['cancha_id'];
        reserva.idUser = decodedData['results'][0]['id_user'];
        reserva.pagoId = reservasList[0].pagoId;
        reserva.observacion = decodedData['results'][0]['reserva_observaciones'];
        //no hay pagoID
        reserva.cliente = decodedData['results'][0]['nombre_user'];
        reserva.nroOperacion = decodedData['results'][0]['nro_operacion'];
        reserva.reservaEstado = decodedData['results'][0]['reserva_estado'];
        reserva.comision = decodedData['results'][0]['comision'].toString();
        reserva.monto = decodedData['results'][0]['monto'].toString();
        if (double.parse(reserva.pago2) > 0) {
          concepto =
              'Reserva de cancha $canchaNombre de la empresa $empresaNombre de ${reserva.reservaHora} el dia ${reserva.reservaFecha} por pago parcial | Reserva de cancha $canchaNombre de la empresa $empresaNombre de ${reserva.reservaHora} el dia ${reserva.reservaFecha} por pago final';
        } else {
          concepto = 'Reserva de cancha $canchaNombre de la empresa $empresaNombre de ${reserva.reservaHora} el dia ${reserva.reservaFecha}';
        }
        reserva.concepto = concepto;

        if (reservasList.length > 0) {
          reserva.pagoId = reservasList[0].pagoId;
        } else {
          reserva.pagoId = '';
        }
        await reservasDatabase.insertarReservas(reserva);
        list.add(reserva);

        return list;
      } else {
        return list;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return list;
    }
  }

  Future<bool> listarReservasPorUsuario() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/listar_reservas_por_usuario');

      final resp = await http.post(url, body: {
        //'id_usuario': prefs.idUser,
        'app': 'true',
        'tn': prefs.token
      });

      final decodedData = json.decode(resp.body);
      print(decodedData);

      if (decodedData['results'].length > 0) {
        for (var i = 0; i < decodedData['results'].length; i++) {
          ReservaModel reserva = ReservaModel();

          String concepto;
          var canchaNombre = decodedData['results'][i]['cancha_nombre'];
          var empresaNombre = decodedData['results'][i]['empresa_nombre'];

          reserva.reservaId = decodedData['results'][i]['reserva_id'];
          reserva.reservaNombre = decodedData['results'][i]['reserva_nombre'];
          reserva.reservaFecha = decodedData['results'][i]['reserva_fecha'];
          reserva.reservaHora = decodedData['results'][i]['reserva_hora'];
          reserva.tipoPago = decodedData['results'][i]['reserva_tipopago'];
          reserva.pago1 = decodedData['results'][i]['reserva_pago1'];
          reserva.pago2 = decodedData['results'][i]['reserva_pago2'];
          reserva.pago1Date = decodedData['results'][i]['reserva_pago1_date'];
          reserva.fechaFormateada1 = decodedData['results'][i]['fecha_formateada_1'];
          reserva.pago2Date = decodedData['results'][i]['reserva_pago2_date'];
          reserva.fechaFormateada2 = decodedData['results'][i]['fecha_formateada_2'];
          reserva.canchaId = decodedData['results'][i]['cancha_id'];
          reserva.empresaId = decodedData['results'][i]['id_empresa'];
          reserva.pagoId = decodedData['results'][i]['pago_id'];
          reserva.idUser = decodedData['results'][i]['id_user'];
          //no hay pagoID
          reserva.cliente = '${prefs.personName} ${prefs.personSurname}';
          reserva.nroOperacion = decodedData['results'][0]['transferencia_u_e_nro_operacion'];
          reserva.reservaEstado = decodedData['results'][0]['reserva_estado'];
          reserva.comision = decodedData['results'][0]['pago_comision'].toString();
          reserva.monto = decodedData['results'][0]['pago_monto'].toString();

          if (double.parse(reserva.pago2) > 0) {
            concepto =
                'Reserva de cancha $canchaNombre de la empresa $empresaNombre de ${reserva.reservaHora} el dia ${reserva.reservaFecha} por pago parcial | Reserva de cancha $canchaNombre de la empresa $empresaNombre de ${reserva.reservaHora} el dia ${reserva.reservaFecha} por pago final';
          } else {
            concepto = 'Reserva de cancha $canchaNombre de la empresa $empresaNombre de ${reserva.reservaHora} el dia ${reserva.reservaFecha}';
          }
          reserva.concepto = concepto;
          await reservasDatabase.insertarReservas(reserva);

          final listCanchas = await canchasDatabase.obtenerCanchasPorId(decodedData['results'][i]['cancha_id']);

          CanchasResult canchasResult = CanchasResult();

          canchasResult.idEmpresa = decodedData['results'][i]['id_empresa'];
          canchasResult.canchaId = decodedData['results'][i]['cancha_id'];
          canchasResult.nombre = decodedData['results'][i]['cancha_nombre'];
          canchasResult.dimensiones = decodedData['results'][i]['cancha_dimensiones'];
          canchasResult.precioD = decodedData['results'][i]['cancha_precioD'];
          canchasResult.precioN = decodedData['results'][i]['cancha_precioN'];
          canchasResult.foto = decodedData['results'][i]['cancha_foto'];
          canchasResult.fechaActual = (listCanchas.length > 0) ? listCanchas[0].fechaActual : '';
          canchasResult.promoPrecio = decodedData['results'][i]['cancha_promo_precio'];
          canchasResult.promoInicio = decodedData['results'][i]['cancha_promo_inicio'];
          canchasResult.promoFin = decodedData['results'][i]['cancha_promo_fin'];
          canchasResult.promoEstado = decodedData['results'][i]['cancha_promo_estado'];

          await canchasDatabase.insertarMisCanchas(canchasResult);
        }

        return true;
      } else {
        return false;
      }

      /* if (decodedData == 1) {
        return 1;
      } else {
        return 0;
      } */
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<int> cancelarReserva(String idReserva) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/anular_reserva');

      final resp = await http.post(url, body: {'id': idReserva, 'app': 'true', 'tn': prefs.token});

      final decodedData = json.decode(resp.body);
      if (decodedData == 1) {
        await reservasDatabase.deleteReservasPorId(idReserva);
        return 1;
      } else {
        return 0;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }
}

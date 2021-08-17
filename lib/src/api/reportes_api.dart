import 'dart:collection';
import 'dart:convert';
import 'package:capitan_sin_google/src/database/reporte_mensual_database.dart';
import 'package:capitan_sin_google/src/database/reporte_semanal_database.dart';
import 'package:capitan_sin_google/src/database/reservas_database.dart';
import 'package:capitan_sin_google/src/models/reporte_mensual_model.dart';
import 'package:capitan_sin_google/src/models/reporte_model.dart';
import 'package:capitan_sin_google/src/models/reporte_semanal_model.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalle_canchas_page.dart';
import 'package:capitan_sin_google/src/preferencias/preferencias_usuario.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;

class ReporteApi {
  final prefs = new Preferences();
  final reporteSemanalDatabase = ReporteSemanalDatabase();
  final reporteMensualDatabase = ReporteMensualDatabase();
  final reservasDatabase = ReservasDatabase();

  Future<int> cargarResportesPorEmpresaAPI(String idEmpresa, String fechaf, String fechai) async {
    print('buscando reportes');

    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/estadisticas_por_empresa');
      var fechex = fechai;
      var fechexDate;
      var fechita;

      final resp = await http.post(url, body: {'id_empresa': idEmpresa, 'fecha_i': fechai, 'fecha_f': fechaf, 'app': 'true', 'tn': prefs.token});

      final decodedData = json.decode(resp.body);

      //final listDReport = List<ReporteModel>();

      for (int i = 0; i < decodedData['results'].length; i++) {
        if (i != 0) {
          fechex = formatDate(fechexDate, [yyyy, '-', mm, '-', dd]).toString();
          print(fechex);
        }
        fechita = decodedData['results'][i][fechex];
        for (int x = 0; x < fechita.length; x++) {
          ReservaModel reporte = ReservaModel();

          reporte.reservaId = fechita[x]['reserva_id'];
          reporte.canchaId = fechita[x]['cancha_id'];
          reporte.idUser = fechita[x]['id_user'];
          reporte.tipoPago = fechita[x]['reserva_tipopago'];
          reporte.canchaNombre = fechita[x]['cancha_nombre'];
          reporte.pagoId = fechita[x]['cancha_nombre'];
          reporte.reservaNombre = fechita[x]['reserva_nombre'];
          reporte.reservaFecha = fechita[x]['reserva_fecha'];
          reporte.reservaHora = fechita[x]['reserva_hora'];
          reporte.telefono = fechita[x]['reserva_telefono'];
          reporte.pago1 = fechita[x]['reserva_pago1'];
          reporte.pago1Date = fechita[x]['reserva_pago1_date'];
          reporte.pago2 = fechita[x]['reserva_pago2'];
          reporte.pago2Date = fechita[x]['reserva_pago2_date'];
          reporte.reservaEstado = fechita[x]['reserva_estado'];
          reporte.empresaId = fechita[x]['empresa_id'];
          //listDReport.add(reporte);

          await reservasDatabase.insertarReservas(reporte);
          //todo lo que se tiene que hacer con los modelos

        }

        fechexDate = DateTime.parse(fechex);
        fechexDate = toDateMonthYear(
          fechexDate.add(
            Duration(days: 1),
          ),
        );
      }

      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  Future<List<ReporteListFecha>> cargarResportesPorEmpresaDatabase(String fechaInicial, String fechaFinal, String idEmpresa) async {
    final listDatos = await reservasDatabase.obtenerReportePorRangoDeFechaDeEmpresa(fechaInicial, fechaFinal, idEmpresa);

    List<ReporteListFecha> listFechas = [];
    List<String> listStringFechas = [];
    var fecha;

    for (int i = 0; i < listDatos.length; i++) {
      fecha = listDatos[i].reservaFecha;
      listStringFechas.add(fecha);
    }

    listStringFechas = LinkedHashSet<String>.from(listStringFechas).toList();

    for (int x = 0; x < listStringFechas.length; x++) {
      ReporteListFecha reporteListFecha = ReporteListFecha();
      List<ReservaModel> modeloList = [];
      for (int y = 0; y < listDatos.length; y++) {
        if (listStringFechas[x] == listDatos[y].reservaFecha) {
          ReservaModel rep = ReservaModel();
          rep.reservaId = listDatos[y].reservaId;
          rep.reservaNombre = listDatos[y].reservaNombre;
          rep.reservaFecha = listDatos[y].reservaFecha;
          rep.reservaHora = listDatos[y].reservaHora;
          rep.tipoPago = listDatos[y].tipoPago;
          rep.pago1 = listDatos[y].pago1;
          rep.pago1Date = listDatos[y].pago1Date;
          rep.pago2 = listDatos[y].pago2;
          rep.pago2Date = listDatos[y].pago2Date;
          rep.canchaId = listDatos[y].canchaId;
          rep.empresaId = listDatos[y].empresaId;
          rep.idUser = listDatos[y].idUser;
          rep.reservaEstado = listDatos[y].reservaEstado;
          rep.empresaId = listDatos[y].empresaId;

          rep.canchaNombre = listDatos[y].canchaNombre;

          /* var pagoFinalito =double.parse(rep.reservaPago1) + double.parse(rep.reservaPago2);
          rep.precioFinal = pagoFinalito.toString(); */

          modeloList.add(rep);
        }
      }

      var monto = 0.0;
      for (int xy = 0; xy < modeloList.length; xy++) {
        monto = monto + double.parse(modeloList[xy].pago1) + double.parse(modeloList[xy].pago2);
      }
      reporteListFecha.reservaFecha = listStringFechas[x];
      reporteListFecha.listFechas = await filtrarPorCanchaID(modeloList);
      reporteListFecha.monto = monto.toString();
      listFechas.add(reporteListFecha);
    }
    print('algo más');
    return listFechas;
  }

  Future<List<ReporteListCancha>> filtrarPorCanchaID(List<ReservaModel> reporte) async {
    final List<ReporteListCancha> listCanchas = [];
    var canchaID;

    List<String> listStringCanchaID = [];

    for (int i = 0; i < reporte.length; i++) {
      canchaID = reporte[i].canchaNombre;
      listStringCanchaID.add(canchaID);
    }

    listStringCanchaID = LinkedHashSet<String>.from(listStringCanchaID).toList();

    for (int x = 0; x < listStringCanchaID.length; x++) {
      ReporteListCancha reporteListCancha = ReporteListCancha();
      List<ReservaModel> modeloList = [];
      for (int y = 0; y < reporte.length; y++) {
        if (listStringCanchaID[x] == reporte[y].canchaNombre) {
          ReservaModel rep = ReservaModel();
          rep.reservaId = reporte[y].reservaId;
          rep.reservaNombre = reporte[y].reservaNombre;
          rep.reservaFecha = reporte[y].reservaFecha;
          rep.reservaHora = reporte[y].reservaHora;
          rep.tipoPago = reporte[y].tipoPago;
          rep.pago1 = reporte[y].pago1;
          rep.pago1Date = reporte[y].pago1Date;
          rep.pago2 = reporte[y].pago2;
          rep.pago2Date = reporte[y].pago2Date;
          rep.canchaId = reporte[y].canchaId;
          rep.empresaId = reporte[y].empresaId;
          rep.idUser = reporte[y].idUser;
          rep.reservaEstado = reporte[y].reservaEstado;
          rep.empresaId = reporte[y].empresaId;

          rep.canchaNombre = reporte[y].canchaNombre;
          /* var pagoFinalito = double.parse(rep.reservaPago1) + double.parse(rep.reservaPago2);
          rep.precioFinal = pagoFinalito.toString(); */

          modeloList.add(rep);
        }
      }

      var monto = 0.0;
      for (int xy = 0; xy < modeloList.length; xy++) {
        monto = monto + double.parse(modeloList[xy].pago1) + double.parse(modeloList[xy].pago2);
      }
      reporteListCancha.canchaNombre = listStringCanchaID[x];
      reporteListCancha.listCanchas = modeloList;
      reporteListCancha.monto = monto.toString();
      listCanchas.add(reporteListCancha);
    }

    return listCanchas;
  }

  Future<int> cargarReporteSemanalPorEmpresa(String idEmpresa) async {
    print('buscando reportes semanal');

    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/reporte_semanal_cancha');

      final resp = await http.post(url, body: {'id_empresa': idEmpresa, 'app': 'true', 'tn': prefs.token});

      final decodedData = json.decode(resp.body);

      for (int x = 0; x < decodedData['data'].length; x++) {
        var datos = decodedData['data'][x];

        for (var i = 0; i < datos['info'].length; i++) {
          ReporteSemanalModel reporte = ReporteSemanalModel();
          reporte.idReporteSemanal = '${datos['info'][i]['${i + 1}']['fecha']}${decodedData['data'][x]['id_cancha']}';
          reporte.idCancha = decodedData['data'][x]['id_cancha'];
          reporte.fechaReporte = datos['info'][i]['${i + 1}']['fecha'];
          reporte.monto = datos['info'][i]['${i + 1}']['monto'];
          reporte.cantidad = datos['info'][i]['${i + 1}']['cant'];

          await reporteSemanalDatabase.insertarReporteSemanal(reporte);

          print('ingreso semanal ${datos['info'][i]['${i + 1}']['fecha']} -  ${decodedData['data'][x]['id_cancha']}');
        }
      }

      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  Future<int> cargarReporteMensualPorEmpresa(String idEmpresa) async {
    print('buscando reportes mensual');

    try {
      final url = Uri.parse('$apiBaseURL/api/Empresa/reporte_mensual_cancha');

      final resp = await http.post(url, body: {'id_empresa': idEmpresa, 'app': 'true', 'tn': prefs.token});

      final decodedData = json.decode(resp.body);

      //final listDReport = List<ReporteModel>();

      for (int x = 0; x < decodedData['data'].length; x++) {
        var datos = decodedData['data'][x];

        for (var i = 0; i < datos['info'].length; i++) {
          String anho;
          var fechaIni = datos['info'][i]['semana_data']['fecha_i'].toString();
          List fechexNac = fechaIni.split('-');
          anho = fechexNac[0].trim();

          ReporteMensualModel reporte = ReporteMensualModel();
          reporte.idReporteMensual = "$anho${datos['info'][i]['semana']}";
          reporte.idCancha = decodedData['data'][x]['id_cancha'].toString();
          reporte.anho = anho;
          reporte.numeroSemana = datos['info'][i]['semana'].toString();
          reporte.fechaInicio = fechaIni;
          reporte.fechaFinal = datos['info'][i]['semana_data']['fecha_f'].toString();
          reporte.monto = datos['info'][i]['semana_data']['monto'].toString();
          reporte.cantidad = datos['info'][i]['semana_data']['cant'].toString();
          //listDReport.add(reporte);

          await reporteMensualDatabase.insertarReporteMensual(reporte);

          print('ingreso mensual');
          //todo lo que se tiene que hacer con los modelos

        }
      }

      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }
}


//me llegvasa L POUEBBERJOV3R 


//ouwbfuerbfiuerf eiug bueogbterg
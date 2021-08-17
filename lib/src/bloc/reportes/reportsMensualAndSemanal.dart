import 'package:capitan_sin_google/src/api/reportes_api.dart';
import 'package:capitan_sin_google/src/api/reservas_api.dart';
import 'package:capitan_sin_google/src/database/canchas_database.dart';
import 'package:capitan_sin_google/src/database/reporte_mensual_database.dart';
import 'package:capitan_sin_google/src/database/reporte_semanal_database.dart';
import 'package:capitan_sin_google/src/database/reservas_database.dart';
import 'package:capitan_sin_google/src/models/reporte_mensual_model.dart';
import 'package:capitan_sin_google/src/models/reporte_semanal_model.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/detalle_canchas_page.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class ReportsMensualAndSemanalBloc {
  final reporteSemanalDatabase = ReporteSemanalDatabase();
  final reportMensualDatabase = ReporteMensualDatabase();
  final reservasApi = ReservasApi();

  final reservasDatabase = ReservasDatabase();
  final canchasDatabase = CanchasDatabase();
  final reportesApi = ReporteApi();

  final _reporteSemanalController = BehaviorSubject<List<ReportsData>>();
  final _reporteDiarioController = BehaviorSubject<List<ReservaModel>>();
  final _reporteMensualController = BehaviorSubject<List<ReportsData>>();

  Stream<List<ReportsData>> get reporteSemanalStream => _reporteSemanalController.stream;
  Stream<List<ReservaModel>> get reporteDiarioStream => _reporteDiarioController.stream;
  Stream<List<ReportsData>> get reporteMensualStream => _reporteMensualController.stream;

  dispose() {
    _reporteSemanalController?.close();
    _reporteDiarioController?.close();
    _reporteMensualController?.close();
  }

  void obtenerReportePorDia(String fecha, String id) async {
    _reporteDiarioController.sink.add(await reservasDatabase.obtenerReservasCanchas(id, fecha));
    await reservasApi.cargarReservasPorFecha(id, fecha);
    _reporteDiarioController.sink.add(await reservasDatabase.obtenerReservasCanchas(id, fecha));
  }

  void obtenerReporteSemanal(String idEmpresa) async {
    _reporteSemanalController.sink.add(await reportesSemana(idEmpresa));
    await reportesApi.cargarReporteSemanalPorEmpresa(idEmpresa);
    _reporteSemanalController.sink.add(await reportesSemana(idEmpresa));
  }

  void obtenerReporteMensual(String idEmpresa) async {
    _reporteMensualController.sink.add(await reportesMensual(idEmpresa));
    await reportesApi.cargarReporteMensualPorEmpresa(idEmpresa);
    _reporteMensualController.sink.add(await reportesMensual(idEmpresa));
  }

  Future<List<ReportsData>> reportesSemana(String idEmpresa) async {
    final List<ReportsData> listGeneral = [];

    final listCanchas = await canchasDatabase.obtenerCanchasPorIdEmpresa(idEmpresa);

    if (listCanchas.length > 0) {
      for (var y = 0; y < listCanchas.length; y++) {
        final List<ReporteSemanalModel> listReports = [];
        int cantidadAdelante = 0;
        int cantidadAtras = 0;

        ReportsData reporteGeneral = ReportsData();
        reporteGeneral.nombreCancha = listCanchas[y].nombre;

        var idCanchaPorLaPtm = listCanchas[y].canchaId;
        DateTime today = DateTime.now();

        var weekday = today.weekday;

        if (weekday > 1) {
          cantidadAdelante = 8 - weekday;
          cantidadAtras = 7 - cantidadAdelante;
        } else {
          cantidadAdelante = 7;
        }

        print('cantidadAtras $cantidadAtras');

        DateTime datePre;
        String date = '';

        if (cantidadAtras > 0) {
          today = toDateMonthYear(
            today.subtract(
              Duration(days: cantidadAtras),
            ),
          );

          date = "${today.year.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
          for (var i = 0; i < cantidadAtras; i++) {
            final listPartidosReserva = await reporteSemanalDatabase.obtenerReporteSemanalPorID('$date$idCanchaPorLaPtm');

            if (listPartidosReserva.length <= 0) {
              ReporteSemanalModel reportsData = ReporteSemanalModel();

              reportsData.fechaReporte = date;
              reportsData.monto = '';
              reportsData.dia = '${today.day.toString().padLeft(2, '0')}';
              reportsData.mes = '${today.month.toString().padLeft(2, '0')}';
              reportsData.cantidad = '';
              reportsData.idCancha = idCanchaPorLaPtm;

              listReports.add(reportsData);
            } else {
              for (var x = 0; x < listPartidosReserva.length; x++) {
                String mes;
                String dia;

                final fechaFormatinicio = listPartidosReserva[x].fechaReporte.split("-");
                mes = fechaFormatinicio[1].trim();
                dia = fechaFormatinicio[2].trim();
                ReporteSemanalModel reportsData = ReporteSemanalModel();

                reportsData.fechaReporte = listPartidosReserva[x].fechaReporte;
                reportsData.monto = listPartidosReserva[x].monto;
                reportsData.dia = dia;
                reportsData.mes = obtenerMesPorNumero(int.parse(mes));
                reportsData.cantidad = listPartidosReserva[x].cantidad;
                reportsData.idCancha = listCanchas[y].canchaId;

                listReports.add(reportsData);
              }
            }

            datePre = toDateMonthYear(
              today.add(
                Duration(days: 1),
              ),
            );

            today = datePre;
            date = "${datePre.year.toString().padLeft(2, '0')}-${datePre.month.toString().padLeft(2, '0')}-${datePre.day.toString().padLeft(2, '0')}";
          }
        }

        date = '';
        if (cantidadAdelante > 0) {
          today = DateTime.now();
          date = "${today.year.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
          for (var i = 0; i < cantidadAdelante; i++) {
            final listPartidosReserva = await reporteSemanalDatabase.obtenerReporteSemanalPorID('$date$idCanchaPorLaPtm');

            if (listPartidosReserva.length <= 0) {
              ReporteSemanalModel reportsData = ReporteSemanalModel();

              reportsData.fechaReporte = date;
              reportsData.monto = '';
              reportsData.dia = '${today.day.toString().padLeft(2, '0')}';
              reportsData.mes = '${today.month.toString().padLeft(2, '0')}';
              reportsData.cantidad = '';
              reportsData.idCancha = listCanchas[y].canchaId;

              listReports.add(reportsData);
            } else {
              for (var x = 0; x < listPartidosReserva.length; x++) {
                String mes;
                String dia;

                final fechaFormatinicio = listPartidosReserva[x].fechaReporte.split("-");
                mes = fechaFormatinicio[1].trim();
                dia = fechaFormatinicio[2].trim();
                ReporteSemanalModel reportsData = ReporteSemanalModel();

                reportsData.fechaReporte = listPartidosReserva[x].fechaReporte;
                reportsData.monto = listPartidosReserva[x].monto;
                reportsData.dia = dia;
                reportsData.mes = obtenerMesPorNumero(int.parse(mes));
                reportsData.cantidad = listPartidosReserva[x].cantidad;
                reportsData.idCancha = listCanchas[y].canchaId;

                listReports.add(reportsData);
              }
            }

            datePre = toDateMonthYear(
              today.add(
                Duration(days: 1),
              ),
            );

            today = datePre;
            date = "${datePre.year.toString().padLeft(2, '0')}-${datePre.month.toString().padLeft(2, '0')}-${datePre.day.toString().padLeft(2, '0')}";
          }
        }
        double mayor = 0;
        for (var i = 0; i < listReports.length; i++) {
          var montex = (listReports[i].monto == 'null' || listReports[i].monto.isEmpty)
              ? 0
              : (double.parse(listReports[i].monto) > 0)
                  ? double.parse(listReports[i].monto)
                  : 0.0;
          if (mayor < montex) {
            mayor = montex;
            print('dentro $mayor');
          } else {
            print('fuera $montex');
          }
        }
        reporteGeneral.reportesSemanal = listReports;
        reporteGeneral.montoMaximo = (mayor + 50).toString();
        listGeneral.add(reporteGeneral);
      }
    }
    return listGeneral;
  }

  Future<List<ReportsData>> reportesMensual(String idEmpresa) async {
    final List<ReportsData> listGeneral = [];

    final listCanchas = await canchasDatabase.obtenerCanchasPorIdEmpresa(idEmpresa);
    DateTime today = DateTime.now();

    if (listCanchas.length > 0) {
      for (var y = 0; y < listCanchas.length; y++) {
        final List<ReporteMensualModel> listReportsMensual = [];
        ReportsData reporteGeneral = ReportsData();
        reporteGeneral.nombreCancha = listCanchas[y].nombre;

        final listReports = await reportMensualDatabase.obtenerReportesMensualPorAnoeIdEmpresa(today.year.toString(), listCanchas[y].canchaId);

        if (listReports.length > 0) {
          for (var x = 0; x < 4; x++) {
            ReporteMensualModel reportsData = ReporteMensualModel();
            reportsData.numeroSemana = listReports[x].numeroSemana;
            reportsData.anho = listReports[x].anho;
            reportsData.fechaInicio = listReports[x].fechaInicio;
            reportsData.fechaFinal = listReports[x].fechaFinal;
            reportsData.monto = listReports[x].monto;
            reportsData.cantidad = listReports[x].cantidad;
            reportsData.idCancha = listCanchas[y].canchaId;

            listReportsMensual.add(reportsData);
          }
        }
        double mayor = 0;

        for (var i = 0; i < listReportsMensual.length; i++) {
          if (listReportsMensual[i].monto == '' || listReportsMensual[i].monto == null || listReportsMensual[i].monto == 'null') {
          } else {
            if (mayor < double.parse(listReportsMensual[i].monto)) {
              mayor = double.parse(listReportsMensual[i].monto);
              print('dentro $mayor');
            } else {
              print('fuera ${double.parse(listReportsMensual[i].monto)}');
            }
          }
        }
        reporteGeneral.reportesMensual = listReportsMensual;
        reporteGeneral.montoMaximo = mayor.toString();
        listGeneral.add(reporteGeneral);
      }
    }
    print('djnvfv');
    return listGeneral;
  }
}
/* 
class ReporteGeneral {
  String namePeach;
  List<ReportsData> listRepots;
} */

class ReportsData {
  String nombreCancha;
  String montoMaximo;

  List<ReporteSemanalModel> reportesSemanal;
  List<ReporteMensualModel> reportesMensual;

  ReportsData({
    this.nombreCancha,
    this.montoMaximo,
    this.reportesMensual,
    this.reportesSemanal,
  });
}

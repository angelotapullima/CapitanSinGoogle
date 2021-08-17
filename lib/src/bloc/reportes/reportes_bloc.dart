import 'package:capitan_sin_google/src/api/reportes_api.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/database/canchas_database.dart';
import 'package:capitan_sin_google/src/database/reservas_database.dart';
import 'package:capitan_sin_google/src/models/reporte_mensual_model.dart';
import 'package:capitan_sin_google/src/models/reporte_model.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:week_of_year/week_of_year.dart';

class ReporteBloc {
  final reporteApi = ReporteApi();
  final canchaDatabase = CanchasDatabase();
  final reservasDatabase = ReservasDatabase();

  final _reportePorFechas = new BehaviorSubject<List<ReporteListFecha>>();
  final _reporteDetalladoPorFechas = new BehaviorSubject<List<ReporteListFecha>>();
  final _semanasController = new BehaviorSubject<List<ReporteMensualModel>>();
  final _cargandoReportes = new BehaviorSubject<bool>();

  //Recuperaer los datos del Stream
  Stream<List<ReporteListFecha>> get reportesPorFechas => _reportePorFechas.stream;
  Stream<List<ReporteListFecha>> get reportesDetalladoPorFechasStream => _reporteDetalladoPorFechas.stream;
  Stream<List<ReporteMensualModel>> get listSemanasStream => _semanasController.stream;
  Stream<bool> get cargadoReportStream => _cargandoReportes.stream;

  dispose() {
    _reportePorFechas.close();
    _reporteDetalladoPorFechas.close();
    _cargandoReportes.close();
    _semanasController.close();
  }

  void obtenerReportesPorFechasDeEmpresa(String fechaInicial, String fechaFinal, String idEmpresa) async {
    _cargandoReportes.sink.add(false);
    _reportePorFechas.sink.add(await reporteApi.cargarResportesPorEmpresaDatabase(fechaInicial, fechaFinal, idEmpresa));
    await reporteApi.cargarResportesPorEmpresaAPI(idEmpresa, fechaFinal, fechaInicial);
    _reportePorFechas.sink.add(
      await reporteApi.cargarResportesPorEmpresaDatabase(fechaInicial, fechaFinal, idEmpresa),
    );
    _cargandoReportes.sink.add(true);
  }

  void obtenerReportesPorFechasDeCancha(String fechaInicial, String fechaFinal, String idCancha, String idEmpresa) async {
    _cargandoReportes.sink.add(false);
    _reporteDetalladoPorFechas.sink.add(await reportePorFechasDeCancha(fechaInicial, fechaFinal, idCancha));
    await reporteApi.cargarResportesPorEmpresaAPI(idEmpresa, fechaFinal, fechaInicial);
    _reporteDetalladoPorFechas.sink.add(await reportePorFechasDeCancha(fechaInicial, fechaFinal, idCancha));
    _cargandoReportes.sink.add(true);
  }

  //funcion para obtener los dias de inicio y final del reporte de semanas agrupadas en el mes
  void obtenerListDeSemanas(BuildContext context, String idCancha) async {
    final List<ReporteMensualModel> list = [];

    final datosCancha = await canchaDatabase.obtenerCanchasPorId(idCancha);

    DateTime dateFinal;
    int numeroDeDiasARestar = 0;
    final date = DateTime.now();
    var numeroSemana = date.weekOfYear;

    final diaDeLaSemana = date.weekday;

    if (diaDeLaSemana != 1) {
      numeroDeDiasARestar = diaDeLaSemana - 1;
    }

    var dateInicio = date.subtract(Duration(days: numeroDeDiasARestar));

    for (var i = 0; i < numeroSemana; i++) {
      dateInicio = dateInicio.subtract(Duration(days: i == 0 ? 0 : 7));
      dateFinal = dateInicio.add(Duration(days: 6));

      var fechaInicio =
          "${dateInicio.year.toString().padLeft(2, '0')}-${dateInicio.month.toString().padLeft(2, '0')}-${dateInicio.day.toString().padLeft(2, '0')}";
      var fechaFin =
          "${dateFinal.year.toString().padLeft(2, '0')}-${dateFinal.month.toString().padLeft(2, '0')}-${dateFinal.day.toString().padLeft(2, '0')}";

      if (i == 0 && datosCancha.length > 0) {
        final reporteBloc = ProviderBloc.reportes(context);
        reporteBloc.obtenerReportesPorFechasDeCancha(fechaInicio, fechaFin, idCancha, datosCancha[0].idEmpresa);
      }

      ReporteMensualModel reporteMensualModel = ReporteMensualModel();
      reporteMensualModel.numeroSemana = (numeroSemana - i).toString();
      reporteMensualModel.fechaInicio = fechaInicio;
      reporteMensualModel.fechaFinal = fechaFin;
      list.add(reporteMensualModel);
    }

    _semanasController.sink.add(list);
  }

  Future<List<ReporteListFecha>> reportePorFechasDeCancha(String fechaInicial, String fechaFinal, String idCancha) async {
    final List<ReporteListFecha> listGeneral = [];

    final List<String> fechasList = [];

    final listDatos = await reservasDatabase.obtenerReportePorRangoDeFechaDeCancha(fechaInicial, fechaFinal, idCancha);
    if (listDatos.length > 0) {
      for (var i = 0; i < listDatos.length; i++) {
        fechasList.add(listDatos[i].reservaFecha);
      }

      List<String> algo = fechasList.toSet().toList();

      if (algo.length > 0) {
        for (var x = 0; x < algo.length; x++) {
          final List<ReservaModel> listReservas = [];
          ReporteListFecha reporteListFecha = ReporteListFecha();
          reporteListFecha.reservaFecha = algo[x];

          for (var y = 0; y < listDatos.length; y++) {
            if (fechasList[x] == listDatos[y].reservaFecha) {
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
              var pagoFinalito = double.parse(rep.pago1) + double.parse(rep.pago2);
              rep.monto = pagoFinalito.toString();
              listReservas.add(rep);
            }
          }

          double monto = 0.0;

          if (listReservas.length > 0) {
            for (var z = 0; z < listReservas.length; z++) {
              monto = monto + double.parse(listReservas[z].monto);
            }
          }
          reporteListFecha.listaReservas = listReservas;
          reporteListFecha.cantidad = listReservas.length.toString();
          reporteListFecha.monto = monto.toString();
          listGeneral.add(reporteListFecha);
        }
      }
    }
    return listGeneral;
  }
}

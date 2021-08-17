import 'package:capitan_sin_google/src/models/reporte_mensual_model.dart';

import 'database_provider.dart';

class ReporteMensualDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarReporteMensual(ReporteMensualModel rmensual) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO ReporteMensualCancha (idReporteMensual,numeroSemana,anho,fechaInicio,"
          "fechaFinal,monto,cantidad,idCancha) "
          "VALUES ('${rmensual.idReporteMensual}','${rmensual.numeroSemana}','${rmensual.anho}','${rmensual.fechaInicio}',"
          "'${rmensual.fechaFinal}','${rmensual.monto}','${rmensual.cantidad}','${rmensual.idCancha}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  /*  Future<List<ReservasCanchasModel>> obtenerReservasPorIdReserva(String reservaId) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM ReservaCanchas where reserva_id ='$reservaId' ");

    List<ReservasCanchasModel> list = res.isNotEmpty
        ? res.map((c) => ReservasCanchasModel.fromJson(c)).toList()
        : [];

    return list;
  } */

  Future<List<ReporteMensualModel>> obtenerReporteMensualPorNumeroDeSemana(String numeroSemana, String idCancha) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM ReporteMensualCancha where numeroSemana='$numeroSemana'  and idCancha = '$idCancha'");

    List<ReporteMensualModel> list = res.isNotEmpty ? res.map((c) => ReporteMensualModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ReporteMensualModel>> obtenerReportesMensualPorAnoeIdEmpresa(String anho, String idCancha) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM ReporteMensualCancha where anho='$anho'  and idCancha = '$idCancha' order by numeroSemana asc");

    List<ReporteMensualModel> list = res.isNotEmpty ? res.map((c) => ReporteMensualModel.fromJson(c)).toList() : [];

    return list;
  }

  deleteReporteMensual() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ReporteMensualCancha");

    return res;
  }
}

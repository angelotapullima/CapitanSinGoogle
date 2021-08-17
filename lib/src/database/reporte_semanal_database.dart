import 'package:capitan_sin_google/src/models/reporte_semanal_model.dart';

import 'database_provider.dart';

class ReporteSemanalDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarReporteSemanal(ReporteSemanalModel rsemanal) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO ReporteSemanalCancha (idReporteSemanal,fechaReporte,monto,cantidad,idCancha) "
          "VALUES ('${rsemanal.idReporteSemanal}','${rsemanal.fechaReporte}','${rsemanal.monto}','${rsemanal.cantidad}','${rsemanal.idCancha}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<ReporteSemanalModel>> obtenerReporteSemanalPorID(String idReporte) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery('SELECT * FROM ReporteSemanalCancha where idReporteSemanal = "$idReporte"');

    List<ReporteSemanalModel> list = res.isNotEmpty ? res.map((c) => ReporteSemanalModel.fromJson(c)).toList() : [];

    return list;
  }

  deleteReporteSemanal() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ReporteSemanalCancha");

    return res;
  }
}

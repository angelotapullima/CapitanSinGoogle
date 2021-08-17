import 'package:capitan_sin_google/src/database/database_provider.dart';
import 'package:capitan_sin_google/src/models/visitas_canchas_model.dart';

class VisitasCanchasDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarVisitasCanchas(VisitasCanchasModel visitasCanchasModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert('INSERT OR REPLACE INTO VisitasCancha (idEmpresa,year,month,day,'
          'hour,minute,second) '
          'VALUES ("${visitasCanchasModel.idEmpresa}","${visitasCanchasModel.year}","${visitasCanchasModel.month}",'
          '"${visitasCanchasModel.day}","${visitasCanchasModel.hour}","${visitasCanchasModel.minute}","${visitasCanchasModel.second}")');

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<VisitasCanchasModel>> obtenerVistasCanchas() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM VisitasCancha");

    List<VisitasCanchasModel> list = res.isNotEmpty ? res.map((c) => VisitasCanchasModel.fromJson(c)).toList() : [];

    return list;
  }

  deleteVisitasCanchas() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM VisitasCancha');

    return res;
  }
}

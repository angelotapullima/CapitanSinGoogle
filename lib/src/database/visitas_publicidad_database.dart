import 'package:capitan_sin_google/src/database/database_provider.dart';
import 'package:capitan_sin_google/src/models/visitasPublicidadModel.dart';

class VisitasPublicidadDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarVisitasPublicidad(VisitasPublicidadModel visita) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert('INSERT OR REPLACE INTO VisitasPublicidad (idPublicidad,year,month,day,'
          'hour,minute,second) '
          'VALUES ("${visita.idPublicidad}","${visita.year}","${visita.month}",'
          '"${visita.day}","${visita.hour}","${visita.minute}","${visita.second}")');

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<VisitasPublicidadModel>> obtenerVistasPublicidad() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM VisitasPublicidad");

    List<VisitasPublicidadModel> list = res.isNotEmpty ? res.map((c) => VisitasPublicidadModel.fromJson(c)).toList() : [];

    return list;
  }

  deleteVisitasPublicidads() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM VisitasPublicidad');

    return res;
  }
}

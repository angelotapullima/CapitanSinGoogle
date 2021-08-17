import 'package:capitan_sin_google/src/models/publicidad_model.dart';

import 'database_provider.dart';

class PublicidadDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarPublicidad(PublicidadModel publicidad) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Publicidad (idPublicidad,ubigeoPublicidad,imagenPublicidad,linkPublicidad,horaPublicidad,diasPublicidad,tipoPublicidad,estadoPublicidad) "
          "VALUES ('${publicidad.idPublicidad}','${publicidad.ubigeoPublicidad}','${publicidad.imagenPublicidad}','${publicidad.linkPublicidad}','${publicidad.horaPublicidad}','${publicidad.diasPublicidad}','${publicidad.tipoPublicidad}','${publicidad.estadoPublicidad}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<PublicidadModel>> obtenerPublicidadPorTipoPublicidad(String tipoPublicidad) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Publicidad WHERE tipoPublicidad='$tipoPublicidad' AND  estadoPublicidad='1'");

    List<PublicidadModel> list = res.isNotEmpty ? res.map((c) => PublicidadModel.fromJson(c)).toList() : [];

    return list;
  }

  deletePublicidad() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Publicidad");

    return res;
  }
}

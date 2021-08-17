import 'package:capitan_sin_google/src/models/ciudades_model.dart';

import 'database_provider.dart';

class CiudadesDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarCiudades(CiudadesModel ciudad) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Ciudades (idCiudad,ciudad_departamento,ciudad_provincia,ciudad_nombre,ciudad_distrito,ciudad_cod) "
          "VALUES ('${ciudad.idCiudad}','${ciudad.ciudadDepartamento}','${ciudad.ciudadProvincia}','${ciudad.ciudadNombre}','${ciudad.ciudadDistrito}', '${ciudad.ciudadCod}')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<CiudadesModel>> obtenerCiudades() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Ciudades");

    List<CiudadesModel> list = res.isNotEmpty ? res.map((c) => CiudadesModel.fromJson(c)).toList() : [];

    return list;
  }
}

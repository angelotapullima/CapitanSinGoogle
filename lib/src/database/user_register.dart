import 'package:capitan_sin_google/src/models/user_register_model.dart';

import 'database_provider.dart';

class UserRegisterDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarUserg(UserRegisterModel userg) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO UserRegister (email,nombre,apellidoPaterno,apellidoMaterno,posicion,nfav,habilidad,sexo,telefono,nacimiento,idCiudad) "
          "VALUES ('${userg.email}','${userg.nombre}','${userg.apellidoPaterno}','${userg.apellidoMaterno}',"
          "'${userg.posicion}','${userg.nfav}','${userg.habilidad}','${userg.sexo}','${userg.telefono}','${userg.nacimiento}','${userg.idCiudad}')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<UserRegisterModel>> obtenerUserg() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM UserRegister");

    List<UserRegisterModel> list = res.isNotEmpty ? res.map((c) => UserRegisterModel.fromJson(c)).toList() : [];

    return list;
  }

  deleteUserRegister() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM UserRegister');
    print('borrando user');
    return res;
  }
}

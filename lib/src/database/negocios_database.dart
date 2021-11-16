import 'package:capitan_sin_google/src/database/database_provider.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';

class NegociosDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarNegocio(NegociosModelResult datos) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO Negocios (id_empresa,nombre,direccion,telefono_1,"
          "telefono_2,lat,lon,descripcion,valoracion,foto,estado,usuario,distrito,"
          "horario_ls,horario_d,promedio,conteo,posicion,soy_admin) "
          "VALUES ('${datos.idEmpresa}','${datos.nombre}','${datos.direccion}','${datos.telefono1}',"
          "'${datos.telefono2}','${datos.lat}','${datos.lon}','${datos.descripcion}',${datos.valoracion},"
          "'${datos.foto}','${datos.estado}','${datos.usuario}',"
          "'${datos.distrito}','${datos.horarioLs}','${datos.horarioD}',${datos.promedio},"
          "'${datos.conteo}','${datos.posicion}',${datos.soyAdmin})");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  insertarGaleria(Galeria galeria) async {
    final db = await dbprovider.database;

    final res = await db.rawInsert("INSERT OR REPLACE INTO GaleriaNegocios (id_galeria,id_empresa,galeria_foto) "
        "VALUES ('${galeria.idGaleria}','${galeria.idEmpresa}','${galeria.galeriaFoto}')");

    return res;
  }

  Future<List<NegociosModelResult>> obtenerNegocios() async {
    final db = await dbprovider.database;
    //final res = await db.rawQuery("SELECT * FROM Negocios where estado = '1' order by CAST(posicion AS INT)");
    final res = await db.rawQuery("SELECT * FROM Negocios  order by CAST(posicion AS INT)");

    List<NegociosModelResult> list = res.isNotEmpty ? res.map((c) => NegociosModelResult.fromJsonDatabase(c)).toList() : [];

    //print(algo.items[0].nombre);

    return list;
  }

  Future<List<NegociosModelResult>> obtenerMisNegocios() async {
    final db = await dbprovider.database;
    //final res = await db.rawQuery("SELECT * FROM Negocios where estado = '1' and soy_admin = '1' order by CAST(posicion AS INT) ");
    final res = await db.rawQuery("SELECT * FROM Negocios where soy_admin = '1' order by CAST(posicion AS INT) ");

    List<NegociosModelResult> list = res.isNotEmpty ? res.map((c) => NegociosModelResult.fromJsonDatabase(c)).toList() : [];

    //print(algo.items[0].nombre);

    return list;
  }

  Future<List<NegociosModelResult>> obtenerNegocioPorId(String id) async {
    final db = await dbprovider.database;
    //final res = await db.rawQuery("SELECT * FROM Negocios where id_empresa ='$id' and estado = '1' ");
    final res = await db.rawQuery("SELECT * FROM Negocios where id_empresa ='$id'  ");

    List<NegociosModelResult> list = res.isNotEmpty ? res.map((c) => NegociosModelResult.fromJsonDatabase(c)).toList() : [];

    //print(algo.items[0].nombre);

    return list;
  }

  Future<List<Galeria>> obtenerGaleriaNegocios(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM GaleriaNegocios where id_empresa ='$id' ");

    List<Galeria> list = res.isNotEmpty ? res.map((c) => Galeria.fromJson(c)).toList() : [];

    //print(algo.items[0].nombre);

    return list;
  }

  deleteNegocios() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Negocios");

    return res;
  }

  deleteGaleriaNegocios() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM GaleriaNegocios");

    return res;
  }


  deleteGaleriaNegociosPorId(String id) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM GaleriaNegocios WHERE id_galeria='$id'");

    return res;
  }
}

import 'package:capitan_sin_google/src/models/canchas_model.dart';

import 'database_provider.dart';

class CanchasDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarMisCanchas(CanchasResult canchas) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Canchas (cancha_id,id_empresa,nombre,dimensiones,precioD,precioN,foto,fecha_actual,tipo,tipoNombre,deporte,deporteTipo,canchaEstado,promo_precio,promo_inicio,promo_fin,promo_estado) "
          "VALUES ('${canchas.canchaId}','${canchas.idEmpresa}','${canchas.nombre}','${canchas.dimensiones}','${canchas.precioD}','${canchas.precioN}','${canchas.foto}',"
          "'${canchas.fechaActual}','${canchas.tipo}','${canchas.tipoNombre}','${canchas.deporte}','${canchas.deporteTipo}','${canchas.canchaEstado}','${canchas.promoPrecio}','${canchas.promoInicio}','${canchas.promoFin}','${canchas.promoEstado}')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<CanchasResult>> obtenerCanchasPorIdEmpresa(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Canchas WHERE id_empresa='$id' and canchaEstado = '1' ");

    List<CanchasResult> list = res.isNotEmpty ? res.map((c) => CanchasResult.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<CanchasResult>> obtenerCanchasPorIdEmpresaAgrupadoPorDeporteTipo(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Canchas WHERE id_empresa='$id' and canchaEstado = '1' group by deporteTipo ");

    List<CanchasResult> list = res.isNotEmpty ? res.map((c) => CanchasResult.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<CanchasResult>> obtenerCanchasPorDeporteTipo(String idEmpresa, String deporteTipo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Canchas WHERE id_empresa='$idEmpresa'  and canchaEstado = '1' and deporteTipo = '$deporteTipo'");

    List<CanchasResult> list = res.isNotEmpty ? res.map((c) => CanchasResult.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<CanchasResult>> obtenerCanchasPorId(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Canchas WHERE cancha_id='$id' and canchaEstado = '1'");

    List<CanchasResult> list = res.isNotEmpty ? res.map((c) => CanchasResult.fromJson(c)).toList() : [];

    return list;
  }




  Future<List<CanchasResult>> obtenerCanchasConPromociones(String idNegocion) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Canchas WHERE  canchaEstado = '1' and promo_estado = '1' ");

    List<CanchasResult> list = res.isNotEmpty ? res.map((c) => CanchasResult.fromJson(c)).toList() : [];

    return list;
  }

  
  deleteCanchas() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Canchas");

    return res;
  }
}

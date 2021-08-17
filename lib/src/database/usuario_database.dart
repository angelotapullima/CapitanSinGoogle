import 'package:capitan_sin_google/src/models/usuario_model.dart';

import 'database_provider.dart';

class UsuarioDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarUsuarioGeneral(UsuarioModel usuario) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Usuario (usuarioId,usuarioRoId,usuarioUbigeoId,usuarioNombre,usuarioDni,usuarioNacimiento,"
          "usuarioSexo,usuarioEmail,usuarioTelefono,usuarioPosicion,usuarioHabilidad,usuarioNumero,usuarioFoto,usuarioTokenFirebase,usuarioSeleccionado,usuarioEstado) "
          "VALUES ('${usuario.usuarioId}','${usuario.usuarioRoId}','${usuario.usuarioUbigeoId}','${usuario.usuarioNombre}','${usuario.usuarioDni}',"
          "'${usuario.usuarioNacimiento}','${usuario.usuarioSexo}','${usuario.usuarioEmail}','${usuario.usuarioTelefono}','${usuario.usuarioPosicion}',"
          "'${usuario.usuarioHabilidad}','${usuario.usuarioNumero}','${usuario.usuarioFoto}','${usuario.usuarioTokenFirebase}','${usuario.usuarioSeleccionado}','${usuario.usuarioEstado}')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

/* 
  insertarUsuarioEquipo(String idUsuario, String idEquipo,String estado) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO UsuarioEquipos (usuarioId,equipo_id,equipo_usuario_estado) "
          "VALUES ('$idUsuario','$idEquipo','$estado')");
      return res;
    } catch (exception) {
      print(exception);
    }
  }


  actualizarEstadoUsuarioEquipo(String id , String estado)async{
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate(
          "UPDATE UsuarioEquipos SET equipo_usuario_estado='$estado' WHERE idUsuarioEquipo = '$id'");
      print(res);
      return res;
    } catch (exception) {
      print(exception);
    }

  }
  
   */
  updateEstadoSeleccionUsuario(String idUsuario, String estado) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate("UPDATE Usuario SET usuarioSeleccionado='$estado' WHERE usuarioId = '$idUsuario'");
      print(res);
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  updateEstadoUsuario() async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate("UPDATE Usuario SET usuarioSeleccionado= 0 ");
      print(res);
      return res;
    } catch (exception) {
      print(exception);
    }
  }

/* 
  Future<List<UsuarioModel>> obtenerJugadoresPorIdEquipo(
      String idEquipo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Usuario u  inner join UsuarioEquipos ue on ue.usuarioId=u.usuarioId WHERE equipo_id='$idEquipo' and equipo_usuario_estado= 0 ");

    List<UsuarioModel> list =
        res.isNotEmpty ? res.map((c) => UsuarioModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<UsuarioModel>> obtenerTablaUsuariosEquipos(
      String idUsuario, String idEquipo) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT * FROM UsuarioEquipos WHERE usuarioId='$idUsuario' and  equipo_id='$idEquipo'");

    List<UsuarioModel> list =
        res.isNotEmpty ? res.map((c) => UsuarioModel.fromJson(c)).toList() : [];

    return list;
  }
 */
  Future<List<UsuarioModel>> obtenerUsuarios() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Usuario ");

    List<UsuarioModel> list = res.isNotEmpty ? res.map((c) => UsuarioModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<UsuarioModel>> obtenerJugadoresPorDato(String dato) async {
    print(dato);
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Usuario where usuarioNombre LIKE '%$dato%'");

    List<UsuarioModel> list = res.isNotEmpty ? res.map((c) => UsuarioModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<UsuarioModel>> obtenerUsuariosPorId(String idUsuario) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Usuario where usuarioId='$idUsuario'");

    List<UsuarioModel> list = res.isNotEmpty ? res.map((c) => UsuarioModel.fromJson(c)).toList() : [];

    return list;
  }

  deleteUsuario() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM Usuario');

    return res;
  }
/* 
  deleteUsuarioEquipos()async{
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM UsuarioEquipos');
    
    return res;
  } */
}

import 'package:capitan_sin_google/src/models/reserva_model.dart';

import 'database_provider.dart';

class ReservasDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarReservas(ReservaModel reservas) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO Reservas ("
          "reserva_id,"
          "nombre,"
          "fecha,"
          "hora,"
          "telefono,"
          "tipopago,"
          "pago1,"
          "pago1_date,"
          "fecha_formateada_1,"
          "pago2,"
          "pago2_date,"
          "fecha_formateada_2,"
          "cancha_id,"
          "empresa_id,"
          "pago_id,"
          "cliente,"
          "numeroDeOperacion,"
          "concepto,"
          "monto,"
          "comision,"
          "idUser,"
          "observacion,"
          "estado ) "
          "VALUES ('${reservas.reservaId}','${reservas.reservaNombre}','${reservas.reservaFecha}',"
          "'${reservas.reservaHora}','${reservas.telefono}','${reservas.tipoPago}','${reservas.pago1}',"
          "'${reservas.pago1Date}','${reservas.fechaFormateada1}','${reservas.pago2}','${reservas.pago2Date}',"
          "'${reservas.fechaFormateada2}','${reservas.canchaId}','${reservas.empresaId}','${reservas.pagoId}','${reservas.cliente}',"
          "'${reservas.nroOperacion}','${reservas.concepto}','${reservas.monto}','${reservas.comision}','${reservas.idUser}',"
          "'${reservas.observacion}','${reservas.reservaEstado}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<ReservaModel>> obtenerReservasPorIdReserva(String reservaId) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Reservas where reserva_id ='$reservaId' ");

    List<ReservaModel> list = res.isNotEmpty ? res.map((c) => ReservaModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ReservaModel>> obtenerReservasCanchas(String idCancha, String fecha) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Reservas where cancha_id ='$idCancha' and fecha='$fecha' and estado<>'0' ");

    List<ReservaModel> list = res.isNotEmpty ? res.map((c) => ReservaModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ReservaModel>> obtenerReservaPorIdUsuario(String idUser) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Reservas where idUser ='$idUser' ");

    List<ReservaModel> list = res.isNotEmpty ? res.map((c) => ReservaModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ReservaModel>> obtenerReportePorRangoDeFechaDeCancha(String fechai, String fechaf, String idCancha) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Reservas where date(fecha)>='$fechai' and date(fecha)<='$fechaf'  and cancha_id = '$idCancha'");

    List<ReservaModel> list = res.isNotEmpty ? res.map((c) => ReservaModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ReservaModel>> obtenerReportePorRangoDeFechaDeEmpresa(String fechai, String fechaf, String idEmpresa) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Reservas where date(fecha)>='$fechai' and date(fecha)<='$fechaf'  and empresa_id = '$idEmpresa'");

    List<ReservaModel> list = res.isNotEmpty ? res.map((c) => ReservaModel.fromJson(c)).toList() : [];

    return list;
  }

  deleteReservas() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Reservas");

    return res;
  }

  deleteReservasPorId(String id) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Reservas where reserva_id = '$id'");

    return res;
  }
}

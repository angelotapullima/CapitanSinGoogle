/* 
class ReporteModel {
  ReporteModel({
    this.reservaId,
    this.canchaId,
    this.canchaNombre,
    this.reservaTipoPago,
    this.reservaFecha,
    this.reservaHora,
    this.reservaPago1,
    this.reservaPago2,
    this.empresaId,
    this.reservaNombre,
  });

  List<ReporteModel> dias;
  String reservaId;
  String canchaId;
  String canchaNombre;
  String reservaTipoPago;
  String reservaFecha;
  String reservaHora;
  String reservaPago1;
  String reservaPago2;
  String empresaId;
  String reservaNombre;
  String precioFinal;

  factory ReporteModel.fromJson(Map<String, dynamic> json) => ReporteModel(
        reservaId: json["reservaId"],
        canchaId: json["canchaId"],
        canchaNombre: json["canchaNombre"],
        reservaTipoPago: json["reservaTipoPago"],
        reservaFecha: json["reservaFecha"],
        reservaHora: json["reservaHora"],
        reservaPago1: json["reservaPago1"],
        reservaPago2: json["reservaPago2"],
        empresaId: json["empresaId"],
        reservaNombre: json["reservaNombre"],
      );

  Map<String, dynamic> toJson() => {
        "reservaId": reservaId,
        "canchaId": canchaId,
        "canchaNombre": canchaNombre,
        "reservaTipoPago": reservaTipoPago,
        "reservaFecha": reservaFecha,
        "reservaHora": reservaHora,
        "reservaPago1": reservaPago1,
        "reservaPago2": reservaPago2,
        "empresaId": empresaId,
        "reservaNombre": reservaNombre,
      };
}
 */

import 'package:capitan_sin_google/src/models/reserva_model.dart';

class ListSemanaReport {
  String semana;
  String monto;
  String cantidad;
  String fechaInicial;
  String fechaFinal;
  List<ReporteListFecha> listaDias;

  ListSemanaReport({this.semana, this.monto, this.cantidad, this.fechaInicial, this.fechaFinal, this.listaDias});
}

class ReporteListFecha {
  ReporteListFecha({
    this.reservaFecha,
    this.cantidad,
    this.listFechas,
    this.monto,
  });

  List<ReporteListCancha> listFechas;
  List<ReservaModel> listaReservas;
  String cantidad;
  String reservaFecha;
  String monto;
}

class ReporteListCancha {
  ReporteListCancha({
    this.canchaNombre,
    this.listCanchas,
    this.monto,
  });

  List<ReservaModel> listCanchas;

  String canchaNombre;
  String monto;
}

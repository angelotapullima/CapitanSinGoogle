

class ReporteMensualModel {
  String idReporteMensual;
  String numeroSemana;
  String anho;
  String fechaInicio;
  String fechaFinal;
  String monto;
  String cantidad;
  String idCancha;

  ReporteMensualModel({
    this.idReporteMensual,
    this.numeroSemana,
    this.anho,
    this.fechaInicio,
    this.fechaFinal,
    this.monto,
    this.cantidad,
    this.idCancha,
  });

  factory ReporteMensualModel.fromJson(Map<String, dynamic> json) =>
      ReporteMensualModel(
        idReporteMensual: json["idReporteMensual"],
        numeroSemana: json["numeroSemana"],
        anho: json["anho"],
        fechaInicio: json["fechaInicio"],
        fechaFinal: json["fechaFinal"],
        monto: json["monto"],
        cantidad: json["cantidad"],
        idCancha: json["idCancha"],
      );
}

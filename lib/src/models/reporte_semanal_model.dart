class ReporteSemanalModel {
  String idReporteSemanal;
  String fechaReporte;
  String dia;
  String mes;
  String monto;
  String cantidad;
  String idCancha;

  ReporteSemanalModel({
    this.idReporteSemanal,
    this.fechaReporte,
    this.monto,
    this.dia,
    this.mes,
    this.cantidad,
    this.idCancha,
  });

  factory ReporteSemanalModel.fromJson(Map<String, dynamic> json) =>
      ReporteSemanalModel(
        idReporteSemanal: json["idReporteSemanal"],
        fechaReporte: json["fechaReporte"],
        monto: json["monto"], 
        cantidad: json["cantidad"],
        idCancha: json["idCancha"],
      );
}

class VisitasCanchasModel {
  VisitasCanchasModel({
    this.idDato,
    this.idEmpresa,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  });

  int idDato;
  String idEmpresa;
  String year;
  String month;
  String day;
  String hour;
  String minute;
  String second;

  factory VisitasCanchasModel.fromJson(Map<String, dynamic> json) => VisitasCanchasModel(
        idDato: json["idDato"],
        idEmpresa: json["idEmpresa"],
        year: json["year"],
        month: json["month"],
        day: json["day"],
        hour: json["hour"],
        minute: json["minute"],
        second: json["second"],
      );
}

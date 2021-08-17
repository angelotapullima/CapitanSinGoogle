class VisitasPublicidadModel {
  VisitasPublicidadModel({
    this.idDato,
    this.idPublicidad,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  });

  int idDato;
  String idPublicidad;
  String year;
  String month;
  String day;
  String hour;
  String minute;
  String second;

  factory VisitasPublicidadModel.fromJson(Map<String, dynamic> json) => VisitasPublicidadModel(
        idDato: json["idDato"],
        idPublicidad: json["idPublicidad"],
        year: json["year"],
        month: json["month"],
        day: json["day"],
        hour: json["hour"],
        minute: json["minute"],
        second: json["second"],
      );
}

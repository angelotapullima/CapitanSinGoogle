class PublicidadModel {
  String idPublicidad;
  String ubigeoPublicidad;
  String imagenPublicidad;
  String linkPublicidad;
  String horaPublicidad;
  String diasPublicidad;
  String tipoPublicidad;
  String estadoPublicidad;

  PublicidadModel(
      {this.idPublicidad,
      this.ubigeoPublicidad,
      this.imagenPublicidad,
      this.linkPublicidad,
      this.horaPublicidad,
      this.diasPublicidad,
      this.tipoPublicidad,
      this.estadoPublicidad});

  factory PublicidadModel.fromJson(Map<String, dynamic> json) => PublicidadModel(
        idPublicidad: json["idPublicidad"],
        ubigeoPublicidad: json["ubigeoPublicidad"],
        imagenPublicidad: json["imagenPublicidad"],
        linkPublicidad: json["linkPublicidad"],
        horaPublicidad: json["horaPublicidad"],
        diasPublicidad: json["diasPublicidad"],
        tipoPublicidad: json["tipoPublicidad"],
        estadoPublicidad: json["fechaInicio"],
      );
}

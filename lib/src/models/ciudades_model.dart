
class CiudadesModel{

  String idCiudad;
  String ciudadDepartamento;
  String ciudadProvincia;
  String ciudadNombre;
  String ciudadDistrito;
  String ciudadCod;

  CiudadesModel({
    this.idCiudad,
    this.ciudadDepartamento,
    this.ciudadProvincia,
    this.ciudadNombre, 
    this.ciudadDistrito,
    this.ciudadCod,



  });


  factory CiudadesModel.fromJson(Map<String, dynamic> json) => CiudadesModel(
        idCiudad: json["idCiudad"],
        ciudadDepartamento: json["ciudad_departamento"],
        ciudadProvincia: json["ciudad_provincia"],
        ciudadNombre: json["ciudad_nombre"],
        ciudadDistrito: json["ciudad_distrito"],
        ciudadCod: json["ciudad_cod"],
        //detalle: List<ColaboracionesDetalle>.from(json["detalle"].map((x) => ColaboracionesDetalle.fromJson(x))),
    );




}
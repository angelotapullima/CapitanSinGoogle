


class UserRegisterModel {
  UserRegisterModel({
    this.email,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.posicion,
    this.nfav,
    this.habilidad,
    this.sexo,
    this.telefono,
    this.nacimiento,
    this.idCiudad,
  });

  String email;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String posicion;
  String nfav;
  String habilidad;
  String sexo;
  String telefono;
  String nacimiento;
  String idCiudad;

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) => UserRegisterModel(
    email: json["email"],
    nombre: json["nombre"],
    apellidoPaterno: json["apellidoPaterno"],
    apellidoMaterno: json["apellidoMaterno"],
    posicion: json["posicion"],
    nfav: json["nfav"],
    habilidad: json["habilidad"],
    sexo: json["sexo"],
    telefono: json["telefono"],
    nacimiento: json["nacimiento"],
    idCiudad: json["idCiudad"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "nombre": nombre,
    "apellidoPaterno": apellidoPaterno,
    "apellidoMaterno": apellidoMaterno,
    "posicion": posicion,
    "nfav": nfav,
    "habilidad": habilidad,
    "sexo": sexo,
    "telefono": telefono,
    "nacimiento": nacimiento,
    "idCiudad": idCiudad,
  };
}
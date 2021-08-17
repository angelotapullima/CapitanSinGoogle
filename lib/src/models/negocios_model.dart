import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';

class NegociosModel {
  List<NegociosModelResult> results;

  NegociosModel({
    this.results,
  });

  factory NegociosModel.fromJson(Map<String, dynamic> json) => NegociosModel(
        results: List<NegociosModelResult>.from(json["results"].map((x) => NegociosModelResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(
          results.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class NegociosModelResult {
  String nombre;
  String idEmpresa;
  String direccion;
  String telefono1;
  String telefono2;
  String lat;
  String lon;
  String descripcion;
  int valoracion;
  String foto;
  String estado;
  String usuario;
  String distrito;
  String horarioLs;
  String horarioD;
  String fechaActual;
  String horaActual;
  String dia;
  double promedio;
  dynamic conteo;
  String posicion;
  List<Rating> rating;
  List<Galeria> galeria;
  int soyAdmin;
  String distancia;

  List<CanchaDeporte> canchasDeporte;

  NegociosModelResult({
    this.nombre,
    this.idEmpresa,
    this.direccion,
    this.telefono1,
    this.telefono2,
    this.lat,
    this.lon,
    this.descripcion,
    this.valoracion,
    this.foto,
    this.estado,
    this.usuario,
    this.distrito,
    this.horarioLs,
    this.horarioD,
    this.fechaActual,
    this.horaActual,
    this.dia,
    this.promedio,
    this.conteo,
    this.rating,
    this.galeria,
    this.posicion,
    this.soyAdmin,
    this.distancia,
    this.canchasDeporte,
  });

  factory NegociosModelResult.fromJson(Map<String, dynamic> json) => NegociosModelResult(
        nombre: json["nombre"],
        idEmpresa: json["id_empresa"],
        direccion: json["direccion"],
        telefono1: json["telefono_1"],
        telefono2: json["telefono_2"],
        lat: json["lat"],
        lon: json["lon"],
        descripcion: json["descripcion"],
        valoracion: json["valoracion"],
        foto: json["foto"],
        estado: json["estado"],
        usuario: json["usuario"],
        distrito: json["distrito"],
        horarioLs: json["horario_ls"],
        horarioD: json["horario_d"],
        fechaActual: json["fecha_actual"],
        horaActual: json["hora_actual"],
        dia: json["dia"],
        promedio: json['promedio'] / 1,
        conteo: json["conteo"],
        rating: List<Rating>.from(json["rating"].map((x) => Rating.fromJson(x))),
        galeria: List<Galeria>.from(json["galeria"].map((x) => Galeria.fromJson(x))),
        posicion: json["posicion"],
        soyAdmin: json["soy_admin"],
      );

  factory NegociosModelResult.fromJsonDatabase(Map<String, dynamic> json) => NegociosModelResult(
        nombre: json["nombre"],
        idEmpresa: json["id_empresa"],
        direccion: json["direccion"],
        telefono1: json["telefono_1"],
        telefono2: json["telefono_2"],
        lat: json["lat"],
        lon: json["lon"],
        descripcion: json["descripcion"],
        valoracion: json["valoracion"],
        foto: json["foto"],
        estado: json["estado"],
        usuario: json["usuario"],
        distrito: json["distrito"],
        horarioLs: json["horario_ls"],
        horarioD: json["horario_d"],
        fechaActual: json["fecha_actual"],
        horaActual: json["hora_actual"],
        dia: json["dia"],
        promedio: json['promedio'] / 1,
        conteo: json["conteo"],
        /* rating        : List<Rating>.from(json["rating"].map((x) => Rating.fromJson(x))),
        galeria       : List<Galeria>.from(json["galeria"].map((x) => Galeria.fromJson(x))), */
        posicion: json["posicion"],
        soyAdmin: json["soy_admin"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "id_empresa": idEmpresa,
        "direccion": direccion,
        "telefono_1": telefono1,
        "telefono_2": telefono2,
        "lat": lat,
        "lon": lon,
        "descripcion": descripcion,
        "valoracion": valoracion,
        "foto": foto,
        "estado": estado,
        "usuario": usuario,
        "distrito": distrito,
        "horario_ls": horarioLs,
        "horario_d": horarioD,
        "fecha_actual": fechaActual,
        "hora_actual": horaActual,
        "dia": dia,
        "promedio": promedio,
        "conteo": conteo,
        "rating": List<dynamic>.from(rating.map((x) => x.toJson())),
        "galeria": List<dynamic>.from(galeria.map((x) => x.toJson())),
        "soy_admin": soyAdmin,
      };

  getFoto() {
    if (foto == null) {
      return 'https://cdn11.bigcommerce.com/s-hcp6qon/stencil/26c38110-5b4f-0138-d43f-0242ac11000e/icons/icon-no-image.svg';
    } else {
      return '$apiBaseURL/$foto';
    }
  }
}

class Galeria {
  String idGaleria;
  String idEmpresa;
  String galeriaFoto;

  Galeria({
    this.idGaleria,
    this.idEmpresa,
    this.galeriaFoto,
  });

  List<Galeria> fotos = [];

  Galeria.fromJsonList(List<dynamic> jsonList, String tipo) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final pelicula = new Galeria.fromJsonMap(item, tipo);
      fotos.add(pelicula);
    }
  }

  Galeria.fromJsonMap(Map<String, dynamic> json, String tipo) {
    if (tipo == 'bd') {
      idGaleria = json["idGaleria"];
    } else {
      idGaleria = json["idGaleria"];
    }

    idEmpresa = json["idEmpresa"];
    galeriaFoto = json["galeriaFoto"];
  }

  factory Galeria.fromJson(Map<String, dynamic> json) => Galeria(
        idGaleria: json["id_galeria"],
        idEmpresa: json["id_empresa"],
        galeriaFoto: json["galeria_foto"],
      );

  Map<String, dynamic> toJson() => {
        "id_galeria": idGaleria,
        "id_empresa": idEmpresa,
        "galeria_foto": galeriaFoto,
      };

  getGaleria() {
    if (galeriaFoto == null) {
      return 'https://cdn11.bigcommerce.com/s-hcp6qon/stencil/26c38110-5b4f-0138-d43f-0242ac11000e/icons/icon-no-image.svg';
    } else {
      return '$apiBaseURL/$galeriaFoto';
    }
  }
}

class Rating {
  int ratingEmpresaValor;
  String conteo;

  Rating({
    this.ratingEmpresaValor,
    this.conteo,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        ratingEmpresaValor: json["rating_empresa_valor"],
        conteo: json["conteo"],
      );

  Map<String, dynamic> toJson() => {
        "rating_empresa_valor": ratingEmpresaValor,
        "conteo": conteo,
      };
}

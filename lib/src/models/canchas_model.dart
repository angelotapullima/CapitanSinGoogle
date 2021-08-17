import 'package:capitan_sin_google/src/utils/constants.dart';

class Canchas {
  Canchas({
    this.results,
  });

  List<CanchasResult> results;

  factory Canchas.fromJson(Map<String, dynamic> json) => Canchas(
        results: List<CanchasResult>.from(json["results"].map((x) => CanchasResult.fromJson(x))),
      );
}

class CanchasResult {
  CanchasResult({
    this.idEmpresa,
    this.canchaId,
    this.nombre,
    this.dimensiones,
    this.precioD,
    this.precioN,
    this.foto,
    this.fechaActual,
    this.tipo,
    this.tipoNombre,
    this.deporte,
    this.deporteTipo,
    this.canchaEstado,
    this.promoPrecio,
    this.promoInicio,
    this.promoFin,
    this.promoEstado,
    this.precioCancha,
    this.horaCancha,
    this.fechaCancha,
    this.saldoActual,
    this.comision,
    this.soyAdmin,
    this.direccionEmpresa,
  });

  String idEmpresa;
  String canchaId;
  String nombre;
  String dimensiones;
  String precioD;
  String precioN;
  String foto;
  String fechaActual;
  String tipo;
  String tipoNombre;
  String deporte;
  String deporteTipo;
  String canchaEstado;
  String promoPrecio;
  String promoInicio;
  String promoFin;
  String promoEstado;

  String precioCancha;
  String horaCancha;
  String horaCanchaSinFormat;
  String fechaCancha;
  String saldoActual;
  String comision;
  String soyAdmin;
  String nombreEmpresa;
  String fotoEmpresa;
  String direccionEmpresa;

  factory CanchasResult.fromJson(Map<String, dynamic> json) => CanchasResult(
        idEmpresa: json["id_empresa"],
        canchaId: json["cancha_id"],
        nombre: json["nombre"],
        dimensiones: json["dimensiones"],
        precioD: json["precioD"],
        precioN: json["precioN"],
        foto: json["foto"],
        fechaActual: json["fecha_actual"],
        tipo: json["tipo"],
        tipoNombre: json["tipoNombre"],
        deporte: json["deporte"],
        deporteTipo: json["deporteTipo"],
        canchaEstado: json["canchaEstado"],
        promoPrecio: json["promo_precio"],
        promoInicio: json["promo_inicio"],
        promoFin: json["promo_fin"],
        promoEstado: json["promo_estado"],
      );

  getFoto() {
    if (foto == null) {
      return 'https://cdn11.bigcommerce.com/s-hcp6qon/stencil/26c38110-5b4f-0138-d43f-0242ac11000e/icons/icon-no-image.svg';
    } else {
      return '$apiBaseURL/$foto';
    }
  }
}

class CanchaDeporte {
  String deporteId;
  String deporteNombre;
  List<CanchasResult> canchasList;

  CanchaDeporte({
    this.deporteId,
    this.deporteNombre,
    this.canchasList,
  });
}

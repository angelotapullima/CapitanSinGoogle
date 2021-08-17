/* 


class DetalleReservaModel{
  DetalleReservaModel({
    this.reservaId,
    this.nombre,
    this.fecha,
    this.hora,
    this.canchaNombre,
    this.empresaNombre,
    this.pago1,
    this.pago1Date,
    this.pago2,
    this.pago2Date, 
    this.cliente, 
    this.numeroDeOperacion, 
    this.concepto, 
    this.tipoPago, 
    this.monto, 
    this.comision, 
    this.estado,
  });

  String reservaId;
  String nombre;
  String fecha;
  String hora;
  String canchaNombre;
  String empresaNombre;
  String pago1;
  String pago1Date;
  String pago2;
  String pago2Date;
  String cliente;
  String numeroDeOperacion;
  String concepto;
  String tipoPago;
  String monto;
  String comision;
  String estado;

  factory DetalleReservaModel.fromJson(Map<String, dynamic> json) => DetalleReservaModel(
    reservaId: json["id_reserva"],
    nombre: json["nombre"],
    fecha:  json["fecha"],
    hora: json["hora"],
    pago1: json["pago1"],
    pago1Date: json["pago1_date"],
    pago2: json["pago2"],
    pago2Date: json["pago2_date"], 
    cliente: json["cliente"], 
    numeroDeOperacion: json["numeroDeOperacion"], 
    concepto: json["concepto"], 
    tipoPago: json["tipo_pago"], 
    monto: json["monto"], 
    comision: json["comision"], 
    estado: json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "id_reserva": reservaId,
    "nombre": nombre,
    "fecha": fecha,
    "hora": hora,
    "pago1": pago1,
    "pago1_date": pago1Date,
    "pago2": pago2,
    "pago2_date": pago2Date,
    "cliente": cliente,
    "numeroDeOperacion": numeroDeOperacion,
    "concepto": concepto,
    "tipo_pago": tipoPago,
    "monto": monto,
    "comision": comision,
    "estado": estado,
  };
}
 */
class ReservaFechas {
  ReservaFechas({
    this.fecha,
    this.reservas,
  });

  String fecha;
  List<ReservaModel> reservas;
}

class ReservaModel {
  ReservaModel({
    this.reservaId,
    this.reservaNombre,
    this.reservaFecha,
    this.reservaHora,
    this.telefono,
    this.tipoPago,
    this.pago1,
    this.pago1Date,
    this.fechaFormateada1,
    this.pago2,
    this.pago2Date,
    this.fechaFormateada2,
    this.canchaId,
    this.pagoId,
    this.cliente,
    this.nroOperacion,
    this.concepto,
    this.monto,
    this.comision,
    this.reservaEstado,
    this.idUser,
    this.reservaCosto,
    this.reservaColor,
    this.reservaPrecioCancha,
    this.reservaHoraCancha,
    this.fechaReporte,
    this.empresaNombre,
    this.canchaNombre,
    this.empresaId,
    this.observacion,this.precioPromocionEstado
  });

  String reservaId;
  String reservaNombre;
  String reservaFecha;
  String reservaHora;
  String telefono;
  String tipoPago;
  String pago1;
  String pago1Date;
  String fechaFormateada1;
  String pago2;
  String pago2Date;
  String fechaFormateada2;
  String canchaId;
  String pagoId;
  String cliente;
  String nroOperacion;
  String concepto;
  String monto;
  String comision;
  String reservaEstado;
  String idUser;
  String precioPromocionEstado;

  String reservaCosto;
  String reservaColor;
  String reservaPrecioCancha;
  String reservaHoraCancha;
  String fechaReporte;

  String empresaNombre;
  String canchaNombre;
  String empresaId;

  String diaDeLaSemana;
  String observacion;

  factory ReservaModel.fromJson(Map<String, dynamic> json) => ReservaModel(
        reservaId: json["reserva_id"],
        reservaNombre: json["nombre"],
        reservaFecha: json["fecha"],
        reservaHora: json["hora"],
        tipoPago: json["tipopago"],
        pago1: json["pago1"],
        pago1Date: json["pago1_date"],
        fechaFormateada1: json["fecha_formateada_1"],
        pago2: json["pago2"],
        pago2Date: json["pago2_date"],
        fechaFormateada2: json["fecha_formateada_2"],
        canchaId: json["cancha_id"],
        empresaId: json["empresa_id"],
        pagoId: json["pago_id"],
        cliente: json["cliente"],
        nroOperacion: json["numeroDeOperacion"],
        concepto: json["concepto"],
        monto: json["monto"],
        comision: json["comision"],
        reservaEstado: json["estado"],
        idUser: json["idUser"],
        observacion: json["observacion"],
        precioPromocionEstado: json["precioPromocionEstado"],
      );
}

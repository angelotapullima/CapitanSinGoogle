import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VoucherReservaCanchaPage extends StatelessWidget {
  final CanchasResult canchaReserva;
  final ReservaModel reservaCancha;
  const VoucherReservaCanchaPage({Key key, @required this.canchaReserva, @required this.reservaCancha}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocNegocios = ProviderBloc.negocitos(context);
    blocNegocios.obtenernegociosPorId(this.canchaReserva.idEmpresa);
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black.withOpacity(.5),
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: responsive.wp(5), vertical: responsive.hp(3)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Container(
                      height: responsive.hp(7),
                      child: SvgPicture.asset(
                        'assets/svg/LOGO_CAPITAN.svg',
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(5),
                    ),
                    Text(
                      'Pagar Reserva',
                      style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    Text(
                      '${this.canchaReserva.nombre}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.ip(2.5),
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(5),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: responsive.wp(3)),
                          width: responsive.wp(30),
                          child: Text(
                            'Negocio',
                            style: TextStyle(
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          //width: responsive.wp(60),
                          child: Text(
                            '${this.reservaCancha.empresaNombre}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: responsive.wp(3)),
                          width: responsive.wp(30),
                          child: Text(
                            'Fecha y Hora',
                            style: TextStyle(
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          //width: responsive.wp(60),
                          child: Text(
                            '${this.reservaCancha.reservaHora}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: responsive.wp(3)),
                          width: responsive.wp(40),
                          child: Text(
                            'Pago Reserva',
                            style: TextStyle(
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: responsive.wp(40),
                          child: Text(
                            'S/. ${this.reservaCancha.reservaPrecioCancha}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: responsive.wp(3)),
                          width: responsive.wp(40),
                          child: Text(
                            'Comisión',
                            style: TextStyle(
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: responsive.wp(40),
                          child: Text(
                            (this.reservaCancha.comision != null) ? 'S/. ${this.reservaCancha.comision}' : 'S/. 00.00',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: responsive.wp(3)),
                          width: responsive.wp(40),
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: responsive.wp(40),
                          child: Text(
                            (this.reservaCancha.comision != null)
                                ? 'S/. ${double.parse(this.reservaCancha.reservaPrecioCancha) + double.parse(this.reservaCancha.comision)}'
                                : 'S/. ${this.reservaCancha.reservaPrecioCancha}',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(2.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(5),
                    ),
                    InkWell(
                        child: Container(
                            width: responsive.wp(70),
                            height: responsive.hp(6),
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              'Pagar Ahora',
                              style: TextStyle(color: Colors.white, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                            )))),
                    // SizedBox(
                    //   height: responsive.hp(2),
                    // ),
                    // InkWell(
                    //     child: Container(
                    //         width: responsive.wp(70),
                    //         height: responsive.hp(6),
                    //         decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    //         child: Center(
                    //             child: Text(
                    //           'Ver Recibo',
                    //           style: TextStyle(color: Colors.black, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                    //         )))),
                    SizedBox(
                      height: responsive.hp(5),
                    ),
                    Container(height: responsive.hp(10), child: SvgPicture.asset('assets/svg/LOGO_BUFEO.svg') //Image.asset('assets/logo_largo.svg'),
                        ),
                    SizedBox(
                      height: responsive.hp(5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

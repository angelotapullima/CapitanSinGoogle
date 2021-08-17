import 'dart:io';

import 'package:capitan_sin_google/src/api/reservas_api_2.dart';
import 'package:capitan_sin_google/src/models/reserva_cancha_2.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmarReservaCanchaAlert extends StatefulWidget {
  final ReservaCancha2Model canchita;
  const ConfirmarReservaCanchaAlert({Key key, @required this.canchita}) : super(key: key);

  @override
  _ConfirmarReservaCanchaAlertState createState() => _ConfirmarReservaCanchaAlertState();
}

class _ConfirmarReservaCanchaAlertState extends State<ConfirmarReservaCanchaAlert> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black.withOpacity(.5),
      child: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool data, Widget child) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    width: double.infinity,
                    height: responsive.hp(30),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(
                          height: responsive.hp(3),
                        ),
                        Container(
                          height: responsive.hp(7.5),
                          child: SvgPicture.asset(
                            'assets/svg/LOGO_BUFEO.svg',
                          ),
                        ),
                        Container(
                          height: responsive.hp(11),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(2),
                              ),
                              child: Text(
                                '¿Está seguro que desea realizar la Reserva de la cancha por un monto de S/ ${double.parse(widget.canchita.pago1) + double.parse(widget.canchita.pagoComision)}0?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.green,
                        ),
                        Container(
                          height: responsive.hp(5),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  _cargando.value = true;
                                  final reservasApi = Reservas2Api();
                                  final res = await reservasApi.pagarReservaCancha(widget.canchita);

                                  if (res) {
                                    showToast2('Operación realizada con éxito!!!', Colors.green);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    showToast2('Ocurrió un error, inténtelo luego', Colors.red);
                                    Navigator.pop(context);
                                  }
                                  _cargando.value = false;
                                  setState(() {});
                                },
                                child: Container(
                                  width: responsive.wp(43),
                                  child: Text(
                                    'Confirmar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.black),
                                  ),
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: responsive.wp(.2),
                                color: Colors.green,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: responsive.wp(43),
                                  child: Text(
                                    'Cancelar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.redAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                (data)
                    ? Center(
                        child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                      )
                    : Container()
              ],
            );
          }),
    );
  }
}

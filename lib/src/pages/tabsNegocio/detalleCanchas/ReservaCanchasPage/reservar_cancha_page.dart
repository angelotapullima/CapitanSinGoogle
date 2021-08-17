import 'dart:io';

import 'package:capitan_sin_google/src/models/reserva_cancha_2.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReservarCanchaPage extends StatefulWidget {
  final ReservaCancha2Model canchita;
  ReservarCanchaPage({
    Key key,
    @required this.canchita,
  }) : super(key: key);

  @override
  _ReservarCanchaPageState createState() => _ReservarCanchaPageState();
}

class _ReservarCanchaPageState extends State<ReservarCanchaPage> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  TextEditingController nombreReservaController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  //

  @override
  Widget build(BuildContext context) {
    //final prefsBufiPaymets = new PreferencesBufiPayments();
    final responsive = Responsive.of(context);
    return Scaffold(
      //backgroundColor: Color(0xFFFEF2E6),
      backgroundColor: Color(0xFFEBE5E5),
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool data, Widget child) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: responsive.hp(.5), horizontal: responsive.wp(3)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: responsive.ip(2.5),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Text(
                              'Reservar Cancha',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: responsive.ip(3),
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: responsive.hp(74),
                        margin: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(3)),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(45), color: Colors.white),
                        child: Stack(
                          children: [
                            Positioned(
                              left: -51,
                              top: 40,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Color(0xFF2141F3),
                              ),
                            ),
                            Positioned(
                              right: -51,
                              top: 40,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Color(0xFFFF9532),
                                //backgroundColor: Color(0xFFF9311A), Color(0xFFCBB6AA)
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: responsive.hp(1.5),
                                ),
                                Center(
                                  child: Text('Monto a pagar', style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFF4C4157))),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: responsive.ip(1)),
                                  child: Center(
                                    child: Text('S/ ${double.parse(widget.canchita.pago1) + double.parse(widget.canchita.pagoComision)}0',
                                        style: TextStyle(fontSize: responsive.ip(5), color: Colors.black, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Center(
                                  child: Text('${widget.canchita.nombreNegocio}',
                                      style: TextStyle(fontSize: responsive.ip(2.7), color: Color(0xFF4C4157))),
                                ),
                                Center(
                                  child: Text('${widget.canchita.nombreCancha}',
                                      style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFF4C4157), fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: responsive.hp(0.5),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(5),
                                    width: responsive.wp(75),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xFFF9311A),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: responsive.wp(3),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.calendar,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: responsive.wp(1),
                                        ),
                                        Text('${obtenerFecha(widget.canchita.fecha)}, ${widget.canchita.hora}',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Divider(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(2),
                                        ),
                                        width: responsive.wp(90),
                                        height: responsive.hp(8),
                                        child: TextField(
                                          cursorColor: Colors.black26,
                                          style: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                          keyboardType: TextInputType.text,
                                          //autofocus: true,
                                          decoration: InputDecoration(
                                              labelText: 'Nombre de la reserva',
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF2141F3)),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                              ),
                                              hintStyle: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                              hintText: 'Ingrese nombre'),
                                          enableInteractiveSelection: false,
                                          controller: nombreReservaController,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(2),
                                        ),
                                        width: responsive.wp(90),
                                        height: responsive.hp(8),
                                        child: TextField(
                                          cursorColor: Colors.black26,
                                          style: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                          keyboardType: TextInputType.number,
                                          //autofocus: true,
                                          decoration: InputDecoration(
                                              labelText: 'Teléfono de Contacto',
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF2141F3)),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                              ),
                                              hintStyle: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                              hintText: 'Ingrese número de teléfono'),
                                          enableInteractiveSelection: false,
                                          controller: telefonoController,
                                        ),
                                      ),
                                      SizedBox(
                                        height: responsive.hp(1),
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: responsive.wp(3),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.wallet,
                                            size: responsive.ip(2),
                                          ),
                                          SizedBox(
                                            width: responsive.wp(3),
                                          ),
                                          Text('Detalle del pago', style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFF4C4157))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: responsive.ip(1),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: responsive.wp(8),
                                          ),
                                          Text('Precio cancha', style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFF4C4157))),
                                          Spacer(),
                                          Text('S/ ${widget.canchita.pago1}',
                                              style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFF4C4157), fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: responsive.wp(1),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: responsive.ip(0.5),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: responsive.wp(8),
                                          ),
                                          Text('Comisión', style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFF4C4157))),
                                          Spacer(),
                                          Text('S/ ${widget.canchita.pagoComision}.00',
                                              style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFF4C4157), fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: responsive.wp(1),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: responsive.ip(0.5),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: responsive.wp(8),
                                          ),
                                          Text('Total',
                                              style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFF4C4157), fontWeight: FontWeight.bold)),
                                          Spacer(),
                                          Text('S/ ${double.parse(widget.canchita.pago1) + double.parse(widget.canchita.pagoComision)}0',
                                              style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFFF9311A), fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: responsive.wp(1),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: responsive.hp(1),
                                      ),
                                      Divider(),
                                      /* Row(
                                            children: [
                                              SizedBox(
                                                width: responsive.wp(3),
                                              ),
                                              Icon(
                                                FontAwesomeIcons.creditCard,
                                                size: responsive.ip(2),
                                              ),
                                              SizedBox(
                                                width: responsive.wp(3),
                                              ),
                                              Text('Método de Pago', style: TextStyle(fontSize: responsive.ip(2), color: Color(0xFF4C4157))),
                                            ],
                                          ),
                                          SizedBox(
                                            height: responsive.ip(1),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: responsive.wp(8)),
                                              InkWell(
                                                onTap: () async {
                                                  if (metodoPago != '1') {
                                                    metodoPago = '1';
                                                    _cargando.value = true;
                                                    final cuentaApi = CuentaApi();
                                                    await cuentaApi.obtenerCuenta();
                                                    _cargando.value = false;
                                                  } else {
                                                    metodoPago = '2';
                                                  }
            
                                                  setState(() {});
                                                },
                                                child: Container(
                                                    height: responsive.hp(6),
                                                    width: responsive.wp(15),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: (metodoPago == '1') ? Colors.teal : Colors.grey.withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 1.5,
                                                          offset: Offset(0, 1), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Image.asset(
                                                        'assets/img/LOGO_ALTERNO_1.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ) //Image.asset('assets/logo_largo.svg'),
                                                    ),
                                              ),
                                              (metodoPago == '2' || metodoPago == '0')
                                                  ? SizedBox(
                                                      width: responsive.wp(5),
                                                    )
                                                  : Spacer(),
                                              (metodoPago == '2' || metodoPago == '0')
                                                  ? InkWell(
                                                      onTap: () {
                                                        // metodoPago = '0';
                                                        // setState(() {});
                                                        showToast2('Aún no está disponible este método de pago', Colors.black);
                                                      },
                                                      child: Container(
                                                          height: responsive.hp(6),
                                                          width: responsive.wp(21),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: (metodoPago == '0') ? Colors.teal : Colors.grey.withOpacity(0.5),
                                                                spreadRadius: 1,
                                                                blurRadius: 1.5,
                                                                offset: Offset(0, 1), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text(
                                                                'Chanchas',
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                              )) //Image.asset('assets/logo_largo.svg'),
                                                          ),
                                                    )
                                                  : (prefsBufiPaymets.saldoCuentaBufiPayments != null)
                                                      ? Text('Saldo disponible: S/ ${prefsBufiPaymets.saldoCuentaBufiPayments}',
                                                          style: TextStyle(
                                                              fontSize: responsive.ip(2), color: Color(0xFF4C4157), fontWeight: FontWeight.bold))
                                                      : Container(),
                                            ],
                                          ),
                                         */
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (nombreReservaController.text.isNotEmpty) {
                            if (telefonoController.text.isNotEmpty) {
                              ReservaCancha2Model data = ReservaCancha2Model();
                              data.idCancha = widget.canchita.idCancha;
                              data.nombreReserva = nombreReservaController.text;
                              data.fecha = widget.canchita.fecha;
                              data.hora = widget.canchita.hora;
                              data.horaReserva = widget.canchita.horaReserva;
                              data.telefono = telefonoController.text;
                              data.tipoPago = '';
                              data.tipoUsuario = '1';
                              data.idColaboracion = '';
                              data.pago1 = widget.canchita.pago1;
                              data.pagoComision = widget.canchita.pagoComision;
                              data.estado = '1';

                              /*  Navigator.push(
                                context,
                                PageRouteBuilder(
                                  opaque: false,
                                  transitionDuration: const Duration(milliseconds: 400),
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return SeleccionarMetodoPago(
                                      canchita: data,
                                    );
                                  },
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              ); */
                            } else {
                              showToast2('Por favor ingrese un teléfono de contacto', Colors.black);
                            }
                          } else {
                            showToast2('Por favor ingrese el nombre de la reserva', Colors.black);
                          }
                        },
                        child: Container(
                          height: responsive.hp(7),
                          margin: EdgeInsets.symmetric(
                            vertical: responsive.hp(1),
                            horizontal: responsive.wp(3),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF040D97),
                          ),
                          child: Center(
                            child: Text(
                              'Continuar',
                              style: TextStyle(color: Colors.white, fontSize: responsive.ip(2), fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  (data)
                      ? Center(
                          child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                        )
                      : Container()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


import 'package:capitan_sin_google/src/api/reservas_api.dart';
import 'package:capitan_sin_google/src/bloc/canchas_bloc.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalle_reserva_page.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:capitan_sin_google/src/widgets/sliver_header_delegate.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'detalleCanchaBloc.dart';

class DetalleCanchas extends StatefulWidget {
  const DetalleCanchas({
    Key key,
    @required this.fechaActual,
    @required this.canchasResult,
    @required this.soyduenho,
  }) : super(key: key);
  final String fechaActual;
  final CanchasResult canchasResult;
  final int soyduenho;
  @override
  _DetalleCanchasState createState() => _DetalleCanchasState();
}

class _DetalleCanchasState extends State<DetalleCanchas> {
  String fechaBusqueda;
  String diaDeLaSemana;

  DateTime today;
  String idDeLaCancha;
  String fechaqueLlega;

  int cantidad = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final canchasBloc = ProviderBloc.canchas(context);

      final fechaFormat = widget.fechaActual.split(" ");
      fechaqueLlega = fechaFormat[0].trim();
      today = toDateMonthYear(DateTime.now());
      diaDeLaSemana = today.weekday.toString();

      print(widget.soyduenho);

      //canchasBloc.obtenerSaldo();

      canchasBloc.obtenerReservasPorIDCancha(widget.canchasResult.canchaId, fechaqueLlega, diaDeLaSemana);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final provider = Provider.of<DetalleCanchaBLoc>(context, listen: false);

    print('de nuevo');

    //canchasBloc.obtenerDatosDeCanchaPorId(widget.canchasResult.canchaId);

    provider.setEstadoAnimacion(false);

    return Scaffold(
      body: Stack(
        children: [
          _contenidoDetalleCanchas(widget.canchasResult, responsive, provider, widget.soyduenho),
          /*  CardBottom(
            idCancha: widget.canchasResult.canchaId,
            responsive: responsive,
            idEmpresa: widget.canchasResult.idEmpresa,
          ), */
          ValueListenableBuilder(
            valueListenable: provider.cargando,
            builder: (BuildContext context, bool data, Widget child) {
              return (data) ? _mostrarAlert() : Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _mostrarAlert() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: Container(
          height: 150.0,
          child: Lottie.asset('assets/lottie/balon_futbol.json'),
        ),
      ),
    );
  }

  Widget _contenidoDetalleCanchas(CanchasResult canchas, Responsive responsive, provider, int duenho) {
    return CustomScrollView(
      controller: provider.controller,
      slivers: [
        ValueListenableBuilder(
            valueListenable: provider.animacionCalendar,
            builder: (BuildContext context, bool data, Widget child) {
              return HeaderpersistentDCanchas(
                canchas: canchas,
                fechaActual: widget.fechaActual,
                soyAdmin: widget.soyduenho,
                animacion: data,
              );
            }),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(0),
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                ListReservas(
                  cancha: canchas,
                  fechaActual: widget.fechaActual,
                  duenho: duenho,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ListReservas extends StatefulWidget {
  final CanchasResult cancha;
  final String fechaActual;
  final int duenho;
  const ListReservas({Key key, @required this.cancha, @required this.fechaActual, @required this.duenho}) : super(key: key);

  @override
  _ListReservasState createState() => _ListReservasState();
}

class _ListReservasState extends State<ListReservas> {
  TextEditingController nombreReservaController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController montoPagarController = TextEditingController();
  TextEditingController observacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final canchasBloc = ProviderBloc.canchas(context);

    final responsive = Responsive.of(context);

    return StreamBuilder(
      stream: canchasBloc.reservasCanchasStream,
      builder: (context, AsyncSnapshot<List<ReservaModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(
                bottom: responsive.hp(0),
              ),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return _cardReservas(context, snapshot.data[i], widget.cancha);
              },
            );
          } else {
            return Center(
              child: CargandoWidget(),
            );
          }
        } else {
          return Center(
            child: CargandoWidget(),
          );
        }
      },
    );
  }

  void pedidoCorrecto() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contextd) {
        final responsive = Responsive.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Column(
            children: <Widget>[
              Container(height: responsive.ip(10), width: responsive.ip(29), child: SvgPicture.asset('assets/svg/LOGO_CAPITAN.svg') //Image.asset('assets/logo_largo.svg'),
                  ),
              Text('Se completo la reserva correctamente'),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  void modalVerdeAdmin(BuildContext context, CanchasBloc canchasBloc, CanchasResult cancha, String diaDeLaSemana, String fecha, String horaFormat, String precio,
      String nombreEmpresa, String hora) {
    nombreReservaController.text = "";
    montoPagarController.text = "";
    telefonoController.text = "";
    observacionController.text = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        final responsive = Responsive.of(context);

        /* nombreReservaController.text = "";
        montoPagarController.text = ""; */

        final provider = Provider.of<DetalleCanchaBLoc>(context, listen: false);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              margin: EdgeInsets.only(top: responsive.hp(5)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(20),
                    topStart: Radius.circular(20),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.only(
                  top: responsive.hp(2),
                  left: responsive.wp(5),
                  right: responsive.wp(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Reservar Cancha',
                        style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.home, color: Colors.green),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Flexible(
                          child: Text('$nombreEmpresa'),
                        ),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Flexible(
                          child: Text('-'),
                        ),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Icon(FontAwesomeIcons.futbol, color: Colors.green),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Flexible(
                          child: Text('${cancha.nombre}'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.calendar_today, color: Colors.green),
                        Flexible(
                          child: Text('$fecha'),
                        ),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Icon(Icons.alarm, color: Colors.green),
                        Flexible(
                          child: Text('$hora'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Text(
                      'Nombre de la reserva',
                      style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      width: responsive.wp(90),
                      height: responsive.hp(5.5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: TextField(
                        cursorColor: Colors.transparent,
                        maxLines: 1,
                        decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Ingresar nombre'),
                        enableInteractiveSelection: false,
                        controller: nombreReservaController,
                      ),
                    ),
                    Text(
                      'Teléfono de contacto',
                      style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      width: responsive.wp(90),
                      height: responsive.hp(5.5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: TextField(
                        cursorColor: Colors.transparent,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Ingresar número de teléfono'),
                        enableInteractiveSelection: false,
                        controller: telefonoController,
                      ),
                    ),
                    Text(
                      'Observaciones',
                      style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      width: responsive.wp(90),
                      height: responsive.hp(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: TextField(
                        cursorColor: Colors.transparent,
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Observaciones'),
                        enableInteractiveSelection: false,
                        controller: observacionController,
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Row(children: <Widget>[
                      Container(
                        width: responsive.wp(45),
                        height: responsive.hp(15),
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                'Costo de la cancha',
                                style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                color: Colors.black,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'S/.$precio',
                                      style: TextStyle(fontSize: responsive.ip(3), color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: responsive.wp(5),
                      ),
                      Container(
                        width: responsive.wp(40),
                        height: responsive.hp(15),
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                'Monto a pagar',
                                style: TextStyle(fontSize: responsive.ip(2.3), fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: responsive.hp(2.5),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(2),
                              ),
                              width: responsive.wp(44),
                              height: responsive.hp(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                              ),
                              child: TextField(
                                cursorColor: Colors.transparent,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: '0.0'),
                                enableInteractiveSelection: false,
                                controller: montoPagarController,
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: responsive.wp(40),
                          child: MaterialButton(
                            onPressed: () async {
                              if (nombreReservaController.text != "") {
                                if (montoPagarController.text != '') {
                                  if (telefonoController.text.isNotEmpty) {
                                    if (double.parse(montoPagarController.text) > double.parse(precio)) {
                                      showToast2('El monto de pago no debe ser mayor al precio de la cancha', Colors.amber);
                                    } else {
                                      if (double.parse(montoPagarController.text) < 0) {
                                        showToast2('El monto de pago no debe ser negativo', Colors.amber);
                                      } else {
                                        final reservaApi = ReservasApi();
                                        String estado;
                                        if (double.parse(montoPagarController.text) == double.parse(precio)) {
                                          estado = '1';
                                        } else {
                                          estado = '2';
                                        }

                                        var horex = separadorHora(horaFormat);
                                        Navigator.pop(context);
                                        provider.changeCargandoTrue();
                                        final res = await reservaApi.reservaVerdeAdmin(cancha.canchaId, nombreReservaController.text, '$horex', '$fecha', montoPagarController.text,
                                            estado, telefonoController.text, observacionController.text);

                                        if (res == 1) {
                                          nombreReservaController.text = "";
                                          montoPagarController.text = "";
                                          telefonoController.text = "";
                                          observacionController.text = "";

                                          canchasBloc.obtenerReservasPorIDCancha(widget.cancha.canchaId, fecha, diaDeLaSemana);
                                          pedidoCorrecto();
                                          //_refresher(canchasBloc, cancha);
                                          //pedticion correcta
                                        } else {
                                          //pedticion no correcta
                                          nombreReservaController.text = "";
                                          montoPagarController.text = "";
                                          telefonoController.text = "";
                                          observacionController.text = "";
                                        }

                                        provider.changeCargandoFalse();
                                      }
                                    }
                                  } else {
                                    showToast2('Debe ingresar un número de telefono', Colors.amber);
                                  }
                                } else {
                                  showToast2('Debe ingresar el monto de la reserva', Colors.amber);
                                }
                              } else {
                                showToast2('Debe ingresar el nombre de la reserva', Colors.amber);
                              }
                            },
                            color: Colors.green,
                            textColor: Colors.white,
                            child: Text('Reservar'),
                          ),
                        ),
                        SizedBox(
                          width: responsive.wp(10),
                        ),
                        SizedBox(
                          width: responsive.wp(40),
                          child: MaterialButton(
                            onPressed: () {
                              nombreReservaController.text = "";
                              montoPagarController.text = "";
                              Navigator.pop(context);
                            },
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text('Cancelar'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void modalNaranjaAdmin(CanchasBloc canchasBloc, String reservaId, CanchasResult cancha, String diaDeLaSemana, String fecha, String horaFormat, String precio,
      String nombreEmpresa, String hora, String pago, String nombreReserva) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        var montoPago = double.parse(precio) - double.parse(pago);
        final responsive = Responsive.of(context);

        final provider = Provider.of<DetalleCanchaBLoc>(context, listen: false);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.only(top: responsive.hp(10)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(20),
                    topStart: Radius.circular(20),
                  ),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(responsive.ip(1.8)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20),
                          topStart: Radius.circular(20),
                        ),
                        color: Colors.orange),
                    child: Center(
                      child: Text(
                        'Reservar Cancha',
                        style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.collections, color: Colors.green),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Flexible(
                              child: Text('$nombreEmpresa'),
                            ),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Flexible(
                              child: Text('-'),
                            ),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Icon(Icons.collections, color: Colors.green),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Flexible(
                              child: Text('${cancha.nombre}'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.calendar_today, color: Colors.green),
                            Flexible(
                              child: Text('$fecha'),
                            ),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Icon(Icons.copyright, color: Colors.green),
                            Flexible(
                              child: Text('$hora'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Text(
                          'Nombre de la reserva',
                          style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$nombreReserva',
                          style: TextStyle(fontSize: responsive.ip(2), color: Colors.black54, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Text(
                          'Reserva',
                          style: TextStyle(
                            fontSize: responsive.ip(2.5),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: Text(
                              'Costo de la cancha',
                              style: TextStyle(fontSize: responsive.ip(2)),
                            ),
                          ),
                          Text(
                            'S/ $precio',
                            style: TextStyle(fontSize: responsive.ip(2), color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ]),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Monto de Primer Pago',
                                style: TextStyle(
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                            Text(
                              '- S/ $pago',
                              style: TextStyle(fontSize: responsive.ip(2), color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: responsive.hp(.5),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Total a pagar',
                                style: TextStyle(
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                            Text(
                              'S/ $montoPago',
                              style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: responsive.wp(40),
                              child: MaterialButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                  provider.changeCargandoTrue();
                                  final reservaApi = ReservasApi();

                                  final res = await reservaApi.reservaNaranjaAdmin(reservaId, '$montoPago'.toString());

                                  if (res == 1) {
                                    canchasBloc.obtenerReservasPorIDCancha(widget.cancha.canchaId, fecha, diaDeLaSemana);
                                    //pedticion correctapedidoCorrecto();
                                    //_refresher(canchasBloc, cancha);

                                  } else {
                                    //pedticion no correcta

                                  }

                                  provider.changeCargandoFalse();
                                },
                                color: Colors.green,
                                textColor: Colors.white,
                                child: Text('Completar pago'),
                              ),
                            ),
                            SizedBox(
                              width: responsive.wp(10),
                            ),
                            SizedBox(
                              width: responsive.wp(40),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.red,
                                textColor: Colors.white,
                                child: Text('Cancelar'),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void modalNaranjaPagoParcialAdmin(CanchasBloc canchasBloc, String reservaId, CanchasResult cancha, String diaDeLaSemana, String fecha, String horaFormat, String precio,
      String nombreEmpresa, String hora, String pago, String nombreReserva) {
    montoPagarController.text = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        var montoPago = double.parse(precio) - double.parse(pago);
        final responsive = Responsive.of(context);

        final provider = Provider.of<DetalleCanchaBLoc>(context, listen: false);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.only(top: responsive.hp(10)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(20),
                    topStart: Radius.circular(20),
                  ),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(responsive.ip(1.8)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20),
                          topStart: Radius.circular(20),
                        ),
                        color: Colors.orange),
                    child: Center(
                      child: Text(
                        'Reservar Cancha',
                        style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.collections, color: Colors.green),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Flexible(
                              child: Text('$nombreEmpresa'),
                            ),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Flexible(
                              child: Text('-'),
                            ),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Icon(Icons.collections, color: Colors.green),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Flexible(
                              child: Text('${cancha.nombre}'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.calendar_today, color: Colors.green),
                            Flexible(
                              child: Text('$fecha'),
                            ),
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Icon(Icons.copyright, color: Colors.green),
                            Flexible(
                              child: Text('$hora'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Text(
                          'Nombre de la reserva',
                          style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$nombreReserva',
                          style: TextStyle(fontSize: responsive.ip(2), color: Colors.black54, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Text(
                          'Reserva',
                          style: TextStyle(
                            fontSize: responsive.ip(2.5),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: Text(
                              'Costo de la cancha',
                              style: TextStyle(fontSize: responsive.ip(2)),
                            ),
                          ),
                          Text(
                            'S/ $precio',
                            style: TextStyle(fontSize: responsive.ip(2), color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ]),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Monto de Primer Pago',
                                style: TextStyle(
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                            Text(
                              '- S/ $pago',
                              style: TextStyle(fontSize: responsive.ip(2), color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: responsive.hp(.5),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Resta por pagar',
                                style: TextStyle(
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                            Text(
                              'S/ $montoPago',
                              style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Monto a pagar',
                                style: TextStyle(
                                  fontSize: responsive.ip(2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(2),
                              ),
                              width: responsive.wp(44),
                              height: responsive.hp(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                              ),
                              child: TextField(
                                cursorColor: Colors.transparent,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: '0.0'),
                                enableInteractiveSelection: false,
                                controller: montoPagarController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: responsive.wp(40),
                              child: MaterialButton(
                                onPressed: () async {
                                  provider.changeCargandoTrue();
                                  if (montoPagarController.text != '') {
                                    if (double.parse(montoPagarController.text) <= montoPago) {
                                      Navigator.pop(context);
                                      final reservaApi = ReservasApi();

                                      final res = await reservaApi.reservaNaranPagoParcialjaAdmin(reservaId, montoPagarController.text);

                                      if (res == 1) {
                                        canchasBloc.obtenerReservasPorIDCancha(widget.cancha.canchaId, fecha, diaDeLaSemana);
                                        //pedticion correctapedidoCorrecto();
                                        //_refresher(canchasBloc, cancha);

                                      } else {
                                        //pedticion no correcta

                                      }
                                    } else {
                                      showToast2('El monto a pagar no debe ser mayor del restante', Colors.black);
                                    }
                                  } else {
                                    showToast2('Ingrese el monto a pagar ', Colors.black);
                                  }

                                  provider.changeCargandoFalse();
                                },
                                color: Colors.green,
                                textColor: Colors.white,
                                child: Text('Pagar'),
                              ),
                            ),
                            SizedBox(
                              width: responsive.wp(10),
                            ),
                            SizedBox(
                              width: responsive.wp(40),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.red,
                                textColor: Colors.white,
                                child: Text('Cancelar'),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _modalAccionReserva(String reservaId, ReservaModel reserva, CanchasBloc canchasBloc, String diaDeLaSemana, String fecha, CanchasResult cancha, String tipo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final responsive = Responsive.of(context);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.only(top: responsive.hp(10)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(20),
                    topStart: Radius.circular(20),
                  ),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(responsive.ip(1.8)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20),
                          topStart: Radius.circular(20),
                        ),
                        color: Colors.black),
                    child: Center(
                      child: Text(
                        'Que desea hacer?',
                        style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        (tipo == 'naranja')
                            ? Container(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);

                                        modalNaranjaPagoParcialAdmin(canchasBloc, reserva.reservaId, cancha, reserva.diaDeLaSemana, reserva.reservaFecha, reserva.reservaHoraCancha,
                                            reserva.reservaPrecioCancha, reserva.empresaNombre, reserva.reservaHora, reserva.pago1, reserva.reservaNombre);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: responsive.hp(1),
                                        ),
                                        width: double.infinity,
                                        child: Text(
                                          'Pago parcial',
                                          style: TextStyle(
                                            fontSize: responsive.ip(2),
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              )
                            : Container(),
                        (tipo == 'naranja')
                            ? Container(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);

                                        modalNaranjaAdmin(canchasBloc, reserva.reservaId, cancha, reserva.diaDeLaSemana, reserva.reservaFecha, reserva.reservaHoraCancha,
                                            reserva.reservaPrecioCancha, reserva.empresaNombre, reserva.reservaHora, reserva.pago1, reserva.reservaNombre);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: responsive.hp(1),
                                        ),
                                        width: double.infinity,
                                        child: Text(
                                          'Completar pago de reserva',
                                          style: TextStyle(
                                            fontSize: responsive.ip(2),
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              )
                            : Container(),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'detalleReserva', arguments: reservaId);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.hp(1),
                            ),
                            width: double.infinity,
                            child: Text(
                              'Ver detalle de Reserva',
                              style: TextStyle(
                                fontSize: responsive.ip(2),
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _cancelarReserva(reservaId, reserva, canchasBloc, diaDeLaSemana, fecha);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                            width: double.infinity,
                            child: Text(
                              'Cancelar Reserva',
                              style: TextStyle(
                                fontSize: responsive.ip(2),
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: responsive.hp(14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _cancelarReserva(String reservaId, ReservaModel reservas, CanchasBloc canchasBloc, String diaDeLaSemana, String fecha) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final responsive = Responsive.of(context);

        final provider = Provider.of<DetalleCanchaBLoc>(context, listen: false);

        int pago1 = (reservas.pago1 == null) ? 0 : double.parse('${reservas.pago1}').toInt();
        int pago2 = (reservas.pago2 == null) ? 0 : double.parse('${reservas.pago2}').toInt();
        int valor = pago1 + pago2;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.only(top: responsive.hp(10)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(20),
                    topStart: Radius.circular(20),
                  ),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(responsive.ip(1.8)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20),
                          topStart: Radius.circular(20),
                        ),
                        color: Colors.red),
                    child: Center(
                      child: Text(
                        'Cancelar Reserva',
                        style: TextStyle(
                          fontSize: responsive.ip(2.5),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.times,
                              color: Colors.red,
                              size: responsive.ip(10),
                            )
                          ],
                        ),
                        Text(
                          '¿Desea cancelar esta reserva?',
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: responsive.hp(2),
                          ),
                          child: TicketDetails(
                              firstTitle: 'Nombre de la reserva',
                              firstDesc: '${reservas.reservaNombre}',
                              secondTitle: 'Monto de pago',
                              secondDesc: 'S/. $valor',
                              responsive: responsive),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: responsive.hp(2),
                          ),
                          child:
                              TicketDetails(firstTitle: 'Hora de la reserva', firstDesc: '${reservas.reservaHoraCancha}', secondTitle: '', secondDesc: '', responsive: responsive),
                        ),
                        SizedBox(
                          height: responsive.hp(5),
                        ),
                        SizedBox(
                          width: responsive.wp(80),
                          child: MaterialButton(
                            color: Colors.red,
                            onPressed: () async {
                              Navigator.pop(context);
                              provider.changeCargandoTrue();
                              final reservaApi = ReservasApi();

                              final res = await reservaApi.cancelarReserva(reservaId);

                              if (res == 1) {
                                canchasBloc.obtenerReservasPorIDCancha(widget.cancha.canchaId, fecha, diaDeLaSemana);
                                //pedticion correctapedidoCorrecto();
                                //_refresher(canchasBloc, cancha);

                              } else {
                                //pedticion no correcta

                              }

                              provider.changeCargandoFalse();
                            },
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cardReservas(BuildContext context, ReservaModel reserva, CanchasResult cancha) {
    final canchasBloc = ProviderBloc.canchas(context);
    final responsive = Responsive.of(context);
    String saldoActual;
    String comisionActual;
    var color = Color(0xff239f23);
    var reservaNombre = '---';
    var reservaDisponibilidad = 'Disponible';
    var precio = reserva.reservaPrecioCancha;
    if (reserva.reservaEstado == '1') {
      precio = reserva.reservaPrecioCancha;
      color = Colors.red;
      reservaDisponibilidad = 'Alquilado';
      reservaNombre = reserva.reservaNombre;
    } else if (reserva.reservaEstado == '2') {
      precio = reserva.pago1;
      color = Colors.orange;
      reservaDisponibilidad = 'Reservado';
      reservaNombre = reserva.reservaNombre;
    }
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(2),
          vertical: responsive.hp(.5),
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: responsive.hp(1.3),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(2),
                vertical: responsive.hp(1),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${reserva.reservaHora}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(2.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${obtenerFecha(reserva.reservaFecha)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2),
                    ),
                  ),
                  Text(
                    '$reservaNombre',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2),
                    ),
                  ),
                  (reservaDisponibilidad == 'Disponible')
                      ? (reserva.precioPromocionEstado == '1')
                          ? Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Promoción ',
                                  style: TextStyle(
                                    color: Colors.yellow[600],
                                    fontSize: ScreenUtil().setSp(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'S/. ${double.parse('$precio').toInt().toString()}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Spacer(),
                                Text(
                                  'S/. ${double.parse('$precio').toInt().toString()}',
                                  style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                      : Row(
                          children: [
                            Spacer(),
                            Text(
                              'S/. ${double.parse('$precio').toInt().toString()}',
                              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                  vertical: responsive.hp(.5),
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  '$reservaDisponibilidad',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        //if (double.parse(saldoActual) > 0) {
        if (widget.duenho == 1) {
          //eres Administraidor
          if (reserva.reservaEstado == '1') {
            /* Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return VistaDetalleReserva();
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),s
                  ); */
            _modalAccionReserva(reserva.reservaId, reserva, canchasBloc, reserva.diaDeLaSemana, reserva.reservaFecha, cancha, 'rojo');
          } else if (reserva.reservaEstado == '2') {
            _modalAccionReserva(reserva.reservaId, reserva, canchasBloc, reserva.diaDeLaSemana, reserva.reservaFecha, cancha, 'naranja');
          } else {
            modalVerdeAdmin(context, canchasBloc, cancha, reserva.diaDeLaSemana, reserva.reservaFecha, reserva.reservaHoraCancha, reserva.reservaPrecioCancha,
                reserva.empresaNombre, reserva.reservaHora);
          }
        } 
      },
    );
  }
}

class HeaderpersistentDCanchas extends StatefulWidget {
  const HeaderpersistentDCanchas({
    Key key,
    @required this.canchas,
    @required this.fechaActual,
    @required this.soyAdmin,
    @required this.animacion,
  }) : super(key: key);

  final CanchasResult canchas;
  final String fechaActual;
  final int soyAdmin;
  final bool animacion;

  @override
  _HeaderpersistentDCanchasState createState() => _HeaderpersistentDCanchasState();
}

class _HeaderpersistentDCanchasState extends State<HeaderpersistentDCanchas> {
  DatePickerController _controller = DatePickerController();
  String fechaBusqueda;
  String diaDeLaSemana;
  String idDeLaCancha;
  String fechaqueLlega;
  DateTime today;
  int dias;

  DateTime initialData;

  @override
  void initState() {
    today = toDateMonthYear(DateTime.now());

    if (widget.soyAdmin == 1) {
      initialData = toDateMonthYear(
        today.subtract(
          Duration(days: 15),
        ),
      );
      dias = 45;
      print('admin');
    } else {
      print('no admin');
      initialData = today;
      dias = 30;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final canchasBloc = ProviderBloc.canchas(context);

    final provider = Provider.of<DetalleCanchaBLoc>(context, listen: false);

    if (!widget.animacion) {
      Future.delayed(Duration(milliseconds: 2000), () {
        //_controller.animateToDate(initialData);

        _controller.animateToDate(today);
        provider.setEstadoAnimacion(true);
      });
    }

    //canchasBloc.obtenerSaldo();

    return SliverPersistentHeader(
      floating: true,
      delegate: SliverCustomHeaderDelegate(
        maxHeight: responsive.hp(28),
        minHeight: responsive.hp(28),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              centerTitle: false,
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Text(
                '${widget.canchas.nombre}',
                style: TextStyle(color: Colors.black, fontSize: responsive.ip(1.8)),
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                ),
                child: DatePicker(
                  initialData,
                  height: responsive.hp(13),
                  width: responsive.wp(15),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.black,
                  locale: 'es_Es',
                  controller: _controller,
                  dateTextStyle: TextStyle(
                    fontSize: responsive.ip(2.6),
                  ),
                  monthTextStyle: TextStyle(
                    fontSize: responsive.ip(1.4),
                  ),
                  dayTextStyle: TextStyle(
                    fontSize: responsive.ip(1.2),
                  ),
                  daysCount: dias,
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    print(date);
                    fechaBusqueda = date.toString();
                    diaDeLaSemana = date.weekday.toString();

                    final fechaFormat = fechaBusqueda.split(" ");
                    fechaqueLlega = fechaFormat[0].trim();
                    canchasBloc.obtenerReservasPorIDCancha(
                      widget.canchas.canchaId,
                      fechaqueLlega,
                      diaDeLaSemana,
                    );

                    _controller.animateToDate(date);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<DateTime> getDateList(DateTime firstDate, DateTime lastDate) {
  List<DateTime> list = [];
  int count = daysCount(toDateMonthYear(firstDate), toDateMonthYear(lastDate));
  for (int i = 0; i < count; i++) {
    list.add(toDateMonthYear(firstDate).add(Duration(days: i)));
  }
  return list;
}

DateTime toDateMonthYear(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

int daysCount(DateTime first, DateTime last) => last.difference(first).inDays + 1;

enum LabelType {
  date,
  month,
  weekday,
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:capitan_sin_google/src/api/reservas_api.dart';
import 'package:capitan_sin_google/src/bloc/canchas_bloc.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/canchas_model.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalleCanchas/pantalla_coyuntura.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalle_reserva_page.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/constants.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:capitan_sin_google/src/utils/utils.dart';
import 'package:capitan_sin_google/src/widgets/sliver_header_delegate.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          CardBottom(
            idCancha: widget.canchasResult.canchaId,
            responsive: responsive,
            idEmpresa: widget.canchasResult.idEmpresa,
          ),
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
                bottom: responsive.hp(30),
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
              Container(
                  height: responsive.ip(10),
                  width: responsive.ip(29),
                  child: SvgPicture.asset('assets/svg/LOGO_CAPITAN.svg') //Image.asset('assets/logo_largo.svg'),
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

  void modalVerdeAdmin(BuildContext context, CanchasBloc canchasBloc, CanchasResult cancha, String diaDeLaSemana, String fecha, String horaFormat,
      String precio, String nombreEmpresa, String hora) {
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
                        decoration:
                            InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Ingresar nombre'),
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
                        decoration: InputDecoration(
                            border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Ingresar número de teléfono'),
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
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: responsive.wp(1), vertical: responsive.hp(1)),
                                      width: responsive.wp(7),
                                      child: Image(
                                        image: AssetImage('assets/img/2.png'),
                                      ),
                                    ),
                                    Text(
                                      '$precio',
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
                        height: responsive.hp(14),
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                'Monto a pagar',
                                style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
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
                                        provider.setIndex(true);
                                        final res = await reservaApi.reservaVerdeAdmin(cancha.canchaId, nombreReservaController.text, '$horex',
                                            '$fecha', montoPagarController.text, estado, telefonoController.text, observacionController.text);

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
                                        provider.setIndex(false);
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

  void modalNaranjaAdmin(CanchasBloc canchasBloc, String reservaId, CanchasResult cancha, String diaDeLaSemana, String fecha, String horaFormat,
      String precio, String nombreEmpresa, String hora, String pago, String nombreReserva) {
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

                                  provider.setIndex(true);
                                  final reservaApi = ReservasApi();

                                  final res = await reservaApi.reservaNaranjaAdmin(reservaId, '$montoPago'.toString());

                                  if (res == 1) {
                                    canchasBloc.obtenerReservasPorIDCancha(widget.cancha.canchaId, fecha, diaDeLaSemana);
                                    //pedticion correctapedidoCorrecto();
                                    //_refresher(canchasBloc, cancha);

                                  } else {
                                    //pedticion no correcta

                                  }
                                  provider.setIndex(false);
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

  void _modalAccionReserva(
      String reservaId, ReservaModel reserva, CanchasBloc canchasBloc, String diaDeLaSemana, String fecha, CanchasResult cancha, String tipo) {
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

                                        modalNaranjaAdmin(
                                            canchasBloc,
                                            reserva.reservaId,
                                            cancha,
                                            reserva.diaDeLaSemana,
                                            reserva.reservaFecha,
                                            reserva.reservaHoraCancha,
                                            reserva.reservaPrecioCancha,
                                            reserva.empresaNombre,
                                            reserva.reservaHora,
                                            reserva.pago1,
                                            reserva.reservaNombre);
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
                          child: TicketDetails(
                              firstTitle: 'Hora de la reserva',
                              firstDesc: '${reservas.reservaHoraCancha}',
                              secondTitle: '',
                              secondDesc: '',
                              responsive: responsive),
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
                              provider.setIndex(true);
                              final reservaApi = ReservasApi();

                              final res = await reservaApi.cancelarReserva(reservaId);

                              if (res == 1) {
                                canchasBloc.obtenerReservasPorIDCancha(widget.cancha.canchaId, fecha, diaDeLaSemana);
                                //pedticion correctapedidoCorrecto();
                                //_refresher(canchasBloc, cancha);

                              } else {
                                //pedticion no correcta

                              }
                              provider.setIndex(false);
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
    if (reserva.reservaEstado == '1') {
      color = Colors.red;
      reservaDisponibilidad = 'Reservado';
      reservaNombre = reserva.reservaNombre;
    } else if (reserva.reservaEstado == '2') {
      color = Colors.orange;
      reservaDisponibilidad = 'Reservado';
      reservaNombre = reserva.reservaNombre;
    }
    return StreamBuilder(
        stream: canchasBloc.saldoStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              saldoActual = snapshot.data[0].cuentaSaldo;
              comisionActual = snapshot.data[0].comision;
            } else {
              saldoActual = '0';
              comisionActual = '0';
            }
          } else {
            saldoActual = '0';
            comisionActual = '0';
          }
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: responsive.wp(2),
                vertical: responsive.hp(.5),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(2),
                vertical: responsive.hp(1),
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
              child: Column(
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
                      Container(
                        color: Colors.black.withOpacity(.7),
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: responsive.wp(1), vertical: responsive.hp(1)),
                              width: responsive.wp(7),
                              child: Image(
                                image: AssetImage('assets/img/2.png'),
                              ),
                            ),
                            Text(
                              double.parse('${reserva.reservaPrecioCancha}').toInt().toString(),
                              style: TextStyle(color: Colors.white, fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: responsive.wp(85),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${reserva.reservaFecha}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(2),
                              ),
                            ),
                            Text(
                              '$reservaDisponibilidad',
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
                          ],
                        ),
                      ),
                      Container(
                        width: responsive.wp(7),
                      )
                    ],
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
                  modalVerdeAdmin(context, canchasBloc, cancha, reserva.diaDeLaSemana, reserva.reservaFecha, reserva.reservaHoraCancha,
                      reserva.reservaPrecioCancha, reserva.empresaNombre, reserva.reservaHora);
                }
              } else {
                if (reserva.reservaEstado != '1' && reserva.reservaEstado != '2') {
                  //CanchasResult canchasResult = CanchasResult();
                  /*  CanchasResult canchasResult = CanchasResult();
                  canchasResult.precioCancha = reserva.reservaPrecioCancha;
                  canchasResult.horaCancha = reserva.reservaHora;
                  canchasResult.fechaCancha = reserva.reservaFecha;
                  canchasResult.canchaId = cancha.canchaId;
                  canchasResult.saldoActual = saldoActual;
                  canchasResult.comision = comisionActual;
                  canchasResult.horaCanchaSinFormat = reserva.reservaHoraCancha;

                  ReservaCancha2Model datosReserva = ReservaCancha2Model();
                  datosReserva.idCancha = cancha.canchaId;
                  datosReserva.nombreCancha = cancha.nombre;
                  datosReserva.nombreNegocio = reserva.empresaNombre;
                  datosReserva.fecha = reserva.reservaFecha;
                  datosReserva.hora = reserva.reservaHora;
                  datosReserva.horaReserva = reserva.reservaHoraCancha;
                  datosReserva.tipoUsuario = widget.duenho.toString();
                  datosReserva.pago1 = reserva.reservaPrecioCancha;
                  datosReserva.pagoComision = '3';

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 700),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ReservarCanchaPage(
                          canchita: datosReserva,
                        );
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );

                 */

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return PantallaCoyuntura(
                          idEmpresa: widget.cancha.idEmpresa,
                        );
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                }
              }
            },
          );
        });
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
                  height: responsive.hp(12),
                  width: responsive.wp(15),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.green,
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

class CardBottom extends StatelessWidget {
  const CardBottom({
    Key key,
    @required this.responsive,
    @required this.idCancha,
    @required this.idEmpresa,
  }) : super(key: key);

  final Responsive responsive;
  final String idCancha;
  final String idEmpresa;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DetalleCanchaBLoc>(context, listen: false);

    final canchasBloc = ProviderBloc.canchas(context);
    canchasBloc.obtenerDatosDeCanchaPorId(idCancha, idEmpresa);
    return ValueListenableBuilder<bool>(
      valueListenable: bloc.show,
      builder: (_, value, __) {
        return AnimatedPositioned(
          bottom: value ? responsive.hp(00) : -responsive.hp(30),
          left: 0,
          right: 0,
          duration: Duration(milliseconds: 500),
          child: Container(
            height: responsive.hp(30),
            margin: EdgeInsets.only(
              left: responsive.wp(2),
              right: responsive.wp(2),
              top: responsive.hp(4),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: StreamBuilder(
              stream: canchasBloc.datosCanchaPorId,
              builder: (context, AsyncSnapshot<List<CanchasResult>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                        vertical: responsive.hp(1),
                      ),
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                              imageUrl: '$apiBaseURL/${snapshot.data[0].foto}',
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(2),
                                horizontal: responsive.wp(2),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                ),
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: responsive.hp(.5),
                                    ),
                                    height: responsive.ip(4),
                                    width: responsive.ip(4),
                                    child: Image(
                                      image: AssetImage('assets/img/6-ok.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${snapshot.data[0].direccionEmpresa}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: responsive.ip(2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(2),
                                horizontal: responsive.wp(2),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: responsive.wp(55),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${snapshot.data[0].nombre}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(2),
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data[0].dimensiones}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(2),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: responsive.wp(2)),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                color: Colors.red,
                                                width: responsive.wp(5),
                                                height: responsive.hp(1),
                                              ),
                                              Text(
                                                'Alquilado',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: responsive.ip(2),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                color: Colors.orange,
                                                width: responsive.wp(5),
                                                height: responsive.hp(1),
                                              ),
                                              Text(
                                                'Reservado',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: responsive.ip(2),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                color: Colors.green,
                                                width: responsive.wp(5),
                                                height: responsive.hp(1),
                                              ),
                                              Text(
                                                'Disponible',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: responsive.ip(2),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
            ),
          ),
        );
      },
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

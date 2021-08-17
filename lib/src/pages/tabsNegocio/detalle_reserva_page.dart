import 'dart:io';
import 'dart:typed_data';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/bloc/reservas_bloc.dart';
import 'package:capitan_sin_google/src/models/reserva_model.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/circle.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';

class DetalleReserva extends StatefulWidget {
  const DetalleReserva({Key key}) : super(key: key);

  @override
  _DetalleReservaState createState() => _DetalleReservaState();
}

class _DetalleReservaState extends State<DetalleReserva> {
  Uint8List _imageFile;
  List<String> imagePaths = [];
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
//Create an instance of ScreenshotController

    final String idReserva = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);
    final reservaBloc = ProviderBloc.reservas(context);
    reservaBloc.obtenerReservaPorIdReserva(idReserva);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: reservaBloc.reservasPorIdReservaStream,
              builder: (BuildContext context, AsyncSnapshot<List<ReservaModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Screenshot(
                          controller: screenshotController,
                          child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(1),
                                horizontal: responsive.wp(2),
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: responsive.hp(1),
                                horizontal: responsive.wp(2),
                              ),
                              child: _tickerDetails(responsive, snapshot.data[0])),
                        ),
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
              }),
          _fondo(),
          _fondo2(),
          _contenido(responsive, reservaBloc),
          Positioned(
            top: responsive.hp(8),
            left: responsive.wp(4),
            child: GestureDetector(
              child: CircleContainer(
                  radius: responsive.ip(2.5), color: Colors.grey[100], widget: BackButton() //Icon(Icons.arrow_back, color: Colors.black),
                  ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: responsive.hp(8.5),
            right: responsive.wp(4),
            child: GestureDetector(
              child: CircleContainer(
                  radius: responsive.ip(2.5), color: Colors.grey[100], widget: Icon(Icons.share) //Icon(Icons.arrow_back, color: Colors.black),
                  ),
              onTap: () async {
                takeScreenshotandShare();
              },
            ),
          ),
        ],
      ),
    );
  }

  takeScreenshotandShare() async {
    var now = DateTime.now();
    var nombre = now.microsecond.toString();
    _imageFile = null;
    screenshotController.capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0).then((Uint8List image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image);

      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
      print("File Saved to Gallery");

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile;
      File imgFile = new File('$directory/Screenshot$nombre.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");

      imagePaths.add(imgFile.path);
      await Future.delayed(Duration(seconds: 1));

      ShareExtend.shareMultiple(imagePaths, "image", subject: "carnet");
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget _contenido(Responsive responsive, ReservasBloc reservaBloc) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: responsive.hp(2),
          horizontal: responsive.wp(2),
        ),
        child: FlutterTicketWidget(
          width: double.infinity,
          height: double.infinity,
          isCornerRounded: true,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(5),
            ),
            child: StreamBuilder(
              stream: reservaBloc.reservasPorIdReservaStream,
              builder: (BuildContext context, AsyncSnapshot<List<ReservaModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return SingleChildScrollView(child: _tickerDetails(responsive, snapshot.data[0]));
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
        ),
      ),
    );
  }

  Widget _tickerDetails(Responsive responsive, ReservaModel reservas) {
    var estadoReserva;
    bool mostrarDetalle2;
    var concepto1;
    var concepto2;
    var total = double.parse(reservas.pago1) + double.parse(reservas.pago2) + double.parse(reservas.comision);

    if (double.parse(reservas.pago2) > 0) {
      mostrarDetalle2 = true;

      var conceptos = reservas.concepto.split('|');
      concepto1 = conceptos[0];
      concepto2 = conceptos[1];
    } else {
      mostrarDetalle2 = false;
      concepto1 = reservas.concepto;
    }

    if (reservas.reservaEstado == '1') {
      estadoReserva = 'Pagado';
    } else if (reservas.reservaEstado == '2') {
      estadoReserva = 'Pagado Parcialmente';
    }
    return Padding(
      padding: EdgeInsets.only(left: responsive.wp(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: responsive.ip(10),
                  width: responsive.ip(29),
                  child: SvgPicture.asset('assets/svg/LOGO_CAPITAN.svg') //Image.asset('assets/logo_largo.svg'),
                  ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: responsive.hp(2)),
            child: Text(
              'Detalle de reserva',
              style: TextStyle(color: Colors.black, fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: responsive.ip(2.8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Número de operación',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.hp(1),
                  ),
                  child: Text(
                    '${reservas.nroOperacion}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                ('${reservas.tipoPago}' == '0')
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(
                          top: responsive.hp(2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: responsive.wp(45),
                              child: Padding(
                                padding: EdgeInsets.only(left: responsive.ip(1)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Cliente',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: responsive.hp(1)),
                                      child: Text(
                                        '${reservas.cliente}',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: responsive.wp(45),
                              child: Padding(
                                padding: EdgeInsets.only(right: responsive.wp(2)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Tipo de pago',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: responsive.hp(1)),
                                      child: Text(
                                        '${reservas.tipoPago}',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                Row(
                  children: <Widget>[
                    Container(
                      width: responsive.wp(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Fecha de primer Pago',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${reservas.pago1Date}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: responsive.wp(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Estado de reserva',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '$estadoReserva',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                (mostrarDetalle2)
                    ? Row(
                        children: <Widget>[
                          Container(
                            width: responsive.wp(40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Fecha de segundo Pago',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${reservas.pago2Date}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: responsive.wp(40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Text(
                  'Nombre de la reserva',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.hp(1),
                  ),
                  child: Text(
                    '${reservas.reservaNombre}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                (reservas.observacion != '')
                    ? Text(
                        'Observaciones',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    : Container(),
                (reservas.observacion != '')
                    ? Padding(
                        padding: EdgeInsets.only(top: responsive.hp(1)),
                        child: Text(
                          '${reservas.observacion}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            height: responsive.hp(2.5),
          ),
          Text(
            'Reserva',
            style: TextStyle(color: Colors.red, fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: responsive.hp(1),
          ),
          Row(
            children: <Widget>[
              Container(
                width: responsive.wp(62),
                child: Text(
                  '$concepto1',
                  style: TextStyle(fontSize: responsive.ip(1.5)),
                ),
              ),
              SizedBox(
                width: responsive.wp(5),
              ),
              Text(
                'S/.${reservas.pago1}',
                style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.redAccent, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: responsive.hp(3),
          ),
          (!mostrarDetalle2)
              ? Container()
              : Row(
                  children: <Widget>[
                    Container(
                      width: responsive.wp(62),
                      child: Text(
                        '$concepto2',
                        style: TextStyle(fontSize: responsive.ip(1.5)),
                      ),
                    ),
                    SizedBox(
                      width: responsive.wp(5),
                    ),
                    Text(
                      'S/.${reservas.pago2}',
                      style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.redAccent, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
          SizedBox(
            height: responsive.wp(2),
          ),
          Row(
            children: <Widget>[
              Container(
                width: responsive.wp(62),
                child: Text(
                  'Comisión por reserva',
                  style: TextStyle(fontSize: responsive.ip(2)),
                ),
              ),
              SizedBox(
                width: responsive.wp(10),
              ),
              Text(
                'S/.${reservas.comision} ',
                style: TextStyle(fontSize: responsive.ip(2), color: Colors.redAccent, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: responsive.wp(2),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Container(
                width: responsive.wp(62),
                child: Text(
                  'Total',
                  style: TextStyle(fontSize: responsive.ip(2)),
                ),
              ),
              Spacer(),
              Text(
                'S/.$total ',
                style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.redAccent, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: responsive.hp(4),
          )
        ],
      ),
    );
  }

  Widget _fondo() {
    return Image(
      image: AssetImage('assets/img/pasto2.webp'),
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _fondo2() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.4),
    );
  }
}

class TicketDetails extends StatelessWidget {
  const TicketDetails({
    Key key,
    @required this.firstTitle,
    @required this.firstDesc,
    @required this.secondTitle,
    @required this.secondDesc,
    @required this.responsive,
  }) : super(key: key);

  final String firstTitle;
  final String firstDesc;
  final String secondTitle;
  final String secondDesc;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: responsive.ip(1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: responsive.hp(1)),
                child: Text(
                  firstDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: responsive.wp(2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                secondTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: responsive.hp(1)),
                child: Text(
                  secondDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
